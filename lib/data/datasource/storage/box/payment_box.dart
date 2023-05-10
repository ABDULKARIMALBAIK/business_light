import 'dart:developer';

import 'package:isar/isar.dart';

import '../../../../domain/entity/order.dart';
import '../../../../domain/entity/payment.dart';
import '../../../../domain/entity/user.dart';

// Storage Box to make operations on Payments
class PaymentBox extends PaymentBoxOperations {
  PaymentBox(this._store);

  final Isar _store;

  /// add new payment on the storage
  @override
  Future<void> addPaymentStorage(Payment payment, Order? selectedOrder) async {
    await _store.writeTxn(() async {
      await _store.payments.put(payment);
    });

    if (selectedOrder != null) {
      final currentOrder = await _store.orders.get(selectedOrder.id ?? 0);
      if (currentOrder != null) {
        await _store.writeTxn(() async {
          currentOrder.payments.add(payment);
          _store.orders.put(currentOrder);
          await currentOrder.payments.save();
        });
      }
    }
  }

  /// edit the payment on the storage
  @override
  Future<void> editPaymentStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PaymentType paymentType,
      required DateTime date}) async {
    await _store.writeTxn(() async {
      final editPayment = await _store.payments.get(id!);

      editPayment!.code = code;
      editPayment.price = price;
      editPayment.description = description;
      editPayment.date = date;
      editPayment.paymentType = paymentType;
      await _store.payments.put(editPayment);
    });
  }

  /// delete the payment on the storage
  @override
  Future<void> deletePaymentStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.payments.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

  /// Get customer's payments data from storage
  @override
  Future<List<Payment>> getAllCustomerPaymentsStorage(User customer) async {
    List<Order> customerOrders = [];
    var query = _store.orders.filter().idIsNotNull();
    query = query.user((user) => user
        .idEqualTo(customer.id)
        .and()
        .fullNameEqualTo(customer.fullName)
        .and()
        .emailEqualTo(customer.email));
    // query.sortByDateDesc();
    customerOrders = await query.findAll();

    List<Payment> customerPayments = [];
    for (Order order in customerOrders) {
      customerPayments.addAll(order.payments);
    }

    customerPayments.sort((a, b) => Comparable.compare(b.id!, a.id!));
    return customerPayments;
  }

  /// Get payments data from storage
  @override
  Future<List<Payment>> getAllPaymentStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PaymentType? paymentType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc}) async {
    List<Payment> payments = [];
    var query = _store.payments.filter().idIsNotNull();

    if (filterCode != null) {
      if (filterCode.isNotEmpty) {
        query = query.codeContains(filterCode, caseSensitive: false);
      }
    }

    if (filterPrice != null) {
      query = query.priceEqualTo(filterPrice);
    }

    if (filterDescription != null) {
      if (filterDescription.isNotEmpty) {
        query =
            query.descriptionContains(filterDescription, caseSensitive: false);
      }
    }

    if (startDate != null) {
      query = query.dateGreaterThan(
          DateTime(startDate.year, startDate.month, startDate.day, 0, 0),
          include: true);
    }

    if (endDate != null) {
      query = query.dateLessThan(
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59),
          include: true);
    }

    // if (startDate != null || endDate != null) {
    //   query = query.dateBetween(startDate, endDate,
    //       includeLower: true, includeUpper: true);
    // }

    if (paymentType != null) {
      if (paymentType == PaymentType.order) {
        query = query.paymentTypeEqualTo(PaymentType.order);
      } else if (paymentType == PaymentType.other) {
        query = query.paymentTypeEqualTo(PaymentType.other);
      }
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            payments = await query.findAll();
            break;
          }
        //By Code
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                payments = await query.sortByCode().findAll();
              } else {
                payments = await query.sortByCodeDesc().findAll();
              }
            }
            break;
          }
        //By Price
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                payments = await query.sortByPrice().findAll();
              } else {
                payments = await query.sortByPriceDesc().findAll();
              }
            }
            break;
          }
        //By Description
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                payments = await query.sortByDescription().findAll();
              } else {
                payments = await query.sortByDescriptionDesc().findAll();
              }
            }
            break;
          }
        //By Date
        case 4:
          {
            if (desc != null) {
              if (!desc) {
                payments = await query.sortByDate().findAll();
              } else {
                payments = await query.sortByDateDesc().findAll();
              }
            }
            break;
          }
        //By Payment Type
        case 5:
          {
            if (desc != null) {
              if (!desc) {
                payments = await query.sortByPaymentType().findAll();
              } else {
                payments = await query.sortByPaymentTypeDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            payments = await query.findAll();
            break;
          }
      }
    }

    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            payments = await query.findAll();
            payments.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return payments;
  }
}

//! Define all repo's methods of Payment
abstract class PaymentBoxOperations {
  Future<List<Payment>> getAllPaymentStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PaymentType? paymentType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<List<Payment>> getAllCustomerPaymentsStorage(User customer);

  Future<void> deletePaymentStorage(int? id);
  Future<void> addPaymentStorage(Payment payment, Order? selectedOrder);
  Future<void> editPaymentStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PaymentType paymentType,
      required DateTime date});
}

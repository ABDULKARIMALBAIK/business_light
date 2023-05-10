import 'dart:developer';

import 'package:business_light/domain/entity/product_order.dart';
import 'package:isar/isar.dart';

import '../../../../domain/entity/order.dart';
import '../../../../domain/entity/payment.dart';
import '../../../../domain/entity/user.dart';

// Storage Box to make operations on Orders
class OrderBox extends OrderBoxOperations {
  OrderBox(this._store);

  final Isar _store;

  /// add new order on the storage
  @override
  Future<void> addOrderStorage(Order order, List<ProductOrder> productsOrders,
      List<Payment> payments) async {
    for (var productOrder in productsOrders) {
      await _store.writeTxn(() async {
        await _store.productOrders.put(productOrder);
      });
    }
    order.products.addAll(productsOrders);

    for (var payment in payments) {
      await _store.writeTxn(() async {
        await _store.payments.put(payment);
      });
    }
    order.payments.addAll(payments);

    await _store.writeTxn(() async {
      await _store.orders.put(order);
    });

    await _store.writeTxn(() async {
      await order.user.save();
      await order.payments.save();
      await order.products.save();
    });
  }

  /// Get customers data from storage
  @override
  Future<List<Order>> getAllCustomerOrdersStorage(User customer) async {
    List<Order> customerOrders = [];
    var query = _store.orders.filter().idIsNotNull();
    query = query.user((user) => user.idEqualTo(customer.id));
    query.sortByDateDesc();
    customerOrders = await query.findAll();

    return customerOrders;
  }

  /// delete the order on the storage
  @override
  Future<void> deleteOrderStorage(int? id) async {
    Order? currentOrder = await _store.orders.get(id ?? 0);
    if (currentOrder != null) {
      IsarLinks<ProductOrder> products = currentOrder.products;
      IsarLinks<Payment> payments = currentOrder.payments;

      for (var product in products) {
        await _store.writeTxn(() async {
          await _store.productOrders.delete(product.id ?? 0);
        });
      }

      for (var payment in payments) {
        await _store.writeTxn(() async {
          await _store.payments.delete(payment.id ?? 0);
        });
      }

      await currentOrder.products.save();
      await currentOrder.payments.save();
      await _store.writeTxn(() async {
        final success = await _store.orders.delete(id ?? 0);
        log('delete is successful $success');
      });
    }
  }

  /// Get orders data from storage
  @override
  getAllOrdersStorage(
      {String? codeFilterController,
      double? greaterTotalPriceFilterController,
      double? lessTotalPriceFilterController,
      double? greaterPricePiecesFilterController,
      double? lessPricePiecesFilterController,
      double? greaterFinalPriceFilterController,
      double? lessFinalPriceFilterController,
      String? descriptionFilterController,
      DateTime? selectedStartDate,
      DateTime? selectedEndDate,
      TypeOrder? typeFilter,
      User? filterCustomer,
      int? filterIndexSort,
      bool? desc}) async {
    List<Order> orders = [];
    var query = _store.orders.filter().idIsNotNull();

    if (codeFilterController != null) {
      if (codeFilterController.isNotEmpty) {
        query = query.codeContains(codeFilterController, caseSensitive: false);
      }
    }

    if (greaterTotalPriceFilterController != null) {
      query = query.totalPriceGreaterThan(greaterTotalPriceFilterController,
          include: true);
    }

    if (lessTotalPriceFilterController != null) {
      query = query.totalPriceLessThan(lessTotalPriceFilterController,
          include: true);
    }

    // if (greaterPricePiecesFilterController != null) {
    //   query = query.pricePiecesGreaterThan(greaterPricePiecesFilterController,
    //       include: true);
    // }

    // if (lessPricePiecesFilterController != null) {
    //   query = query.pricePiecesLessThan(lessPricePiecesFilterController,
    //       include: true);
    // }

    if (greaterFinalPriceFilterController != null) {
      query = query.finalPriceGreaterThan(greaterFinalPriceFilterController,
          include: true);
    }

    if (lessFinalPriceFilterController != null) {
      query = query.finalPriceLessThan(lessFinalPriceFilterController,
          include: true);
    }

    if (descriptionFilterController != null) {
      if (descriptionFilterController.isNotEmpty) {
        query = query.descriptionContains(descriptionFilterController,
            caseSensitive: false);
      }
    }

    if (selectedStartDate != null) {
      query = query.dateGreaterThan(
          DateTime(selectedStartDate.year, selectedStartDate.month,
              selectedStartDate.day, 0, 0),
          include: true);
    }

    if (selectedEndDate != null) {
      query = query.dateLessThan(
          DateTime(selectedEndDate.year, selectedEndDate.month,
              selectedEndDate.day, 23, 59),
          include: true);
    }

    // if (selectedStartDate != null) {
    //   query = query.dateGreaterThan(selectedStartDate, include: true);
    // }

    // if (selectedEndDate != null) {
    //   query = query.dateLessThan(selectedEndDate, include: true);
    // }

    if (typeFilter != null) {
      if (typeFilter == TypeOrder.negotiation) {
        query = query.typeEqualTo(TypeOrder.negotiation);
      } else if (typeFilter == TypeOrder.deal) {
        query = query.typeEqualTo(TypeOrder.deal);
      } else if (typeFilter == TypeOrder.sell) {
        query = query.typeEqualTo(TypeOrder.sell);
      } else if (typeFilter == TypeOrder.complete) {
        query = query.typeEqualTo(TypeOrder.complete);
      }
    }

    if (filterCustomer != null) {
      query = query.user((user) => user.idEqualTo(filterCustomer.id));
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            orders = await query.findAll();
            break;
          }
        //By Code
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                orders = await query.sortByCode().findAll();
              } else {
                orders = await query.sortByCodeDesc().findAll();
              }
            }
            break;
          }
        //By Total Qty
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                orders = await query.sortByTotalQty().findAll();
              } else {
                orders = await query.sortByTotalQtyDesc().findAll();
              }
            }
            break;
          }
        //By QTY Pieces
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                orders = await query.sortByQtyPieces().findAll();
              } else {
                orders = await query.sortByQtyPiecesDesc().findAll();
              }
            }
            break;
          }
        //By Price Pieces
        // case 4:
        //   {
        //     if (desc != null) {
        //       if (!desc) {
        //         orders = await query.sortByPricePieces().findAll();
        //       } else {
        //         orders = await query.sortByPricePiecesDesc().findAll();
        //       }
        //     }
        //     break;
        //   }
        //By Total Price
        case 5:
          {
            if (desc != null) {
              if (!desc) {
                orders = await query.sortByTotalPrice().findAll();
              } else {
                orders = await query.sortByTotalPriceDesc().findAll();
              }
            }
            break;
          }
        //By Final Price
        case 6:
          {
            if (desc != null) {
              if (!desc) {
                orders = await query.sortByFinalPrice().findAll();
              } else {
                orders = await query.sortByFinalPriceDesc().findAll();
              }
            }
            break;
          }
        //By Date
        case 7:
          {
            if (desc != null) {
              if (!desc) {
                orders = await query.sortByDate().findAll();
              } else {
                orders = await query.sortByDateDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            orders = await query.findAll();
            break;
          }
      }
    }
    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            orders = await query.findAll();
            orders.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return orders;
  }
}

//! Define all repo's methods of ORder
abstract class OrderBoxOperations {
  Future<List<Order>> getAllOrdersStorage(
      {String? codeFilterController,
      double? greaterTotalPriceFilterController,
      double? lessTotalPriceFilterController,
      double? greaterPricePiecesFilterController,
      double? lessPricePiecesFilterController,
      double? greaterFinalPriceFilterController,
      double? lessFinalPriceFilterController,
      String? descriptionFilterController,
      DateTime? selectedStartDate,
      DateTime? selectedEndDate,
      TypeOrder? typeFilter,
      User? filterCustomer,
      int? filterIndexSort,
      bool? desc});
  Future<List<Order>> getAllCustomerOrdersStorage(User customer);

  Future<void> deleteOrderStorage(int? id);
  Future<void> addOrderStorage(
      Order order, List<ProductOrder> productsOrders, List<Payment> payments);
}

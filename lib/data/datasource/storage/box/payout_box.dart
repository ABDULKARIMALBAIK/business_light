import 'dart:developer';

import 'package:isar/isar.dart';

import '../../../../domain/entity/payout.dart';
import '../../../../domain/entity/user.dart';

// Storage Box to make operations on Payouts
class PayoutBox extends PayoutBoxOperations {
  PayoutBox(this._store);

  final Isar _store;

  /// add new payout on the storage
  @override
  Future<void> addPayoutStorage(Payout payout) async {
    await _store.writeTxn(() async {
      await _store.payouts.put(payout);
      await payout.employeeSalary.save();
    });
  }

  /// edit the payout on the storage
  @override
  Future<void> editPayoutStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PayoutType payoutType,
      required DateTime date}) async {
    await _store.writeTxn(() async {
      final editPayout = await _store.payouts.get(id!);

      editPayout!.code = code;
      editPayout.price = price;
      editPayout.description = description;
      editPayout.date = date;
      editPayout.payoutType = payoutType;
      await _store.payouts.put(editPayout);
    });
  }

  /// delete the payout on the storage
  @override
  Future<void> deletePayoutStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.payouts.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

  /// Get employees from storage
  @override
  Future<List<User>> loadAllEmployeesStorage() {
    return _store.users
        .filter()
        .not()
        .levelEqualTo(UserLevel.customer)
        .findAll();
  }

  /// Get payouts data from storage
  @override
  Future<List<Payout>> getAllPayoutStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PayoutType? payoutType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc}) async {
    List<Payout> payouts = [];
    var query = _store.payouts.filter().idIsNotNull();

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

    if (payoutType != null) {
      if (payoutType == PayoutType.debt) {
        query = query.payoutTypeEqualTo(PayoutType.debt);
      } else if (payoutType == PayoutType.salary) {
        query = query.payoutTypeEqualTo(PayoutType.salary);
      } else if (payoutType == PayoutType.tax) {
        query = query.payoutTypeEqualTo(PayoutType.tax);
      } else if (payoutType == PayoutType.other) {
        query = query.payoutTypeEqualTo(PayoutType.other);
      }
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            payouts = await query.findAll();
            break;
          }
        //By Code
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByCode().findAll();
              } else {
                payouts = await query.sortByCodeDesc().findAll();
              }
            }
            break;
          }
        //By Price
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByPrice().findAll();
              } else {
                payouts = await query.sortByPriceDesc().findAll();
              }
            }
            break;
          }
        //By Description
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByDescription().findAll();
              } else {
                payouts = await query.sortByDescriptionDesc().findAll();
              }
            }
            break;
          }
        //By Date
        case 4:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByDate().findAll();
              } else {
                payouts = await query.sortByDateDesc().findAll();
              }
            }
            break;
          }
        //By payout Type
        case 5:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByPayoutType().findAll();
              } else {
                payouts = await query.sortByPayoutTypeDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            payouts = await query.findAll();
            break;
          }
      }
    }

    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            payouts = await query.findAll();
            payouts.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return payouts;
  }

  /// Get customer's payouts data from storage
  @override
  Future<List<Payout>> getAllPayoutsEmployeeStorage(
      {double? filterPrice,
      DateTime? startDate,
      DateTime? endDate,
      User? userDetails,
      int? filterIndexSort,
      bool? desc}) async {
    List<Payout> payouts = [];
    var query = _store.payouts.filter().idIsNotNull();
    query = query.payoutTypeEqualTo(PayoutType.salary);
    query =
        query.employeeSalary((employee) => employee.idEqualTo(userDetails!.id));

    if (filterPrice != null) {
      query = query.priceEqualTo(filterPrice);
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

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            payouts = await query.findAll();
            break;
          }
        //By Price
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByPrice().findAll();
              } else {
                payouts = await query.sortByPriceDesc().findAll();
              }
            }
            break;
          }
        //By Date
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                payouts = await query.sortByDate().findAll();
              } else {
                payouts = await query.sortByDateDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            payouts = await query.findAll();
            break;
          }
      }
    }

    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            payouts = await query.findAll();
            payouts.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return payouts;
  }
}

//! Define all repo's methods of Payout
abstract class PayoutBoxOperations {
  Future<List<Payout>> getAllPayoutStorage(
      {String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PayoutType? payoutType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePayoutStorage(int? id);
  Future<void> addPayoutStorage(Payout payout);
  Future<void> editPayoutStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PayoutType payoutType,
      required DateTime date});
  Future<List<User>> loadAllEmployeesStorage();
  Future<List<Payout>> getAllPayoutsEmployeeStorage(
      {double? filterPrice,
      DateTime? startDate,
      DateTime? endDate,
      User? userDetails,
      int? filterIndexSort,
      bool? desc});
}

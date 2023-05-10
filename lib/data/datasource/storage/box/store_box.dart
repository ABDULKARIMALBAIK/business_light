import 'dart:developer';

import 'package:isar/isar.dart';

import '../../../../domain/entity/status.dart';
import '../../../../domain/entity/store.dart';

// Storage Box to make operations on Stores
class StoreBox extends StoreBoxOperations {
  StoreBox(this._store);

  final Isar _store;

  /// Get stores data from storage
  @override
  Future<List<Store>> getAllStores(
      {String? filterName,
      String? filterCode,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc}) async {
    List<Store> stores = [];
    var query = _store.stores.filter().idIsNotNull();

    if (filterName != null) {
      if (filterName.isNotEmpty) {
        query = query.nameContains(filterName, caseSensitive: false);
      }
    }

    if (filterCode != null) {
      if (filterCode.isNotEmpty) {
        query = query.codeEqualTo(filterCode, caseSensitive: false);
      }
    }

    if (filterStatus != null) {
      if (filterStatus == Status.active) {
        query = query.statusEqualTo(Status.active);
      } else if (filterStatus == Status.inactive) {
        query = query.statusEqualTo(Status.inactive);
      }
    }

    if (filterIndexSort != null) {
      switch (filterIndexSort) {
        //By Id
        case 0:
          {
            stores = await query.findAll();
            break;
          }
        //By Name
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                stores = await query.sortByName().findAll();
              } else {
                stores = await query.sortByNameDesc().findAll();
              }
            }
            break;
          }
        //By Code
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                stores = await query.sortByCode().findAll();
              } else {
                stores = await query.sortByCodeDesc().findAll();
              }
            }
            break;
          }
        //By Status
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                stores = await query.sortByStatus().findAll();
              } else {
                stores = await query.sortByStatusDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            stores = await query.findAll();
            break;
          }
      }
    }
    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            stores = await query.findAll();
            stores.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return stores;
  }

  /// add new store on the storage
  @override
  Future<void> addStoreStorage(Store store) async {
    await _store.writeTxn(() async {
      await _store.stores.put(store);
    });
  }

  /// delete the store on the storage
  @override
  Future<void> deleteStoreStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.stores.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

  /// edit the store on the storage
  @override
  Future<void> editStoreStorage(
      int? id, String name, String code, Status statusAddEdit) async {
    await _store.writeTxn(() async {
      final editStore = await _store.stores.get(id!);

      editStore!.name = name;
      editStore.code = code;
      editStore.status = statusAddEdit;
      await _store.stores.put(editStore);
    });
  }
}

//! Define all repo's methods of Store
abstract class StoreBoxOperations {
  Future<List<Store>> getAllStores(
      {String? filterName,
      String? filterCode,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc});
  Future<void> deleteStoreStorage(int? id);
  Future<void> addStoreStorage(Store store);
  Future<void> editStoreStorage(
      int? id, String name, String code, Status statusAddEdit);
}

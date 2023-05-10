import 'dart:developer';

import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/entity/status.dart';
import 'package:isar/isar.dart';

// Storage Box to make operations on Brands
class BrandBox extends BrandBoxOperations {
  BrandBox(this._store);

  final Isar _store;

  /// Get brands data from storage
  @override
  Future<List<Brand>> getAllBrands(
      {String? filterName,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc}) async {
    List<Brand> brands = [];
    var query = _store.brands.filter().idIsNotNull();

    if (filterName != null) {
      if (filterName.isNotEmpty) {
        query = query.nameContains(filterName, caseSensitive: false);
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
            brands = await query.findAll();
            break;
          }
        //By Name
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                brands = await query.sortByName().findAll();
              } else {
                brands = await query.sortByNameDesc().findAll();
              }
            }
            break;
          }
        //By Status
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                brands = await query.sortByStatus().findAll();
              } else {
                brands = await query.sortByStatusDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            brands = await query.findAll();
            break;
          }
      }
    }
    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            brands = await query.findAll();
            brands.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }
    return brands;
  }

  /// delete the brand on the storage
  @override
  Future<void> deleteBrandStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.brands.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

  /// add new brand on the storage
  @override
  Future<void> addBrandStorage(Brand brand) async {
    await _store.writeTxn(() async {
      await _store.brands.put(brand);
    });
  }

  /// edit the brand on the storage
  @override
  Future<void> editBrandStorage(
      int? id, String name, Status statusAddEdit) async {
    await _store.writeTxn(() async {
      final editBrand = await _store.brands.get(id!);

      editBrand!.name = name;
      editBrand.status = statusAddEdit;
      await _store.brands.put(editBrand);
    });
  }
}

//! Define all repo's methods of Brand
abstract class BrandBoxOperations {
  Future<List<Brand>> getAllBrands(
      {String? filterName,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc});
  Future<void> deleteBrandStorage(int? id);
  Future<void> addBrandStorage(Brand brand);
  Future<void> editBrandStorage(int? id, String name, Status statusAddEdit);
}

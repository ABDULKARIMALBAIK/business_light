import 'dart:developer';

import 'package:isar/isar.dart';

import '../../../../domain/entity/brand.dart';
import '../../../../domain/entity/product.dart';
import '../../../../domain/entity/status.dart';
import '../../../../domain/entity/store.dart';

// Storage Box to make operations on Products
class ProductBox extends ProductBoxOperations {
  ProductBox(this._store);

  final Isar _store;

  /// add new product on the storage
  @override
  Future<void> addProductStorage(Product product) async {
    await _store.writeTxn(() async {
      await _store.products.put(product);
      await product.brand.save();
      await product.store.save();
    });
  }

  /// delete the product on the storage
  @override
  Future<void> deleteProductStorage(int? id) async {
    await _store.writeTxn(() async {
      final success = await _store.products.delete(id ?? 0);
      log('delete is successful $success');
    });
  }

  /// Get products data from storage
  @override
  Future<List<Product>> getAllProductsStorage(
      {String? filterName,
      String? filterCode,
      String? filterSKU,
      String? filterDescription,
      double? filterGreaterUnitPrice,
      double? filterLessUnitPrice,
      double? filterGreaterPackagePrice,
      double? filterLessPackagePrice,
      int? filterUnitsQuantity,
      int? filterPackagesQuantity,
      int? filterPaidPackagesQuantity,
      DateTime? filterStartDate,
      DateTime? filterEndDate,
      Brand? filterBrand,
      Store? filterStore,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc}) async {
    List<Product> products = [];
    var query = _store.products.filter().idIsNotNull();

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

    if (filterSKU != null) {
      if (filterSKU.isNotEmpty) {
        query = query.skuEqualTo(filterSKU, caseSensitive: false);
      }
    }

    if (filterDescription != null) {
      if (filterDescription.isNotEmpty) {
        query =
            query.descriptionContains(filterDescription, caseSensitive: false);
      }
    }

    if (filterGreaterUnitPrice != null) {
      query =
          query.newFinalPriceGreaterThan(filterGreaterUnitPrice, include: true);
    }

    if (filterLessUnitPrice != null) {
      query = query.newFinalPriceLessThan(filterLessUnitPrice, include: true);
    }

    if (filterGreaterPackagePrice != null) {
      query = query.newFinalPricePackageGreaterThan(filterGreaterPackagePrice,
          include: true);
    }

    if (filterLessPackagePrice != null) {
      query = query.newFinalPricePackageLessThan(filterLessPackagePrice,
          include: true);
    }

    if (filterUnitsQuantity != null) {
      query = query.qtyPackageEqualTo(filterUnitsQuantity);
    }

    if (filterPackagesQuantity != null) {
      query = query.totalPackagesEqualTo(filterPackagesQuantity);
    }

    if (filterPaidPackagesQuantity != null) {
      query = query.paidTotalPackagesEqualTo(filterPaidPackagesQuantity);
    }

    if (filterStartDate != null) {
      query = query.dateGreaterThan(
          DateTime(filterStartDate.year, filterStartDate.month,
              filterStartDate.day, 0, 0),
          include: true);
    }

    if (filterEndDate != null) {
      query = query.dateLessThan(
          DateTime(filterEndDate.year, filterEndDate.month, filterEndDate.day,
              23, 59),
          include: true);
    }

    // if (filterStartDate != null || filterEndDate != null) {
    //   query = query.dateBetween(filterStartDate, filterEndDate,
    //       includeLower: true, includeUpper: true);
    // }

    if (filterBrand != null) {
      query = query.brand((brand) =>
          brand.nameContains(filterBrand.name ?? '', caseSensitive: false));
    }

    if (filterStore != null) {
      query = query.store((store) =>
          store.nameContains(filterStore.name ?? '', caseSensitive: false));
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
            products = await query.findAll();
            break;
          }
        //By Name
        case 1:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByName().findAll();
              } else {
                products = await query.sortByNameDesc().findAll();
              }
            }
            break;
          }
        //By Code
        case 2:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByCode().findAll();
              } else {
                products = await query.sortByCodeDesc().findAll();
              }
            }
            break;
          }
        //By SKU
        case 3:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortBySku().findAll();
              } else {
                products = await query.sortBySkuDesc().findAll();
              }
            }
            break;
          }
        //By Unit Price
        case 4:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByNewFinalPrice().findAll();
              } else {
                products = await query.sortByNewFinalPriceDesc().findAll();
              }
            }
            break;
          }
        //By Package Price
        case 5:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByNewFinalPricePackage().findAll();
              } else {
                products =
                    await query.sortByNewFinalPricePackageDesc().findAll();
              }
            }
            break;
          }
        //By Units Quantity
        case 6:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByQtyPackage().findAll();
              } else {
                products = await query.sortByQtyPackageDesc().findAll();
              }
            }
            break;
          }
        //By Packages Quantity
        case 7:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByTotalPackages().findAll();
              } else {
                products = await query.sortByTotalPackagesDesc().findAll();
              }
            }
            break;
          }
        //By Paid Packages Quantity
        case 8:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByPaidTotalPackages().findAll();
              } else {
                products = await query.sortByPaidTotalPackagesDesc().findAll();
              }
            }
            break;
          }
        //By Total Packages Price
        case 9:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByTotalPrice().findAll();
              } else {
                products = await query.sortByTotalPriceDesc().findAll();
              }
            }
            break;
          }
        //By Paid Units Quantity
        case 10:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByPaidTotalUnits().findAll();
              } else {
                products = await query.sortByPaidTotalUnitsDesc().findAll();
              }
            }
            break;
          }
        //By Paid Total Packages Price
        case 11:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByPaidTotalPrice().findAll();
              } else {
                products = await query.sortByPaidTotalPriceDesc().findAll();
              }
            }
            break;
          }
        //By Date
        case 12:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByDate().findAll();
              } else {
                products = await query.sortByDateDesc().findAll();
              }
            }
            break;
          }
        //By Status
        case 13:
          {
            if (desc != null) {
              if (!desc) {
                products = await query.sortByStatus().findAll();
              } else {
                products = await query.sortByStatusDesc().findAll();
              }
            }
            break;
          }
        default:
          {
            products = await query.findAll();
            break;
          }
      }
    }
    if (filterIndexSort != null) {
      if (filterIndexSort == 0) {
        if (desc != null) {
          if (desc) {
            products = await query.findAll();
            products.sort((a, b) => Comparable.compare(b.id!, a.id!));
          }
        }
      }
    }

    return products;
  }

  /// edit the product on the storage
  @override
  Future<void> editProductStorage(
      int? id,
      String name,
      String code,
      String sku,
      double weight,
      double originalPrice,
      double costsPrice,
      double profit,
      double oldFinalPrice,
      double newFinalPrice,
      int qtyPackage,
      double oldFinalPricePackage,
      double newFinalPricePackage,
      int totalPackages,
      int paidTotalPackages,
      int paidTotalUnits,
      double totalPrice,
      double paidTotalPrice,
      String imagePath,
      String description,
      DateTime date,
      Status status,
      Store store,
      Brand brand) async {
    await _store.writeTxn(() async {
      final editProduct = await _store.products.get(id!);

      editProduct!.name = name;
      editProduct.code = code;
      editProduct.sku = sku;
      editProduct.weight = weight;
      editProduct.originalPrice = originalPrice;
      editProduct.costsPrice = costsPrice;
      editProduct.profit = profit;
      editProduct.oldFinalPrice = oldFinalPrice;
      editProduct.newFinalPrice = newFinalPrice;
      editProduct.qtyPackage = qtyPackage;
      editProduct.oldFinalPricePackage = oldFinalPricePackage;
      editProduct.newFinalPricePackage = newFinalPricePackage;
      editProduct.totalPackages = totalPackages;
      editProduct.paidTotalPackages = paidTotalPackages;
      editProduct.paidTotalUnits = paidTotalUnits;
      editProduct.totalPrice = totalPrice;
      editProduct.paidTotalPrice = paidTotalPrice;
      editProduct.imagePath = imagePath;
      editProduct.description = description;
      editProduct.date = date;
      editProduct.status = status;
      editProduct.store.value = store;
      editProduct.brand.value = brand;

      await _store.products.put(editProduct);
      await editProduct.brand.save();
      await editProduct.store.save();
    });
  }
}

//! Define all repo's methods of Product
abstract class ProductBoxOperations {
  Future<List<Product>> getAllProductsStorage(
      {String? filterName,
      String? filterCode,
      String? filterSKU,
      String? filterDescription,
      double? filterGreaterUnitPrice,
      double? filterLessUnitPrice,
      double? filterGreaterPackagePrice,
      double? filterLessPackagePrice,
      int? filterUnitsQuantity,
      int? filterPackagesQuantity,
      int? filterPaidPackagesQuantity,
      DateTime? filterStartDate,
      DateTime? filterEndDate,
      Brand? filterBrand,
      Store? filterStore,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteProductStorage(int? id);
  Future<void> addProductStorage(Product product);
  Future<void> editProductStorage(
      int? id,
      String name,
      String code,
      String sku,
      double weight,
      double originalPrice,
      double costsPrice,
      double profit,
      double oldFinalPrice,
      double newFinalPrice,
      int qtyPackage,
      double oldFinalPricePackage,
      double newFinalPricePackage,
      int totalPackages,
      int paidTotalPackages,
      int paidTotalUnits,
      double totalPrice,
      double paidTotalPrice,
      String imagePath,
      String description,
      DateTime date,
      Status status,
      Store store,
      Brand brand);
}

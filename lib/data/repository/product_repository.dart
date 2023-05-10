import 'package:business_light/domain/entity/store.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/brand.dart';
import '../../domain/entity/product.dart';
import '../../domain/entity/status.dart';
import '../datasource/remote/business_api.dart';
import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('ProductRepository')
@Injectable()
class ProductRepository extends ProductRepositoryOperations {
  ProductRepository(@Named('BusinessApi') this.api,
      @Named('StorageService') this.storageService);

  final BusinessApi api;
  final StorageService storageService;

  //! Remote Functions
  /// Get products data from server
  @override
  getAllProductsRemote() {}

  /// delete the product on the server
  @override
  deleteProductRemote() {}

  /// add new product on the server
  @override
  addProductRemote() {}

  /// edit the product on the server
  @override
  editProductRemote() {}

  /// Get brands data from server
  @override
  getAllBrandsRemote() {}

  /// Get stores data from server
  @override
  getAllStoresRemote() {}

  //! Storage Functions
  /// add new product on the storage
  @override
  Future<void> addProductStorage(Product product) =>
      storageService.productBox.addProductStorage(product);

  /// delete the product on the storage
  @override
  Future<void> deleteProductStorage(int? id) =>
      storageService.productBox.deleteProductStorage(id);

  /// Get products data from storage
  @override
  getAllProductsStorage(
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
          bool? desc}) =>
      storageService.productBox.getAllProductsStorage(
          filterName: filterName,
          filterCode: filterCode,
          filterSKU: filterSKU,
          filterDescription: filterDescription,
          filterGreaterUnitPrice: filterGreaterUnitPrice,
          filterLessUnitPrice: filterLessUnitPrice,
          filterGreaterPackagePrice: filterGreaterPackagePrice,
          filterLessPackagePrice: filterLessPackagePrice,
          filterUnitsQuantity: filterUnitsQuantity,
          filterPackagesQuantity: filterPackagesQuantity,
          filterPaidPackagesQuantity: filterPaidPackagesQuantity,
          filterStartDate: filterStartDate,
          filterEndDate: filterEndDate,
          filterBrand: filterBrand,
          filterStore: filterStore,
          filterStatus: filterStatus,
          filterIndexSort: filterIndexSort,
          desc: desc);

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
          Brand brand) =>
      storageService.productBox.editProductStorage(
          id,
          name,
          code,
          sku,
          weight,
          originalPrice,
          costsPrice,
          profit,
          oldFinalPrice,
          newFinalPrice,
          qtyPackage,
          oldFinalPricePackage,
          newFinalPricePackage,
          totalPackages,
          paidTotalPackages,
          paidTotalUnits,
          totalPrice,
          paidTotalPrice,
          imagePath,
          description,
          date,
          status,
          store,
          brand);

  /// Get brands data from storage
  @override
  Future<List<Brand>> getAllBrandsStorage() async =>
      storageService.brandBox.getAllBrands(filterIndexSort: 0, desc: false);

  /// Get stores data from storage
  @override
  Future<List<Store>> getAllStoresStorage() async =>
      storageService.storeBox.getAllStores(filterIndexSort: 0, desc: false);
}

//! Define all repo's methods of Store
abstract class ProductRepositoryOperations {
  getAllProductsStorage(
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

  Future<List<Brand>> getAllBrandsStorage();
  Future<List<Store>> getAllStoresStorage();

  getAllProductsRemote();
  deleteProductRemote();
  addProductRemote();
  editProductRemote();
  getAllBrandsRemote();
  getAllStoresRemote();
}

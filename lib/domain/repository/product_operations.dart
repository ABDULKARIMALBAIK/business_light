import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/entity/store.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/product.dart';
import '../entity/status.dart';

///Declare all operations to Product screen (Data and operations)
abstract class ProductOperations {
  void getAllProductsStorage(
      {required BlocListCubit<Product> stater,
      required BlocDataTableCubit<Product> cubit,
      required bool isRefresh,
      String? filterName,
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
  Future<void> addProductStorage(
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

  saveCode({required String codeText, required String nameFile});
  printCode(Product product);

  getAllProductsRemote();
  deleteProductRemote();
  addProductRemote();
  editProductRemote();
  getAllBrandsRemote();
  getAllStoresRemote();

  Future<int?> navigateAddProduct(int pageIndex);
  Future<int?> navigateEditProduct(int pageIndex, Product product);

  checkPermissionExportExcel(BuildContext context, List<Product> products);
  exportDataExcel(BuildContext context, List<Product> products);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

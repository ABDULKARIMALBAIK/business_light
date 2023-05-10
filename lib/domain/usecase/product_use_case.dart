import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:barcode/barcode.dart';
import 'package:business_light/domain/entity/store.dart';
import 'package:business_light/domain/entity/status.dart';
import 'package:business_light/domain/entity/product.dart';
import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/repository/product_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../mapper/product_mapper.dart';
import '../repository/product_operations.dart';

// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Usecase to make all operations in view model of product
@Named('ProductUseCase')
@Injectable()
class ProductUseCase implements ProductOperations {
  ProductUseCase(@Named('ProductRepository') this.repository,
      @Named('ProductMapper') this.mapper);

  final ProductRepository repository;
  final ProductMapper mapper;

  //! Remote Functions
  /// Get products data from server
  @override
  getAllProductsRemote() {}

  /// add new product on the server
  @override
  addProductRemote() {}

  /// delete the product on the server
  @override
  deleteProductRemote() {}

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
  /// delete the product on the storage
  @override
  Future<void> deleteProductStorage(int? id) =>
      repository.deleteProductStorage(id);

  /// Get products data from storage
  @override
  getAllProductsStorage(
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
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Product> products = await repository.getAllProductsStorage(
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

      if (products.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = products;
        // !isRefresh ? cubit.setData = products : cubit.data.addAll(products);
        if (!isRefresh) {
          stater.updateState(newType: BlocListType.loading); //Shimmer :)
          await Future.delayed(const Duration(milliseconds: 500));
        }
        if (stater.getType() == BlocListType.loading) {
          stater.updateState(newType: BlocListType.loaded);
        } else if (stater.getType() == BlocListType.loaded) {
          stater.updateState(newType: BlocListType.loadedAgain);
        } else if (stater.getType() == BlocListType.loadedAgain) {
          stater.updateState(newType: BlocListType.loaded);
        }
      }
    } on CustomException catch (e) {
      developer.log("error fetch data: \n$e");
      if (cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.error);
      } else {
        // No Thing here !
        // cubit.updateState(newType: BlocListType.loaded);
      }
      // CustomInfoBar.showError(error: e.error, severity: InfoBarSeverity.error);
    }
  }

  /// add new product on the storage
  @override
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
      Brand brand) async {
    Product newProduct = Product()
      ..name = name
      ..code = code
      ..sku = sku
      ..weight = weight
      ..originalPrice = originalPrice
      ..costsPrice = costsPrice
      ..profit = profit
      ..oldFinalPrice = oldFinalPrice
      ..newFinalPrice = newFinalPrice
      ..qtyPackage = qtyPackage
      ..oldFinalPricePackage = oldFinalPricePackage
      ..newFinalPricePackage = newFinalPricePackage
      ..totalPackages = totalPackages
      ..paidTotalPackages = paidTotalPackages
      ..paidTotalUnits = paidTotalUnits
      ..totalPrice = totalPrice
      ..paidTotalPrice = paidTotalPrice
      ..imagePath = imagePath
      ..description = description
      ..store.value = store
      ..brand.value = brand
      ..date = date
      ..status = status;

    repository.addProductStorage(newProduct);
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
          Brand brand) =>
      repository.editProductStorage(
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
      repository.getAllBrandsStorage();

  /// Get stores data from storage
  @override
  Future<List<Store>> getAllStoresStorage() async =>
      repository.getAllStoresStorage();

  //! Navigation Functions
  /// Navigate to add new product screen
  @override
  Future<int?> navigateAddProduct(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditProductName,
        params: {"newEditProduct": 0.toString()},
        extra: null,
        queryParams: {"isEdit": "false", "pageNum": pageIndex.toString()});

    return pageNum;
  }

  /// Navigate to edit the product screen
  @override
  Future<int?> navigateEditProduct(int pageIndex, Product product) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditProductName,
        params: {"newEditProduct": product.id.toString()},
        extra: product,
        queryParams: {"isEdit": "true", "pageNum": pageIndex.toString()});
    return pageNum;
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(
      BuildContext context, List<Product> products) async {
    try {
      if ((await Permission.storage.isDenied) ||
          (await Permission.manageExternalStorage.isDenied)) {
        final List<Permission> permissions = [
          Permission.storage,
          Permission.manageExternalStorage
        ];

        int sdkInt = 0;
        if (Platform.isAndroid) {
          final androidInfo = await DeviceInfoPlugin().androidInfo;
          sdkInt = androidInfo.version.sdkInt;
          if (sdkInt < 30) {
            permissions.removeAt(1);
          }
        }
        await permissions.request().then((permissionStatus) {
          if (permissionStatus[Permission.storage] ==
              PermissionStatus.granted) {
            if (sdkInt >= 30) {
              if (permissionStatus[Permission.manageExternalStorage] ==
                  PermissionStatus.granted) {
                exportDataExcel(context, products);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, products);
            }
          } else {
            CustomInfoBar.showDefault(
                context: context,
                title: 'message_excel_cannot_export'.tr(),
                severity: InfoBarSeverity.error);
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        exportDataExcel(context, products);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Product> products) {
    try {
      if (products.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'product_header'.tr()}${Random().nextInt(10000)}";
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //! Names for Columns
        final cellId = sheetObject.cell(CellIndex.indexByString("A1"));
        cellId.value = 'id'.tr();
        final cellName = sheetObject.cell(CellIndex.indexByString("B1"));
        cellName.value = 'name'.tr();
        final cellCode = sheetObject.cell(CellIndex.indexByString("C1"));
        cellCode.value = 'code'.tr();
        final cellSku = sheetObject.cell(CellIndex.indexByString("D1"));
        cellSku.value = 'sku'.tr();
        final cellWeight = sheetObject.cell(CellIndex.indexByString("E1"));
        cellWeight.value = 'weight'.tr();
        final cellOriginalPrice =
            sheetObject.cell(CellIndex.indexByString("F1"));
        cellOriginalPrice.value = 'original_price'.tr();
        final cellCostsPrice = sheetObject.cell(CellIndex.indexByString("G1"));
        cellCostsPrice.value = 'costs_price'.tr();
        final cellProfit = sheetObject.cell(CellIndex.indexByString("H1"));
        cellProfit.value = 'profit'.tr();
        final cellOldFinalPrice =
            sheetObject.cell(CellIndex.indexByString("I1"));
        cellOldFinalPrice.value = 'old_final_price'.tr();
        final cellNewFinalPrice =
            sheetObject.cell(CellIndex.indexByString("J1"));
        cellNewFinalPrice.value = 'new_final_price'.tr();
        final cellQTYPackage = sheetObject.cell(CellIndex.indexByString("K1"));
        cellQTYPackage.value = 'qty_units'.tr();
        final cellOldFinalPricePackage =
            sheetObject.cell(CellIndex.indexByString("L1"));
        cellOldFinalPricePackage.value = 'old_final_price_package'.tr();
        final cellNewFinalPricePackage =
            sheetObject.cell(CellIndex.indexByString("M1"));
        cellNewFinalPricePackage.value = 'new_final_price_package'.tr();
        final cellTotalPackages =
            sheetObject.cell(CellIndex.indexByString("N1"));
        cellTotalPackages.value = 'qty_packages'.tr();
        final cellPaidTotalPackages =
            sheetObject.cell(CellIndex.indexByString("O1"));
        cellPaidTotalPackages.value = 'paid_qty_packages'.tr();
        final cellPaidTotalUnits =
            sheetObject.cell(CellIndex.indexByString("P1"));
        cellPaidTotalUnits.value = 'paid_units_qty'.tr();
        final cellTotalPrice = sheetObject.cell(CellIndex.indexByString("Q1"));
        cellTotalPrice.value = 'total_packages_price'.tr();
        final cellPaidTotalPrice =
            sheetObject.cell(CellIndex.indexByString("R1"));
        cellPaidTotalPrice.value = 'total_price'.tr();
        final cellImagePath = sheetObject.cell(CellIndex.indexByString("S1"));
        cellImagePath.value = 'image_path'.tr();
        final cellDescription = sheetObject.cell(CellIndex.indexByString("T1"));
        cellDescription.value = 'description'.tr();
        final cellDate = sheetObject.cell(CellIndex.indexByString("U1"));
        cellDate.value = 'date'.tr();
        final cellStatus = sheetObject.cell(CellIndex.indexByString("V1"));
        cellStatus.value = 'status'.tr();
        final cellStore = sheetObject.cell(CellIndex.indexByString("W1"));
        cellStore.value = 'store'.tr();
        final cellBrand = sheetObject.cell(CellIndex.indexByString("X1"));
        cellBrand.value = 'brand'.tr();

        //! Insert Data in rows
        for (int i = 0; i < products.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = products[i].id;
          final cellName =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellName.value = products[i].name;
          final cellCode =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellCode.value = products[i].code;
          final cellSku =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellSku.value = products[i].sku;
          final cellWeight =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellWeight.value = products[i].weight;
          final cellOriginalPrice =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellOriginalPrice.value = products[i].originalPrice;
          final cellCostsPrice =
              sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
          cellCostsPrice.value = products[i].costsPrice;
          final cellProfit =
              sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
          cellProfit.value = products[i].profit;
          final cellOldFinalPrice =
              sheetObject.cell(CellIndex.indexByString("I${i + 2}"));
          cellOldFinalPrice.value = products[i].oldFinalPrice;
          final cellNewFinalPrice =
              sheetObject.cell(CellIndex.indexByString("J${i + 2}"));
          cellNewFinalPrice.value = products[i].newFinalPrice;
          final cellQTYPackage =
              sheetObject.cell(CellIndex.indexByString("K${i + 2}"));
          cellQTYPackage.value = products[i].qtyPackage;
          final cellOldFinalPricePackage =
              sheetObject.cell(CellIndex.indexByString("L${i + 2}"));
          cellOldFinalPricePackage.value = products[i].oldFinalPricePackage;
          final cellNewFinalPricePackage =
              sheetObject.cell(CellIndex.indexByString("M${i + 2}"));
          cellNewFinalPricePackage.value = products[i].newFinalPricePackage;
          final cellTotalPackages =
              sheetObject.cell(CellIndex.indexByString("N${i + 2}"));
          cellTotalPackages.value = products[i].totalPackages;
          final cellPaidTotalPackages =
              sheetObject.cell(CellIndex.indexByString("O${i + 2}"));
          cellPaidTotalPackages.value = products[i].paidTotalPackages;
          final cellPaidTotalUnits =
              sheetObject.cell(CellIndex.indexByString("P${i + 2}"));
          cellPaidTotalUnits.value = products[i].paidTotalUnits;
          final cellTotalPrice =
              sheetObject.cell(CellIndex.indexByString("Q${i + 2}"));
          cellTotalPrice.value = products[i].totalPrice;
          final cellPaidTotalPrice =
              sheetObject.cell(CellIndex.indexByString("R${i + 2}"));
          cellPaidTotalPrice.value = products[i].paidTotalPrice;
          final cellImagePath =
              sheetObject.cell(CellIndex.indexByString("S${i + 2}"));
          cellImagePath.value = products[i].imagePath;
          final cellDescription =
              sheetObject.cell(CellIndex.indexByString("T${i + 2}"));
          cellDescription.value = products[i].description;
          final cellDate =
              sheetObject.cell(CellIndex.indexByString("U${i + 2}"));
          cellDate.value = DateFormat('yyyy-MM-dd hh:mm')
              .format(products[i].date!)
              .toString();
          final cellStatus =
              sheetObject.cell(CellIndex.indexByString("V${i + 2}"));
          cellStatus.value = products[i].status.name.tr();
          final cellStore =
              sheetObject.cell(CellIndex.indexByString("W${i + 2}"));
          cellStore.value = products[i].store.value != null
              ? products[i].store.value!.name
              : '';
          final cellBrand =
              sheetObject.cell(CellIndex.indexByString("X${i + 2}"));
          cellBrand.value = products[i].brand.value != null
              ? products[i].brand.value!.name
              : '';
        }

        //! Save file
        saveExcelFile(context, sheetName, excel);
      }
    } on CustomException catch (e) {
      developer.log("Excel Error: $e");
    }
  }

  /// export excel file to download folder
  @override
  saveExcelFile(BuildContext context, String sheetName, Excel excel) async {
    try {
      final directory = await getDownloadsDirectory();
      final path = directory!.path;
      final file = await File(join(
        path,
        'business_light',
        'excels',
        '$sheetName${Random().nextInt(10000)}.xlsx',
      )).create(recursive: false);

      await file.writeAsBytes(excel.encode()!);

      // if (!(await dir.exists())) {
      //   await dir.create(recursive: true);
      // }

      // File("${dir.path}/$sheetName.xlsx")
      //   ..createSync(recursive: false)
      //   ..writeAsBytesSync(excel.encode()!);

      // ignore: use_build_context_synchronously
      CustomInfoBar.showDefault(
          context: context,
          title: 'message_excel_saved'.tr(),
          severity: InfoBarSeverity.success);
    } catch (e) {
      developer.log('Excel Error: $e');
    }
  }

  //! Operations
  /// Save code as svg file in download folder
  @override
  saveCode({required String codeText, required String nameFile}) async {
    final barcode = Barcode.qrCode();
    final svg = barcode.toSvg(codeText);

    final directory = await getDownloadsDirectory();
    final path = directory!.path;
    final file = await File(join(
      path,
      'business_light',
      'codes',
      'product_$nameFile${Random().nextInt(10000)}.svg',
    )).create(recursive: true);

    file.writeAsBytes(svg.codeUnits);
  }

  /// print and save details of product in pdf format in download folder
  @override
  printCode(Product product) async {
    final barcode = Barcode.qrCode();
    final svg = barcode.toSvg(product.code ?? '');

    final doc = pw.Document(
        compress: true,
        creator: 'Business Light Program',
        title: 'Business Light Program');
    doc.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(12),
        pageFormat: PdfPageFormat.roll57,
        build: (pw.Context context) {
          return pw.SizedBox(
              width: double.infinity,
              child: pw.FittedBox(
                  child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    ////////////// * Title * //////////////
                    pw.Text('--- Business Light Program ---',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 30)),
                    pw.SizedBox(height: 40),

                    pw.SvgImage(svg: svg, width: 380, height: 380),
                    pw.SizedBox(height: 40),

                    ////////////// * Name * //////////////
                    pw.Text('product_add_infoBar_name'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(product.name ?? '',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Code * //////////////
                    pw.Text('product_add_infoBar_code'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(product.code ?? '',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * SKU * //////////////
                    pw.Text('product_add_infoBar_sku'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(product.sku ?? '',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Original Price * //////////////
                    pw.Text('product_add_infoBar_originalPrice'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text('${product.originalPrice!.toString()} \$',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Costs Price * //////////////
                    pw.Text('product_add_infoBar_costsPrice'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text('${product.costsPrice!.toString()} \$',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Profit Price * //////////////
                    pw.Text('product_add_infoBar_profit'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text('${product.profit!.toString()} \$',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Unit Price * //////////////
                    pw.Text('product_add_infoBar_newFinalPrice'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text('${product.newFinalPrice!.toString()} \$',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * QTY Units Price * //////////////
                    pw.Text('product_add_infoBar_qtyPackage'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(product.qtyPackage!.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Package Price * //////////////
                    pw.Text('product_add_infoBar_newFinalPricePackage'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text('${product.newFinalPricePackage!.toString()} \$',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * QTY Packages Price * //////////////
                    pw.Text('product_add_infoBar_totalPackages'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(product.totalPackages!.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Total Price * //////////////
                    pw.Text('product_add_infoBar_totalPrice'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text('${product.totalPrice!.toString()} \$',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Store * //////////////
                    pw.Text('store'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(
                        '${product.store.value != null ? product.store.value!.name : 'unKnown'}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Brand * //////////////
                    pw.Text('brand'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(
                        '${product.brand.value != null ? product.brand.value!.name : 'unKnown'}',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Date * //////////////
                    pw.Text('date'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(
                        DateFormat(('yyyy-MM-dd'))
                            .format(product.date!)
                            .toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),

                    // pw.Image(pw.RawImage(
                    //     width: 50,
                    //     height: 10,
                    //     bytes: Uint8List.fromList(svg.codeUnits)))
                  ])));
        }));

    Uint8List? pdfProduct;
    await Printing.layoutPdf(
        format: PdfPageFormat.a4,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => pdfProduct = await doc.save(),
        name: product.name ?? 'pdfFile');

    //Save on custom location
    final directory = await getDownloadsDirectory();
    final path = directory!.path;
    final file = await File(join(
      path,
      'business_light',
      'products',
      '${product.name ?? ''}${Random().nextInt(10000)}.pdf',
    )).create(recursive: false);

    await file.writeAsBytes(Uint8List.fromList(pdfProduct ?? []));
  }

  /// Pick image from file explorer
  Future<String> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        dialogTitle: 'Pick an image to your product',
        type: FileType.image);
    if (result != null) {
      return result.files.single.path ?? '';
    }
    return '';
  }
}

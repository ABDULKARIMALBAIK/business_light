import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:excel/excel.dart';
import 'package:business_light/domain/entity/user.dart';
import 'package:business_light/domain/entity/order.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:injectable/injectable.dart' show Named, Injectable;
import 'package:barcode/barcode.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

import '../../data/repository/order_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../entity/payment.dart';
import '../entity/product.dart';
import '../entity/product_order.dart';
import '../mapper/order_mapper.dart';
import '../repository/order_operations.dart';

// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;

/// Usecase to make all operations in view model of order
@Named('OrderUseCase')
@Injectable()
class OrderUseCase implements OrderOperations {
  OrderUseCase(@Named('OrderRepository') this.repository,
      @Named('OrderMapper') this.mapper);

  final OrderRepository repository;
  final OrderMapper mapper;

  //! Remote Functions
  /// add new order on the server
  @override
  addOrderRemote() {}

  /// delete the order on the server
  @override
  deleteOrderRemote() {}

  /// Get orders data from server
  @override
  getAllOrdersRemote() {}

  /// Get customers data from server
  @override
  getAllCustomersRemote() {}

  /// Get products data from server
  @override
  getAllProductsRemote() {}

  //! Storage Functions
  /// add new order on the storage
  @override
  Future<void> addOrderStorage(
      {String? code,
      int? totalQty,
      int? qtyPieces,
      double? totalPrice,
      double? chargeCost,
      double? otherCost,
      double? balancer,
      double? discount,
      DateTime? date,
      double? finalPrice,
      String? description,
      User? selectedCustomer,
      required List<Payment> payments,
      required List<ProductOrder> productsOrder,
      TypeOrder? orderType}) async {
    Order newOrder = Order()
      ..code = code
      ..description = description
      ..totalQty = totalQty
      ..qtyPieces = qtyPieces
      ..totalPrice = totalPrice
      ..chargeCost = chargeCost
      ..otherCost = otherCost
      ..balancer = balancer
      ..discount = discount
      ..date = date
      ..finalPrice = finalPrice
      ..user.value = selectedCustomer
      // ..payments.addAll(payments!)
      // ..products.addAll(productsOrder!)
      ..type = orderType ?? TypeOrder.negotiation;

    repository.addOrderStorage(newOrder, productsOrder, payments);
  }

  /// delete the order on the storage
  @override
  Future<void> deleteOrderStorage(int? id) => repository.deleteOrderStorage(id);

  /// Get customers data from storage
  @override
  getAllCustomersStorage() => repository.getAllCustomersStorage();

  /// Get orders data from storage
  @override
  getAllOrdersStorage(
      {required BlocListCubit<Order> stater,
      required BlocDataTableCubit<Order> cubit,
      required bool isRefresh,
      String? codeFilterController,
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
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Order> orders = await repository.getAllOrdersStorage(
          codeFilterController: codeFilterController,
          greaterTotalPriceFilterController: greaterTotalPriceFilterController,
          lessTotalPriceFilterController: lessTotalPriceFilterController,
          greaterPricePiecesFilterController:
              greaterPricePiecesFilterController,
          lessPricePiecesFilterController: lessPricePiecesFilterController,
          greaterFinalPriceFilterController: greaterFinalPriceFilterController,
          lessFinalPriceFilterController: lessFinalPriceFilterController,
          descriptionFilterController: descriptionFilterController,
          selectedStartDate: selectedStartDate,
          selectedEndDate: selectedEndDate,
          typeFilter: typeFilter,
          filterCustomer: filterCustomer,
          filterIndexSort: filterIndexSort,
          desc: desc);

      if (orders.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = orders;
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

  /// Get products data from storage
  @override
  Future<List<Product>> getAllProductsStorage() =>
      repository.getAllProductsStorage();

  //! Navigation Functions
  /// Navigate to add new order screen
  @override
  Future<int?> navigateAddOrder(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditOrderName,
        params: {"newEditOrder": 0.toString()},
        extra: null,
        queryParams: {"isEdit": "false", "pageNum": pageIndex.toString()});

    return pageNum;
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(BuildContext context, List<Order> orders) async {
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
                exportDataExcel(context, orders);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, orders);
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
        exportDataExcel(context, orders);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Order> orders) async {
    try {
      if (orders.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'order_header'.tr()}${Random().nextInt(10000)}";
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //! Names for Columns
        final cellId = sheetObject.cell(CellIndex.indexByString("A1"));
        cellId.value = 'id'.tr();
        final cellCode = sheetObject.cell(CellIndex.indexByString("B1"));
        cellCode.value = 'code'.tr();
        final cellTotalQty = sheetObject.cell(CellIndex.indexByString("C1"));
        cellTotalQty.value = 'order_sorter_totalQty'.tr();
        final cellQtyPieces = sheetObject.cell(CellIndex.indexByString("D1"));
        cellQtyPieces.value = 'order_sorter_qtyPieces'.tr();
        final cellTotalPrice = sheetObject.cell(CellIndex.indexByString("E1"));
        cellTotalPrice.value = 'order_sorter_totalPrice'.tr();
        final cellChargeCost = sheetObject.cell(CellIndex.indexByString("F1"));
        cellChargeCost.value = 'order_chargeCost'.tr();
        final cellOtherCost = sheetObject.cell(CellIndex.indexByString("G1"));
        cellOtherCost.value = 'order_otherCost'.tr();
        final cellBalancer = sheetObject.cell(CellIndex.indexByString("H1"));
        cellBalancer.value = 'order_balancer'.tr();
        final cellDiscount = sheetObject.cell(CellIndex.indexByString("I1"));
        cellDiscount.value = 'order_discount'.tr();
        final cellFinalPrice = sheetObject.cell(CellIndex.indexByString("J1"));
        cellFinalPrice.value = 'order_sorter_finalPrice'.tr();
        final cellDescription = sheetObject.cell(CellIndex.indexByString("K1"));
        cellDescription.value = 'description'.tr();
        final cellCustomer = sheetObject.cell(CellIndex.indexByString("L1"));
        cellCustomer.value = 'customer'.tr();
        final cellPayments = sheetObject.cell(CellIndex.indexByString("M1"));
        cellPayments.value = 'payment_header'.tr();
        final cellProducts = sheetObject.cell(CellIndex.indexByString("N1"));
        cellProducts.value = 'product_header'.tr();
        final cellType = sheetObject.cell(CellIndex.indexByString("O1"));
        cellType.value = 'order_type'.tr();

        //! Insert Data in rows
        for (int i = 0; i < orders.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = orders[i].id;
          final cellCode =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellCode.value = orders[i].code;
          final cellTotalQty =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellTotalQty.value = orders[i].totalQty;
          final cellQtyPieces =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellQtyPieces.value = orders[i].qtyPieces;
          final cellTotalPrice =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellTotalPrice.value = orders[i].totalPrice;
          final cellChargeCost =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellChargeCost.value = orders[i].chargeCost;
          final cellOtherCost =
              sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
          cellOtherCost.value = orders[i].otherCost;
          final cellBalancer =
              sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
          cellBalancer.value = orders[i].balancer;
          final cellDiscount =
              sheetObject.cell(CellIndex.indexByString("I${i + 2}"));
          cellDiscount.value = orders[i].discount;
          final cellFinalPrice =
              sheetObject.cell(CellIndex.indexByString("J${i + 2}"));
          cellFinalPrice.value = orders[i].finalPrice;
          final cellDescription =
              sheetObject.cell(CellIndex.indexByString("K${i + 2}"));
          cellDescription.value = orders[i].description;
          final cellCustomer =
              sheetObject.cell(CellIndex.indexByString("L${i + 2}"));
          cellCustomer.value = orders[i].user.value == null
              ? ''
              : orders[i].user.value!.fullName ?? '';
          final cellPayments =
              sheetObject.cell(CellIndex.indexByString("M${i + 2}"));
          cellPayments.value = orders[i]
              .payments
              .map((payment) =>
                  "${payment.code ?? '0'}: ${payment.price ?? 0.0} \$")
              .toList()
              .toSet()
              .toString();
          final cellProducts =
              sheetObject.cell(CellIndex.indexByString("N${i + 2}"));
          cellProducts.value = orders[i]
              .products
              .map((product) =>
                  "${product.code ?? '0'}: ${product.piecePrice! * product.piecesQty!} \$")
              .toSet()
              .toString();
          final cellType =
              sheetObject.cell(CellIndex.indexByString("O${i + 2}"));
          cellType.value = orders[i].type.name.tr();
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
        '$sheetName.xlsx',
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
      '$nameFile${Random().nextInt(10000)}.svg',
    )).create(recursive: true);

    file.writeAsBytes(svg.codeUnits);
  }

  /// print order as pdf file
  @override
  printCode(Order order) async {
    // final barcode = Barcode.code39();
    // final svg = barcode.toSvg(codeText);
    List<double> payments =
        order.payments.map<double>((pay) => pay.price ?? 0.0).toList();
    double totalPayments = 0.0;
    for (var payment in payments) {
      totalPayments += payment;
    }

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
                      mainAxisSize: pw.MainAxisSize.max,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    ////////////// * Title * //////////////
                    pw.Text('--- Business Light Program ---',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 30)),
                    pw.SizedBox(height: 30),
                    ////////////// * Code * //////////////
                    pw.Text('order_code'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.code ?? '',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Customer * //////////////
                    pw.Text('customer'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(
                        order.user.value == null
                            ? ''
                            : order.user.value!.fullName ?? '',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Date * //////////////
                    pw.Text('date'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(
                        DateFormat('yyyy-MM-dd hh:mm')
                            .format(order.date ?? DateTime.now()),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Total QTY * //////////////
                    pw.Text('order_sorter_totalQty'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.totalQty.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * QTY Pieces * //////////////
                    pw.Text('order_sorter_qtyPieces'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.qtyPieces.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    // ////////////// * Price Pieces * //////////////
                    // pw.Text('order_sorter_pricePieces'.tr(),
                    //     style: const pw.TextStyle(fontSize: 22)),
                    // pw.SizedBox(height: 3),
                    // pw.Text(order.pricePieces.toString(),
                    //     style: pw.TextStyle(
                    //         fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    // pw.SizedBox(height: 22),
                    ////////////// * Total Price * //////////////
                    pw.Text('order_sorter_totalPrice'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.totalPrice.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Charge Cost * //////////////
                    pw.Text('order_chargeCost'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.chargeCost.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Other Costs * //////////////
                    pw.Text('order_otherCost'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.otherCost.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Balancer * //////////////
                    pw.Text('order_balancer'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.balancer.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Discount * //////////////
                    pw.Text('order_discount'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.discount.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Final Price * //////////////
                    pw.Text('order_sorter_finalPrice'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.finalPrice.toString(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Order Type * //////////////
                    pw.Text('order_type'.tr(),
                        style: const pw.TextStyle(fontSize: 22)),
                    pw.SizedBox(height: 3),
                    pw.Text(order.type.name.tr(),
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 25)),
                    pw.SizedBox(height: 22),
                    ////////////// * Products Details * //////////////
                    if (order.products.isNotEmpty) ...[
                      pw.Text('product_header'.tr(),
                          style: pw.TextStyle(
                              fontSize: 25, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 12),
                      for (var product in order.products) ...[
                        pw.Text(
                            "${'product_add_infoBar_name'.tr()}: ${product.name}",
                            style: pw.TextStyle(
                                fontSize: 22, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'product_add_infoBar_code'.tr()}: ${product.code}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'qty_packages'.tr()}: ${product.packagesQty}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'package_price'.tr()}: ${product.packagePrice}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text("${'qty_package'.tr()}: ${product.piecesQty}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text("${'unit_price'.tr()}: ${product.piecePrice}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'order_sorter_totalPrice'.tr()}: ${product.piecePrice! * product.piecesQty!}",
                            style: const pw.TextStyle(fontSize: 23.5)),
                        pw.SizedBox(height: 25),
                      ],
                      pw.SizedBox(height: 22),
                    ],
                    ////////////// * Payments Details * //////////////
                    if (order.payments.isNotEmpty) ...[
                      pw.Text("${'payment_header'.tr()} ($totalPayments)",
                          style: pw.TextStyle(
                              fontSize: 25, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 12),
                      for (var payment in order.payments) ...[
                        pw.Text(
                            "${'payment_add_infoBar_code'.tr()}: ${payment.code}",
                            style: pw.TextStyle(
                                fontSize: 22, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'payment_add_infoBar_price'.tr()}: ${payment.price}",
                            style: const pw.TextStyle(fontSize: 23.5)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'date'.tr()}: ${DateFormat('yyyy-MM-dd hh:mm').format(order.date ?? DateTime.now())}",
                            style: pw.TextStyle(
                                fontSize: 22, fontStyle: pw.FontStyle.italic)),
                        pw.SizedBox(height: 15),
                      ],
                      pw.SizedBox(height: 22),
                    ]
                  ])));
        }));

    Uint8List? pdfProduct;
    await Printing.layoutPdf(
        format: PdfPageFormat.a4,
        usePrinterSettings: true,
        onLayout: (PdfPageFormat format) async => pdfProduct = await doc.save(),
        name: order.code ?? 'pdfFile');

    //Save on custom location
    final directory = await getDownloadsDirectory();
    final path = directory!.path;
    final file = await File(join(
      path,
      'business_light',
      'orders',
      'order${order.code ?? ''}_${Random().nextInt(10000)}.pdf',
    )).create(recursive: false);

    await file.writeAsBytes(Uint8List.fromList(pdfProduct ?? []));
  }
}

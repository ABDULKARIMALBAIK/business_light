import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:barcode/barcode.dart';
import 'package:business_light/domain/entity/user.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:injectable/injectable.dart' show Named, Injectable;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/repository/customer_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../entity/order.dart';
import '../entity/payment.dart';
import '../mapper/customer_mapper.dart';
import '../repository/customer_operations.dart';

// ignore: depend_on_referenced_packages
import 'package:pdf/pdf.dart';
// ignore: depend_on_referenced_packages
import 'package:pdf/widgets.dart' as pw;

/// Usecase to make all operations in view model of customer
@Named('CustomerUseCase')
@Injectable()
class CustomerUseCase implements CustomerOperations {
  CustomerUseCase(@Named('CustomerRepository') this.repository,
      @Named('CustomerMapper') this.mapper);

  final CustomerRepository repository;
  final CustomerMapper mapper;

  //! Remote Functions
  /// add new customer on the server
  @override
  addCustomerRemote() {}

  /// delete the customer on the server
  @override
  deleteCustomerRemote() {}

  /// edit the customer on the server
  @override
  editCustomerRemote() {}

  /// Get customers data from server
  @override
  getAllCustomersRemote() {}

  /// Get orders of customer data from server
  @override
  getAllCustomerOrdersRemote() {}

  /// Get payments of customer data from server
  @override
  getAllCustomerPaymentsRemote() {}

  //! Storage Functions
  /// add new customer on the storage
  @override
  Future<void> addCustomerStorage(
      {required String fullName,
      required String email,
      required String password,
      required String phone,
      required String jobDescription,
      required String imagePath}) async {
    User newCustomer = User()
      ..fullName = fullName
      ..email = email
      ..password = password
      ..phone = phone
      ..jobDescription = jobDescription
      ..imagePath = imagePath
      ..level = UserLevel.customer;
    repository.addCustomerStorage(newCustomer);
  }

  /// edit the customer on the storage
  @override
  Future<void> editCustomerStorage(
          {int? id,
          required String fullName,
          required String email,
          required String password,
          required String phone,
          required String jobDescription,
          required String imagePath}) async =>
      repository.editCustomerStorage(
          id: id,
          fullName: fullName,
          email: email,
          password: password,
          phone: phone,
          imagePath: imagePath,
          jobDescription: jobDescription);

  /// delete the customer on the storage
  @override
  Future<void> deleteCustomerStorage(int? id) =>
      repository.deleteCustomerStorage(id);

  /// Get customers data from storage
  @override
  getAllCustomersStorage(
      {required BlocListCubit<User> stater,
      required BlocDataTableCubit<User> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      int? filterIndexSort,
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<User> customers = await repository.getAllCustomersStorage(
          filterEmail: filterEmail,
          filterName: filterName,
          filterPhone: filterPhone,
          filterJobDescription: filterJobDescription,
          filterIndexSort: filterIndexSort,
          desc: desc);
      if (customers.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = customers;
        // !isRefresh ? cubit.setData = stores : cubit.data.addAll(stores);
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

  /// Get orders of customer from storage
  @override
  Future<void> getAllCustomerOrdersStorage({
    required User customer,
    required BlocListCubit<Order> stater,
    required BlocDataTableCubit<Order> cubit,
    required bool isRefresh,
  }) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Order> orders =
          await repository.getAllCustomerOrdersStorage(customer);
      if (orders.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = orders;
        // !isRefresh ? cubit.setData = stores : cubit.data.addAll(stores);
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

  /// Get payments of customer from storage
  @override
  Future<void> getAllCustomerPaymentsStorage({
    required User customer,
    required BlocListCubit<Payment> stater,
    required BlocDataTableCubit<Payment> cubit,
    required bool isRefresh,
  }) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Payment> payments =
          await repository.getAllCustomerPaymentsStorage(customer);
      if (payments.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = payments;
        // !isRefresh ? cubit.setData = stores : cubit.data.addAll(stores);
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

  //! Navigation Functions
  /// Navigate to add new customer screen
  @override
  Future<int?> navigateAddCustomer(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditCustomerName,
        params: {"newEditCustomer": 0.toString()},
        extra: null,
        queryParams: {"isEdit": "false", "pageNum": pageIndex.toString()});

    return pageNum;
  }

  /// Navigate to edit the customer screen
  @override
  Future<int?> navigateEditCustomer(int pageIndex, User customer) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditCustomerName,
        params: {"newEditCustomer": customer.id.toString()},
        extra: customer,
        queryParams: {"isEdit": "true", "pageNum": pageIndex.toString()});
    return pageNum;
  }

  /// Navigate to details of customer screen
  @override
  navigateCustomerDetails(User customer) async =>
      RouteGenerator.routerClient.pushNamed<int>(Routers.customerDetailsName,
          params: {"customerDetails": customer.id.toString()}, extra: customer);

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(BuildContext context, List<User> customers) async {
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
                exportDataExcel(context, customers);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, customers);
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
        exportDataExcel(context, customers);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<User> customers) {
    try {
      if (customers.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'customer_header'.tr()}${Random().nextInt(10000)}";
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //! Names for Columns
        final cellId = sheetObject.cell(CellIndex.indexByString("A1"));
        cellId.value = 'id'.tr();
        final cellName = sheetObject.cell(CellIndex.indexByString("B1"));
        cellName.value = 'name'.tr();
        final cellPassword = sheetObject.cell(CellIndex.indexByString("C1"));
        cellPassword.value = 'password'.tr();
        final cellEmail = sheetObject.cell(CellIndex.indexByString("D1"));
        cellEmail.value = 'email'.tr();
        final cellPhone = sheetObject.cell(CellIndex.indexByString("E1"));
        cellPhone.value = 'phone'.tr();
        final cellDescription = sheetObject.cell(CellIndex.indexByString("F1"));
        cellDescription.value = 'description'.tr();
        final cellImagePath = sheetObject.cell(CellIndex.indexByString("G1"));
        cellImagePath.value = 'image_path'.tr();
        final cellLevel = sheetObject.cell(CellIndex.indexByString("H1"));
        cellLevel.value = 'level'.tr();

        //! Insert Data in rows
        for (int i = 0; i < customers.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = customers[i].id;
          final cellName =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellName.value = customers[i].fullName;
          final cellPassword =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellPassword.value = customers[i].password;
          final cellEmail =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellEmail.value = customers[i].email;
          final cellPhone =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellPhone.value = customers[i].phone;
          final cellDescription =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellDescription.value = customers[i].jobDescription;
          final cellImagePath =
              sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
          cellImagePath.value = customers[i].imagePath;
          final cellLevel =
              sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
          cellLevel.value = customers[i].level.name.tr();
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
  /// Pick image from file explorer
  @override
  Future<String> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowCompression: true,
        dialogTitle: 'Pick an image to your customer',
        type: FileType.image);
    if (result != null) {
      return result.files.single.path ?? '';
    }
    return '';
  }

  /// Save code of product as pdf file
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
      '$nameFile.svg',
    )).create(recursive: true);

    file.writeAsBytes(svg.codeUnits);
  }

  /// Print data of product as pdf file
  @override
  printCode(Order order) async {
    // final barcode = Barcode.code39();
    // final svg = barcode.toSvg(codeText);

    final double totalPayments = order.payments
        .map<double>((pay) => pay.price ?? 0.0)
        .toList()
        .reduce((value, element) => value + element);

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
                    pw.Text(order.user.value!.fullName ?? '',
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
                    ////////////// * Products * //////////////
                    pw.Text(
                        "${'product_header'.tr()} (${order.products.count()})",
                        style: pw.TextStyle(
                            fontSize: 25, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 12),
                    ////////////// * Products Details * //////////////
                    ...[
                      for (var product in order.products) ...[
                        pw.Text(
                            "${'product_add_infoBar_name'.tr()}: ${product.name}",
                            style: const pw.TextStyle(fontSize: 22)),
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
                      ],
                      pw.SizedBox(height: 22),
                    ],
                    ////////////// * Payments * //////////////
                    pw.Text("${'payment_header'.tr()} ($totalPayments)",
                        style: pw.TextStyle(
                            fontSize: 25, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 12),
                    ////////////// * Payments Details * //////////////
                    ...[
                      for (var payment in order.payments) ...[
                        pw.Text(
                            "${'payment_add_infoBar_code'.tr()}: ${payment.code}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'payment_add_infoBar_price'.tr()}: ${payment.price}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                        pw.Text(
                            "${'date'.tr()}: ${DateFormat('yyyy-MM-dd hh:mm').format(order.date ?? DateTime.now())}",
                            style: const pw.TextStyle(fontSize: 22)),
                        pw.SizedBox(height: 7),
                      ],
                      pw.SizedBox(height: 22),
                    ]
                  ])));
        }));
  }
}

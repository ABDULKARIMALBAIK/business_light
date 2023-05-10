import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:business_light/domain/entity/order.dart';
import 'package:business_light/domain/entity/payment.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart' show Named, Injectable;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/repository/payment_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../mapper/payment_mapper.dart';
import '../repository/payment_operations.dart';

/// Usecase to make all operations in view model of Payment
@Named('PaymentUseCase')
@Injectable()
class PaymentUseCase implements PaymentOperations {
  PaymentUseCase(@Named('PaymentRepository') this.repository,
      @Named('PaymentMapper') this.mapper);

  final PaymentRepository repository;
  final PaymentMapper mapper;

  //! Remote Functions
  /// add new payment on the server
  @override
  addPaymentRemote() {}

  /// delete the payment on the server
  @override
  deletePaymentRemote() {}

  /// edit the payment on the server
  @override
  editPaymentRemote() {}

  /// Get payments data from server
  @override
  getAllPaymentsRemote() {}

  /// Get orders data from server
  @override
  loadAllOrdersRemote() {}

  //! Storage Functions
  /// add new payment on the storage
  @override
  Future<void> addPaymentStorage(
      {required String code,
      required double price,
      required String description,
      required PaymentType paymentType,
      required DateTime date,
      Order? selectedOrder}) async {
    Payment newPayment = Payment()
      ..code = code
      ..price = price
      ..description = description
      ..date = date
      ..paymentType = paymentType;
    repository.addPaymentStorage(newPayment, selectedOrder);
  }

  /// delete the payment on the storage
  @override
  Future<void> deletePaymentStorage(int? id) =>
      repository.deletePaymentStorage(id);

  /// edit the payment on the storage
  @override
  Future<void> editPaymentStorage(
          {required int? id,
          required String code,
          required double price,
          required String description,
          required PaymentType paymentType,
          required DateTime date}) async =>
      repository.editPaymentStorage(
          id: id,
          code: code,
          price: price,
          description: description,
          paymentType: paymentType,
          date: date);

  /// Get payments data from storage
  @override
  getAllPaymentsStorage(
      {required BlocListCubit<Payment> stater,
      required BlocDataTableCubit<Payment> cubit,
      required bool isRefresh,
      String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PaymentType? paymentType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Payment> payments = await repository.getAllPaymentStorage(
        filterCode: filterCode,
        filterPrice: filterPrice,
        filterDescription: filterDescription,
        paymentType: paymentType,
        startDate: startDate,
        endDate: endDate,
        filterIndexSort: filterIndexSort,
        desc: desc,
      );
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

  /// Get orders data from storage
  @override
  Future<List<Order>> loadAllOrdersStorage() =>
      repository.loadAllOrdersStorage();

  //! Navigation Functions
  /// Navigate to add new payment screen
  @override
  Future<int?> navigateAddPayment(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient
        .pushNamed<int>(Routers.newEditPaymentsName,
            params: {"newEditPayment": 0.toString()},
            extra: null,
            queryParams: {
              "isEdit": "false",
              "paymentType": PaymentType.other.name.tr(),
              "pageNum": pageIndex.toString()
            });

    return pageNum;
  }

  /// Navigate to edit the payment screen
  @override
  Future<int?> navigateEditPayment(int pageIndex, Payment payment) async {
    int? pageNum = await RouteGenerator.routerClient
        .pushNamed<int>(Routers.newEditPaymentsName,
            params: {"newEditPayment": payment.id.toString()},
            extra: payment,
            queryParams: {
              "isEdit": "true",
              "paymentType": payment.paymentType.name.tr(),
              "pageNum": pageIndex.toString()
            });
    return pageNum;
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(
      BuildContext context, List<Payment> payments) async {
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
                exportDataExcel(context, payments);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, payments);
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
        exportDataExcel(context, payments);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Payment> payments) {
    try {
      if (payments.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'payment_header'.tr()}${Random().nextInt(10000)}";
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //! Names for Columns
        final cellId = sheetObject.cell(CellIndex.indexByString("A1"));
        cellId.value = 'id'.tr();
        final cellCode = sheetObject.cell(CellIndex.indexByString("B1"));
        cellCode.value = 'code'.tr();
        final cellPrice = sheetObject.cell(CellIndex.indexByString("C1"));
        cellPrice.value = 'price'.tr();
        final cellDescription = sheetObject.cell(CellIndex.indexByString("D1"));
        cellDescription.value = 'description'.tr();
        final cellDate = sheetObject.cell(CellIndex.indexByString("E1"));
        cellDate.value = 'date'.tr();
        final cellPaymentType = sheetObject.cell(CellIndex.indexByString("F1"));
        cellPaymentType.value = 'payment_type'.tr();

        //! Insert Data in rows
        for (int i = 0; i < payments.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = payments[i].id;
          final cellCode =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellCode.value = payments[i].code;
          final cellPrice =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellPrice.value = payments[i].price;
          final cellDescription =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellDescription.value = payments[i].description;
          final cellDate =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellDate.value = DateFormat('yyyy-MM-dd hh:mm')
              .format(payments[i].date!)
              .toString();
          final cellPaymentType =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellPaymentType.value = payments[i].paymentType.name.tr();
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
}

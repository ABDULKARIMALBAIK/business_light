import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:business_light/domain/entity/payout.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/repository/payout_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../entity/user.dart';
import '../mapper/payout_mapper.dart';
import '../repository/payout_operations.dart';

/// Usecase to make all operations in view model of payout
@Named('PayoutUseCase')
@Injectable()
class PayoutUseCase implements PayoutOperations {
  PayoutUseCase(@Named('PayoutRepository') this.repository,
      @Named('PayoutMapper') this.mapper);

  final PayoutRepository repository;
  final PayoutMapper mapper;

  //! Remote Functions
  /// add new payout on the server
  @override
  addPayoutRemote() {}

  /// delete the payout on the server
  @override
  deletePayoutRemote() {}

  /// edit the payout on the server
  @override
  editPayoutRemote() {}

  /// Get payouts data from server
  @override
  getAllPayoutsRemote() {}

  /// Get all employees data from server
  @override
  loadAllEmployeesRemote() {}

  //! Storage Functions
  /// add new payout on the storage
  @override
  Future<void> addPayoutStorage(
      {required String code,
      required double price,
      required String description,
      required PayoutType payoutType,
      required User? selectedEmployeeSalary,
      required DateTime date}) async {
    Payout newPayout = Payout()
      ..code = code
      ..price = price
      ..description = description
      ..date = date
      ..employeeSalary.value = selectedEmployeeSalary
      ..payoutType = payoutType;

    repository.addPayoutStorage(newPayout);
  }

  /// delete the payout on the storage
  @override
  Future<void> deletePayoutStorage(int? id) =>
      repository.deletePayoutStorage(id);

  /// edit the payout on the storage
  @override
  Future<void> editPayoutStorage(
          {required int? id,
          required String code,
          required double price,
          required String description,
          required PayoutType payoutType,
          required DateTime date}) async =>
      repository.editPayoutStorage(
          id: id,
          code: code,
          price: price,
          description: description,
          payoutType: payoutType,
          date: date);

  /// Get payouts data from storage
  @override
  getAllPayoutsStorage(
      {required BlocListCubit<Payout> stater,
      required BlocDataTableCubit<Payout> cubit,
      required bool isRefresh,
      String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PayoutType? payoutType,
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
      final List<Payout> payouts = await repository.getAllPayoutStorage(
        filterCode: filterCode,
        filterPrice: filterPrice,
        filterDescription: filterDescription,
        payoutType: payoutType,
        startDate: startDate,
        endDate: endDate,
        filterIndexSort: filterIndexSort,
        desc: desc,
      );
      if (payouts.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = payouts;
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

  /// Get Employees data from storage
  @override
  Future<List<User>> loadAllEmployeesStorage() =>
      repository.loadAllEmployeesStorage();

  //! Navigation Functions
  /// Navigate to add new payout screen
  @override
  Future<int?> navigateAddPayout(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient
        .pushNamed<int>(Routers.newEditPayoutName,
            params: {"newEditPayout": 0.toString()},
            extra: null,
            queryParams: {
              "isEdit": "false",
              "payoutType": PayoutType.other.name.tr(),
              "pageNum": pageIndex.toString()
            });

    return pageNum;
  }

  /// Navigate to edit the payout screen
  @override
  Future<int?> navigateEditPayout(int pageIndex, Payout payout) async {
    int? pageNum = await RouteGenerator.routerClient
        .pushNamed<int>(Routers.newEditPayoutName,
            params: {"newEditPayout": payout.id.toString()},
            extra: payout,
            queryParams: {
              "isEdit": "true",
              "payoutType": payout.payoutType.name.tr(),
              "pageNum": pageIndex.toString()
            });
    return pageNum;
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(BuildContext context, List<Payout> payouts) async {
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
                exportDataExcel(context, payouts);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, payouts);
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
        exportDataExcel(context, payouts);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Payout> payouts) {
    try {
      if (payouts.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'payout_header'.tr()}${Random().nextInt(10000)}";
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
        final cellPayoutType = sheetObject.cell(CellIndex.indexByString("F1"));
        cellPayoutType.value = 'payout_type'.tr();

        //! Insert Data in rows
        for (int i = 0; i < payouts.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = payouts[i].id;
          final cellCode =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellCode.value = payouts[i].code;
          final cellPrice =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellPrice.value = payouts[i].price;
          final cellDescription =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellDescription.value = payouts[i].description;
          final cellDate =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellDate.value = DateFormat('yyyy-MM-dd hh:mm')
              .format(payouts[i].date!)
              .toString();
          final cellPayoutType =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellPayoutType.value = payouts[i].payoutType.name.tr();
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

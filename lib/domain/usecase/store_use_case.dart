import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:business_light/domain/entity/store.dart';
import 'package:business_light/domain/entity/status.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:business_light/domain/repository/store_operations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../data/repository/store_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../mapper/store_mapper.dart';

/// Usecase to make all operations in view model of store
@Named('StoreUseCase')
@Injectable()
class StoreUseCase implements StoreOperations {
  StoreUseCase(@Named('StoreRepository') this.repository,
      @Named('StoreMapper') this.mapper);

  final StoreRepository repository;
  final StoreMapper mapper;

  //! Remote Functions
  /// Get stores data from server
  @override
  getAllStoresRemote() {}

  /// add new store on the server
  @override
  addStoreRemote() {}

  /// delete the store on the server
  @override
  deleteStoreRemote() {}

  /// edit the store on the server
  @override
  editStoreRemote() {}

  //! Storage Functions
  /// Get stores data from storage
  @override
  getAllStoresStorage(
      {required BlocListCubit<Store> stater,
      required BlocDataTableCubit<Store> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterCode,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Store> stores = await repository.getAllStoresStorage(
          filterName: filterName,
          filterStatus: filterStatus,
          filterCode: filterCode,
          filterIndexSort: filterIndexSort,
          desc: desc);
      if (stores.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = stores;
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

  /// add new store on the storage
  @override
  Future<void> addStoreStorage(Status status, String name, String code) async {
    Store newStore = Store()
      ..name = name
      ..code = code
      ..status = status;
    repository.addStoreStorage(newStore);
  }

  /// delete the store on the storage
  @override
  Future<void> deleteStoreStorage(int? id) => repository.deleteStoreStorage(id);

  /// edit the store on the storage
  @override
  Future<void> editStoreStorage(
          int? id, String name, String code, Status statusAddEdit) =>
      repository.editStoreStorage(id, name, code, statusAddEdit);

  //! Navigation Functions
  /// Navigate to add new store screen
  @override
  Future<int?> navigateAddStore(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditStoreName,
        params: {"newEditStore": 0.toString()},
        extra: null,
        queryParams: {"isEdit": "false", "pageNum": pageIndex.toString()});

    return pageNum;
  }

  /// Navigate to edit the store screen
  @override
  Future<int?> navigateEditStore(int pageIndex, Store store) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditStoreName,
        params: {"newEditStore": store.id.toString()},
        extra: store,
        queryParams: {"isEdit": "true", "pageNum": pageIndex.toString()});
    return pageNum;
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(BuildContext context, List<Store> stores) async {
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
                exportDataExcel(context, stores);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, stores);
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
        exportDataExcel(context, stores);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Store> stores) {
    try {
      if (stores.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'store_header'.tr()}${Random().nextInt(10000)}";
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
        final cellStatus = sheetObject.cell(CellIndex.indexByString("D1"));
        cellStatus.value = 'status'.tr();

        //! Insert Data in rows
        for (int i = 0; i < stores.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = stores[i].id;
          final cellName =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellName.value = stores[i].name;
          final cellCode =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellCode.value = stores[i].code;
          final cellStatus =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellStatus.value = stores[i].status.name.tr();
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

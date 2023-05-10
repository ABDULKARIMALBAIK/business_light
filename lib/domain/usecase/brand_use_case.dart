import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:business_light/data/repository/brand_repository.dart';
import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:business_light/domain/entity/status.dart';
import 'package:business_light/domain/mapper/brand_mapper.dart';
import 'package:business_light/domain/repository/brand_operations.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../services/dio/exceptions.dart';
import '../../utils/toast.dart';

/// Usecase to make all operations in view model of brand
@Named('BrandUseCase')
@Injectable()
class BrandUseCase implements BrandOperations {
  BrandUseCase(@Named('BrandRepository') this.repository,
      @Named('BrandMapper') this.mapper);

  final BrandRepository repository;
  final BrandMapper mapper;

  //! Remote Functions
  /// Get brands data from server
  @override
  getAllBrandsRemote() {}

  /// delete the brand on the server
  @override
  deleteBrandRemote() {}

  /// add new brand on the server
  @override
  addBrandRemote() {}

  /// edit the brand on the server
  @override
  editBrandRemote() {}

  //! Storage Functions
  /// Get brands data from storage
  @override
  getAllBrandsStorage(
      {required BlocListCubit<Brand> stater,
      required BlocDataTableCubit<Brand> cubit,
      required bool isRefresh,
      String? filterName,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Brand> brands = await repository.getAllBrandsStorage(
          filterName: filterName,
          filterStatus: filterStatus,
          filterIndexSort: filterIndexSort,
          desc: desc);
      if (brands.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = brands;
        // !isRefresh ? cubit.setData = brands : cubit.data.addAll(brands);
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

  /// delete the brand on the storage
  @override
  Future<void> deleteBrandStorage(int? id) async =>
      repository.deleteBrandStorage(id);

  /// add new brand on the storage
  @override
  Future<void> addBrandStorage(Status status, String name) async {
    Brand newBrand = Brand()
      ..name = name
      ..status = status;
    repository.addBrandStorage(newBrand);
  }

  /// edit the brand on the storage
  @override
  Future<void> editBrandStorage(
      int? id, String name, Status statusAddEdit) async {
    repository.editBrandStorage(id, name, statusAddEdit);
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(BuildContext context, List<Brand> brands) async {
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
                exportDataExcel(context, brands);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, brands);
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
        exportDataExcel(context, brands);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Brand> brands) {
    try {
      if (brands.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'brand_header'.tr()}${Random().nextInt(10000)}";
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //! Names for Columns
        final cellId = sheetObject.cell(CellIndex.indexByString("A1"));
        cellId.value = 'id'.tr();
        final cellName = sheetObject.cell(CellIndex.indexByString("B1"));
        cellName.value = 'name'.tr();
        final cellStatus = sheetObject.cell(CellIndex.indexByString("C1"));
        cellStatus.value = 'status'.tr();

        //! Insert Data in rows
        for (int i = 0; i < brands.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = brands[i].id;
          final cellName =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellName.value = brands[i].name;
          final cellStatus =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellStatus.value = brands[i].status.name.tr();
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

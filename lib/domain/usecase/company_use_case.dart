import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

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

import '../../data/repository/company_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../entity/company.dart';
import '../mapper/company_mapper.dart';
import '../repository/company_operations.dart';

/// Usecase to make all operations in view model of company
@Named('CompanyUseCase')
@Injectable()
class CompanyUseCase implements CompanyOperations {
  CompanyUseCase(@Named('CompanyRepository') this.repository,
      @Named('CompanyMapper') this.mapper);

  final CompanyRepository repository;
  final CompanyMapper mapper;

  //! Remote Functions
  /// add new company on the server
  @override
  addCompanyRemote() {}

  /// delete the company on the server
  @override
  deleteCompanyRemote() {}

  /// edit the company on the server
  @override
  editCompanyRemote() {}

  /// Get companies data from server
  @override
  getAllCompaniesRemote() {}

  //! Storage Functions
  /// add new company on the storage
  @override
  Future<void> addCompanyStorage({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String imagePath,
    required String country,
    required String bio,
  }) async {
    Company newCompany = Company()
      ..name = name
      ..email = email
      ..phone = phone
      ..imagePath = imagePath
      ..address = address
      ..bio = bio
      ..country = country;
    repository.addCompanyStorage(newCompany);
  }

  /// edit the company on the storage
  @override
  Future<void> editCompanyStorage({
    required int? id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String imagePath,
    required String country,
    required String bio,
  }) async =>
      repository.editCompanyStorage(
          id: id,
          name: name,
          email: email,
          phone: phone,
          address: address,
          imagePath: imagePath,
          country: country,
          bio: bio);

  /// delete the company on the storage
  @override
  Future<void> deleteCompanyStorage(int? id) =>
      repository.deleteCompanyStorage(id);

  /// Get companies data from storage
  @override
  getAllCompaniesStorage(
      {required BlocListCubit<Company> stater,
      required BlocDataTableCubit<Company> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterAddress,
      String? filterCountry,
      String? filterBio,
      int? filterIndexSort,
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<Company> companies = await repository.getAllCompaniesStorage(
          filterName: filterName,
          filterEmail: filterEmail,
          filterPhone: filterPhone,
          filterAddress: filterAddress,
          filterCountry: filterCountry,
          filterBio: filterBio,
          filterIndexSort: filterIndexSort,
          desc: desc);
      if (companies.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = companies;
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
  /// Navigate to add new company screen
  @override
  Future<int?> navigateAddCompany(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditCompanyName,
        params: {"newEditCompany": 0.toString()},
        extra: null,
        queryParams: {"isEdit": "false", "pageNum": pageIndex.toString()});

    return pageNum;
  }

  /// Navigate to edit the company screen
  @override
  Future<int?> navigateEditCompany(int pageIndex, Company company) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditCompanyName,
        params: {"newEditCompany": company.id.toString()},
        extra: company,
        queryParams: {"isEdit": "true", "pageNum": pageIndex.toString()});
    return pageNum;
  }

  //! Excel Functions
  /// check permission to export excel file
  @override
  checkPermissionExportExcel(
      BuildContext context, List<Company> companies) async {
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
                exportDataExcel(context, companies);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, companies);
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
        exportDataExcel(context, companies);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<Company> companies) {
    try {
      if (companies.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'company_header'.tr()}${Random().nextInt(10000)}";
        final excel = Excel.createExcel();
        excel.rename('Sheet1', sheetName);
        final Sheet sheetObject = excel[sheetName];

        //! Names for Columns
        final cellId = sheetObject.cell(CellIndex.indexByString("A1"));
        cellId.value = 'id'.tr();
        final cellName = sheetObject.cell(CellIndex.indexByString("B1"));
        cellName.value = 'name'.tr();
        final cellPhone = sheetObject.cell(CellIndex.indexByString("C1"));
        cellPhone.value = 'phone'.tr();
        final cellEmail = sheetObject.cell(CellIndex.indexByString("D1"));
        cellEmail.value = 'email'.tr();
        final cellImagePath = sheetObject.cell(CellIndex.indexByString("E1"));
        cellImagePath.value = 'image_path'.tr();
        final cellAddress = sheetObject.cell(CellIndex.indexByString("F1"));
        cellAddress.value = 'address'.tr();
        final cellBio = sheetObject.cell(CellIndex.indexByString("G1"));
        cellBio.value = 'description'.tr();
        final cellCountry = sheetObject.cell(CellIndex.indexByString("H1"));
        cellCountry.value = 'country'.tr();

        //! Insert Data in rows
        for (int i = 0; i < companies.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = companies[i].id;
          final cellName =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellName.value = companies[i].name;
          final cellPhone =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellPhone.value = companies[i].phone;
          final cellEmail =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellEmail.value = companies[i].email;
          final cellImagePath =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellImagePath.value = companies[i].imagePath;
          final cellAddress =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellAddress.value = companies[i].address;
          final cellBio =
              sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
          cellBio.value = companies[i].bio;
          final cellCountry =
              sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
          cellCountry.value = companies[i].country;
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
        dialogTitle: 'Pick an image to your company',
        type: FileType.image);
    if (result != null) {
      return result.files.single.path ?? '';
    }
    return '';
  }
}

import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:business_light/domain/entity/user.dart';
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

import '../../data/repository/employees_repository.dart';
import '../../services/dio/exceptions.dart';
import '../../services/router/router_generator.dart';
import '../../services/router/routers.dart';
import '../../utils/toast.dart';
import '../entity/payout.dart';
import '../mapper/employees_mapper.dart';
import '../repository/employees_operations.dart';

/// Usecase to make all operations in view model of employees
@Named('EmployeesUseCase')
@Injectable()
class EmployeesUseCase implements EmployeesOperations {
  EmployeesUseCase(@Named('EmployeesRepository') this.repository,
      @Named('EmployeesMapper') this.mapper);

  final EmployeesRepository repository;
  final EmployeesMapper mapper;

  //! Remote Functions
  /// add new employee on the server
  @override
  addEmployeeRemote() {}

  /// delete the employee on the server
  @override
  deleteEmployeeRemote() {}

  /// edit the employee on the server
  @override
  editEmployeeRemote() {}

  /// Get employees data from server
  @override
  getAllEmployeesRemote() {}

  /// Get payouts data from server
  @override
  getAllPayoutsRemote() {}

  /// delete the payout on the server
  @override
  deletePayoutRemote() {}

  //! Storage Functions
  /// add new employee on the storage
  @override
  Future<void> addEmployeeStorage({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String salary,
    required String jobDescription,
    required String imagePath,
    required UserLevel level,
  }) async {
    User newEmployee = User()
      ..fullName = fullName
      ..email = email
      ..password = password
      ..phone = phone
      ..jobDescription = jobDescription
      ..imagePath = imagePath
      ..salary = double.tryParse(salary) ?? 0.0
      ..level = level;
    repository.addEmployeeStorage(newEmployee);
  }

  /// edit the employee on the storage
  @override
  Future<void> editEmployeeStorage({
    int? id,
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String salary,
    required String jobDescription,
    required String imagePath,
    required UserLevel level,
  }) async =>
      repository.editEmployeeStorage(
          id: id,
          fullName: fullName,
          email: email,
          password: password,
          salary: salary,
          phone: phone,
          jobDescription: jobDescription,
          imagePath: imagePath,
          level: level);

  /// delete the employee on the storage
  @override
  Future<void> deleteEmployeeStorage(int? id) =>
      repository.deleteEmployeeStorage(id);

  /// delete the payout on the storage
  @override
  Future<void> deletePayoutStorage(int? id) =>
      repository.deletePayoutStorage(id);

  /// Get employees data from storage
  @override
  getAllEmployeesStorage(
      {required BlocListCubit<User> stater,
      required BlocDataTableCubit<User> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      UserLevel? filterLevel,
      String? filterGreaterSalary,
      String? filterLowerSalary,
      int? filterIndexSort,
      bool? desc}) async {
    cubit.data.clear();
    if (!isRefresh) {
      stater.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    try {
      final List<User> employees = await repository.getAllEmployeesStorage(
          filterEmail: filterEmail,
          filterName: filterName,
          filterPhone: filterPhone,
          filterJobDescription: filterJobDescription,
          filterLevel: filterLevel,
          filterGreaterSalary: filterGreaterSalary,
          filterLowerSalary: filterLowerSalary,
          filterIndexSort: filterIndexSort,
          desc: desc);
      if (employees.isEmpty && cubit.data.isEmpty) {
        stater.updateState(newType: BlocListType.noData);
      } else {
        cubit.setData = employees;
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

  /// Get payouts data from storage
  @override
  getAllPayoutsStorage(
      {required BlocListCubit<Payout> stater,
      required BlocDataTableCubit<Payout> cubit,
      required bool isRefresh,
      User? userDetails,
      double? filterPrice,
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
      final List<Payout> payouts =
          await repository.getAllPayoutsEmployeeStorage(
        filterPrice: filterPrice,
        startDate: startDate,
        endDate: endDate,
        userDetails: userDetails,
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

  //! Navigation Functions
  /// Navigate to add new employee screen
  @override
  Future<int?> navigateAddEmployee(int pageIndex) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditEmployeeName,
        params: {"newEditEmployee": 0.toString()},
        extra: null,
        queryParams: {"isEdit": "false", "pageNum": pageIndex.toString()});

    return pageNum;
  }

  /// Navigate to edit the employee screen
  @override
  Future<int?> navigateEditEmployee(int pageIndex, User employee) async {
    int? pageNum = await RouteGenerator.routerClient.pushNamed<int>(
        Routers.newEditEmployeeName,
        params: {"newEditEmployee": employee.id.toString()},
        extra: employee,
        queryParams: {"isEdit": "true", "pageNum": pageIndex.toString()});
    return pageNum;
  }

  /// Navigate to details of employee screen
  @override
  navigateEmployeeDetails(User employee) async =>
      RouteGenerator.routerClient.pushNamed<int>(Routers.employeeDetailsName,
          params: {"employeeDetails": employee.id.toString()}, extra: employee);

  /// Navigate to edit the payout of employee screen
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
  checkPermissionExportExcel(BuildContext context, List<User> employees) async {
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
                exportDataExcel(context, employees);
              } else {
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'message_excel_cannot_export'.tr(),
                    severity: InfoBarSeverity.error);
              }
            } else {
              exportDataExcel(context, employees);
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
        exportDataExcel(context, employees);
      }
    } catch (e) {
      developer.log('error_excel: $e');
    }
  }

  /// Create excel file
  @override
  exportDataExcel(BuildContext context, List<User> employees) {
    try {
      if (employees.isEmpty) {
        CustomInfoBar.showDefault(
            context: context,
            title: 'message_excel_no_date'.tr(),
            severity: InfoBarSeverity.warning);
      } else {
        //! Make Excel File
        final String sheetName =
            "${'employees_header'.tr()}${Random().nextInt(10000)}";
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
        for (int i = 0; i < employees.length; i++) {
          final cellId = sheetObject.cell(CellIndex.indexByString("A${i + 2}"));
          cellId.value = employees[i].id;
          final cellName =
              sheetObject.cell(CellIndex.indexByString("B${i + 2}"));
          cellName.value = employees[i].fullName;
          final cellPassword =
              sheetObject.cell(CellIndex.indexByString("C${i + 2}"));
          cellPassword.value = employees[i].password;
          final cellEmail =
              sheetObject.cell(CellIndex.indexByString("D${i + 2}"));
          cellEmail.value = employees[i].email;
          final cellPhone =
              sheetObject.cell(CellIndex.indexByString("E${i + 2}"));
          cellPhone.value = employees[i].phone;
          final cellDescription =
              sheetObject.cell(CellIndex.indexByString("F${i + 2}"));
          cellDescription.value = employees[i].jobDescription;
          final cellImagePath =
              sheetObject.cell(CellIndex.indexByString("G${i + 2}"));
          cellImagePath.value = employees[i].imagePath;
          final cellLevel =
              sheetObject.cell(CellIndex.indexByString("H${i + 2}"));
          cellLevel.value = employees[i].level.name.tr();
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
        dialogTitle: 'Pick an image to your Employee',
        type: FileType.image);
    if (result != null) {
      return result.files.single.path ?? '';
    }
    return '';
  }
}

import 'dart:developer';

import 'package:business_light/domain/entity/user.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:injectable/injectable.dart';

import '../../domain/entity/payout.dart';
import '../../domain/usecase/employees_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class EmployeesViewModel extends EmployeesViewModelBase {
  EmployeesViewModel(@Named('EmployeesUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<User>();
    stater = BlocListCubit<User>();
    loadMore = BlocStateBuilderCubit();
    loadMoreDetails = BlocStateBuilderCubit();
    groupFilterCubit = BlocStateBuilderCubit();
    groupDetailsFilterCubit = BlocStateBuilderCubit();
    imageUpdateCubit = BlocStateBuilderCubit();
    imageDetails = BlocStateBuilderCubit();
    staterDetails = BlocListCubit<Payout>();
    brandDataTableCubitDetails = BlocDataTableCubit<Payout>();

    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<material.PaginatedDataTableState>();

    //! Init Controllers
    nameFilterController = TextEditingController();
    emailFilterController = TextEditingController();
    phoneFilterController = TextEditingController();
    jobDescriptionFilterController = TextEditingController();
    salaryFilterGreaterController = TextEditingController();
    salaryFilterLowerController = TextEditingController();

    priceFilterDetailsController = TextEditingController();

    nameNewEditController = TextEditingController();
    emailNewEditController = TextEditingController();
    passwordNewEditController = TextEditingController();
    salaryNewEditController = TextEditingController();
    phoneNewEditController = TextEditingController();
    jobDescriptionNewEditController = TextEditingController();
  }

  //! Keys
  late GlobalKey<FormFieldState> statusComboBoxKey;
  late GlobalKey<FormFieldState> sortComboBoxKey;
  late GlobalKey<material.PaginatedDataTableState> pageKey;

  //! Variables
  String dataTableId = 'dataTableId';
  String pageNum = '0';
  int sortIndex = -1;
  String sortContent = '';
  bool desc = false;
  String newEditComboLevel = '';
  String levelFilter = '';
  String newEditImage = '';
  DateTime? selectedStartDateDetails;
  DateTime? selectedEndDateDetails;
  String sortContentDetails = '';
  int sortIndexDetails = -1;
  bool descDetails = true;
  String dataTableIdDetails = 'dataTableIdDetails';

  //! Objects
  late BlocPaginationData<User> dataSource;
  late BlocPaginationData<Payout> dataSourceDetails;
  User? editUser;
  User? userDetails;

  //! Blocs
  late final BlocDataTableCubit<User> brandDataTableCubit;
  late final BlocListCubit<User> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterCubit;
  late final BlocStateBuilderCubit imageUpdateCubit;
  late final BlocStateBuilderCubit imageDetails;
  late final BlocStateBuilderCubit groupDetailsFilterCubit;
  late final BlocListCubit<Payout> staterDetails;
  late final BlocStateBuilderCubit loadMoreDetails;
  late final BlocDataTableCubit<Payout> brandDataTableCubitDetails;

  //! UseCase
  final EmployeesUseCase useCase;

  //! Controllers
  late final TextEditingController nameFilterController;
  late final TextEditingController emailFilterController;
  late final TextEditingController phoneFilterController;
  late final TextEditingController jobDescriptionFilterController;
  late final TextEditingController salaryFilterGreaterController;
  late final TextEditingController salaryFilterLowerController;

  late final TextEditingController priceFilterDetailsController;

  late final TextEditingController nameNewEditController;
  late final TextEditingController emailNewEditController;
  late final TextEditingController phoneNewEditController;
  late final TextEditingController passwordNewEditController;
  late final TextEditingController salaryNewEditController;
  late final TextEditingController jobDescriptionNewEditController;

  //! Storage Methods
  /// Get all employees from storage
  @override
  getAllEmployeesStorage(bool isRefresh) {
    useCase.getAllEmployeesStorage(
        filterIndexSort: sortIndex,
        filterName: nameFilterController.text,
        filterEmail: emailFilterController.text,
        filterPhone: phoneFilterController.text,
        filterJobDescription: jobDescriptionFilterController.text,
        filterLevel: getLevels(),
        filterGreaterSalary: salaryFilterGreaterController.text,
        filterLowerSalary: salaryFilterLowerController.text,
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        desc: desc);
  }

  /// Get all payouts from storage
  @override
  getAllPayoutsStorage(bool isRefresh) {
    useCase.getAllPayoutsStorage(
        filterPrice: double.tryParse(priceFilterDetailsController.text),
        startDate: selectedStartDateDetails,
        endDate: selectedEndDateDetails,
        userDetails: userDetails,
        filterIndexSort: sortIndexDetails,
        desc: descDetails,
        stater: staterDetails,
        cubit: brandDataTableCubitDetails,
        isRefresh: isRefresh);
  }

  /// Delete the payout from storage
  @override
  deletePayoutStorage(int id) async {
    await useCase.deletePayoutStorage(id);
    getAllPayoutsStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Delete the employee from storage
  @override
  deleteEmployeeStorage(int id) async {
    await useCase.deleteEmployeeStorage(id);
    getAllEmployeesStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Add new employee to storage
  @override
  addEmployeeStorage() async => useCase.addEmployeeStorage(
      fullName: nameNewEditController.text,
      email: emailNewEditController.text,
      password: passwordNewEditController.text,
      salary: salaryNewEditController.text,
      phone: phoneNewEditController.text,
      imagePath: newEditImage,
      jobDescription: jobDescriptionNewEditController.text,
      level: getLevelAddEdit());

  /// Edit the employee to storage
  @override
  editEmployeeStorage() => useCase.editEmployeeStorage(
      id: editUser!.id,
      fullName: nameNewEditController.text,
      email: emailNewEditController.text,
      password: passwordNewEditController.text,
      salary: salaryNewEditController.text,
      phone: phoneNewEditController.text,
      imagePath: newEditImage,
      jobDescription: jobDescriptionNewEditController.text,
      level: getLevelAddEdit());

  //! Operations Methods
  /// Get Employee Level from string
  @override
  UserLevel? getLevels() {
    String currentLevel = levelFilter;
    if (currentLevel == UserLevel.worker.name.tr()) {
      return UserLevel.worker;
    } else if (currentLevel == UserLevel.manager.name.tr()) {
      return UserLevel.manager;
    } else if (currentLevel == UserLevel.other.name.tr()) {
      return UserLevel.other;
    } else {
      return null;
    }
  }

  /// Reset all parameters that are used for filtering
  @override
  Future<void> resetFilters() async {
    sortIndex = -1;
    sortContent = '';
    desc = false;
    levelFilter = '';
    nameFilterController.clear();
    emailFilterController.clear();
    phoneFilterController.clear();
    jobDescriptionFilterController.clear();
    salaryFilterGreaterController.clear();
    salaryFilterLowerController.clear();
    groupFilterCubit.update();
  }

  /// Reset all parameters that are used for filtering in details screen
  @override
  resetFiltersDetails() {
    sortIndexDetails = -1;
    sortContentDetails = '';
    descDetails = false;
    selectedStartDateDetails = null;
    selectedEndDateDetails = null;
    priceFilterDetailsController.clear();

    groupDetailsFilterCubit.update();
  }

  /// Pick image from local file manager
  @override
  void pickImage() async {
    String path = await useCase.pickImage();
    if (path.isNotEmpty) {
      log('imagePath: $path');
      newEditImage = path;
      imageUpdateCubit.update();
    }
  }

  /// Initial all parameters for add or edit screen
  @override
  void initEditEmployee(String isEdit) {
    if (isEdit == 'true') {
      if (editUser != null) {
        nameNewEditController.text = editUser!.fullName ?? '';
        passwordNewEditController.text = editUser!.password ?? '';
        salaryNewEditController.text = editUser!.salary == null
            ? 0.0.toString()
            : editUser!.salary.toString();
        emailNewEditController.text = editUser!.email ?? '';
        phoneNewEditController.text = editUser!.phone ?? '';
        jobDescriptionNewEditController.text = editUser!.jobDescription ?? '';

        newEditImage = editUser!.imagePath ?? '';
        newEditComboLevel = editUser!.level.name.tr();
      }
    }
  }

  /// Get Customer Level from string
  @override
  UserLevel getLevelAddEdit() {
    if (newEditComboLevel == UserLevel.worker.name.tr()) {
      return UserLevel.worker;
    } else if (newEditComboLevel == UserLevel.manager.name.tr()) {
      return UserLevel.manager;
    } else if (newEditComboLevel == UserLevel.other.name.tr()) {
      return UserLevel.other;
    } else {
      return UserLevel.boss;
    }
  }

  //! Navigation Methods
  /// Navigate to add new employee screen
  @override
  navigateAddEmployee() async {
    int? pageIndex = await useCase.navigateAddEmployee(int.parse(pageNum));
    if (pageIndex != null) {
      newEditComboLevel = '';
      newEditImage = '';
      nameNewEditController.clear();
      emailNewEditController.clear();
      passwordNewEditController.clear();
      salaryNewEditController.clear();
      phoneNewEditController.clear();
      jobDescriptionNewEditController.clear();
      pageNum = pageIndex.toString();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllEmployeesStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the employee screen
  @override
  navigateEditEmployee(User employee) async {
    int? pageIndex =
        await useCase.navigateEditEmployee(int.parse(pageNum), employee);
    if (pageIndex != null) {
      newEditComboLevel = '';
      newEditImage = '';
      nameNewEditController.clear();
      emailNewEditController.clear();
      passwordNewEditController.clear();
      salaryNewEditController.clear();
      phoneNewEditController.clear();
      jobDescriptionNewEditController.clear();
      pageNum = pageIndex.toString();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllEmployeesStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to employee's details screen
  @override
  void navigateEmployeeDetails(User employee) async =>
      await useCase.navigateEmployeeDetails(employee);

  /// Navigate to edit the payout screen
  @override
  navigateEditPayout(Payout payout) async {
    int? pageIndex =
        await useCase.navigateEditPayout(int.parse(pageNum), payout);
    if (pageIndex != null) {
      // newEditDate = null;
      // newEditComboPayoutType = '';
      // codeNewEditController.clear();
      // priceNewEditController.clear();
      // descriptionNewEditController.clear();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllPayoutsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  //! Excel Methods
  /// Export employees data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

/// Declare all behaviors that will be used in the ViewModel
abstract class EmployeesViewModelBase {
  editEmployeeStorage();
  addEmployeeStorage();
  navigateEditEmployee(User employee);
  navigateAddEmployee();
  deletePayoutStorage(int id);
  getAllPayoutsStorage(bool isRefresh);
  deleteEmployeeStorage(int id);
  getAllEmployeesStorage(bool isRefresh);

  navigateEditPayout(Payout payout);
  void navigateEmployeeDetails(User employee);

  void initEditEmployee(String isEdit);
  void pickImage();
  resetFiltersDetails();
  UserLevel? getLevels();
  Future<void> resetFilters();
  UserLevel getLevelAddEdit();

  exportExcel(BuildContext context);
}

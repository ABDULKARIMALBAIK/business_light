import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:injectable/injectable.dart';

import '../../domain/entity/payout.dart';
import '../../domain/entity/user.dart';
import '../../domain/usecase/payout_use_case.dart';
import '../../utils/toast.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class PayoutViewModel extends PayoutViewModelBase {
  PayoutViewModel(@Named('PayoutUseCase') this.useCase) {
    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<material.PaginatedDataTableState>();

    //! Init Controllers
    codeFilterController = TextEditingController();
    priceFilterController = TextEditingController();
    descriptionFilterController = TextEditingController();

    codeNewEditController = TextEditingController();
    priceNewEditController = TextEditingController();
    descriptionNewEditController = TextEditingController();

    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Payout>();
    stater = BlocListCubit<Payout>();
    loadMore = BlocStateBuilderCubit();
    groupFilterCubit = BlocStateBuilderCubit();
    employeeSelectedSalary = BlocStateBuilderCubit();
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
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? newEditDate;
  String newEditComboPayoutType = '';
  String payoutTypeEditAdd = '';
  String payoutTypeFilter = '';

  //! Objects
  late BlocPaginationData<Payout> dataSource;
  Payout? editPayout;
  User? selectedEmployee;
  List<User> allEmployees = [];

  //! Blocs
  late final BlocDataTableCubit<Payout> brandDataTableCubit;
  late final BlocListCubit<Payout> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterCubit;
  late final BlocStateBuilderCubit employeeSelectedSalary;

  //! UseCase
  final PayoutUseCase useCase;

  //! Controllers
  late final TextEditingController codeFilterController;
  late final TextEditingController priceFilterController;
  late final TextEditingController descriptionFilterController;

  late final TextEditingController codeNewEditController;
  late final TextEditingController priceNewEditController;
  late final TextEditingController descriptionNewEditController;

  //! Storage Methods
  /// Get all payouts from storage
  @override
  getAllPayoutsStorage(bool isRefresh) {
    useCase.getAllPayoutsStorage(
        filterCode: codeFilterController.text,
        filterPrice: double.tryParse(priceFilterController.text),
        filterDescription: descriptionFilterController.text,
        payoutType: getPayoutType(),
        startDate: selectedStartDate,
        endDate: selectedEndDate,
        filterIndexSort: sortIndex,
        desc: desc,
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh);
  }

  /// Delete the payout from storage
  @override
  deletePayoutStorage(int id) async {
    await useCase.deletePayoutStorage(id);
    getAllPayoutsStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Add new payout to storage
  @override
  addPayoutStorage(BuildContext context, String isEdit) async {
    PayoutType payoutType = getPayoutTypeAddEdit(isEdit);

    if (payoutType == PayoutType.salary && selectedEmployee == null) {
      CustomInfoBar.showDefault(
          context: context,
          title: 'message_cannot_add_payout_salary'.tr(),
          severity: InfoBarSeverity.error);
    } else {
      useCase.addPayoutStorage(
          code: codeNewEditController.text,
          price: double.tryParse(priceNewEditController.text) ?? 0.0,
          description: descriptionNewEditController.text,
          date: newEditDate ?? DateTime.now(),
          selectedEmployeeSalary: selectedEmployee,
          payoutType: payoutType);
    }
  }

  /// Edit the payout to storage
  @override
  editPayoutStorage(String isEdit) => useCase.editPayoutStorage(
      id: editPayout!.id,
      code: codeNewEditController.text,
      price: double.tryParse(priceNewEditController.text) ?? 0.0,
      description: descriptionNewEditController.text,
      date: newEditDate ?? DateTime.now(),
      payoutType: getPayoutTypeAddEdit(isEdit));

  /// Get all employees from storage
  @override
  loadAllEmployeesStorage() async {
    allEmployees = await useCase.loadAllEmployeesStorage();
  }

  /// Get payout type from string
  @override
  PayoutType? getPayoutType() {
    if (payoutTypeFilter == PayoutType.tax.name.tr()) {
      return PayoutType.tax;
    } else if (payoutTypeFilter == PayoutType.salary.name.tr()) {
      return PayoutType.salary;
    } else if (payoutTypeFilter == PayoutType.debt.name.tr()) {
      return PayoutType.debt;
    } else if (payoutTypeFilter == PayoutType.other.name.tr()) {
      return PayoutType.other;
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
    payoutTypeFilter = '';
    codeFilterController.clear();
    priceFilterController.clear();
    descriptionFilterController.clear();

    selectedStartDate = null;
    selectedEndDate = null;

    groupFilterCubit.update();
  }

  /// Initial all parameters for add or edit screen
  @override
  void initEditPayout(String isEdit) {
    if (isEdit == 'true') {
      if (editPayout != null) {
        codeNewEditController.text = editPayout!.code ?? '';
        priceNewEditController.text = editPayout!.price.toString();
        descriptionNewEditController.text = editPayout!.description ?? '';
        newEditDate = editPayout!.date ?? DateTime.now();
        newEditComboPayoutType = editPayout!.payoutType.name.tr();
      }
    }
  }

  /// A method to change payoutType value
  @override
  PayoutType getPayoutTypeAddEdit(String isEdit) {
    String payoutType;
    if (isEdit == 'true') {
      payoutType = payoutTypeEditAdd;
    } else {
      payoutType = newEditComboPayoutType;
    }

    if (payoutType == PayoutType.tax.name.tr()) {
      return PayoutType.tax;
    } else if (payoutType == PayoutType.debt.name.tr()) {
      return PayoutType.debt;
    } else if (payoutType == PayoutType.salary.name.tr()) {
      return PayoutType.salary;
    }
    //Other
    else {
      return PayoutType.other;
    }

    // if (payoutTypeEditAdd == PayoutType.debt.name.tr()) {
    //   return PayoutType.debt;
    // } else if (payoutTypeEditAdd == PayoutType.salary.name.tr()) {
    //   return PayoutType.salary;
    // }
    // //Other,Tax
    // else {
    //   if (newEditComboPayoutType == PayoutType.tax.name.tr()) {
    //     return PayoutType.tax;
    //   } else {
    //     return PayoutType.other;
    //   }
    // }
  }

  /// Generate random code to current payout
  @override
  generateCode() {
    codeNewEditController.text = Random().nextInt(10000000).toString();
  }

  //! Navigation Methods
  /// Navigate to add new payout screen
  @override
  navigateAddPayout() async {
    int? pageIndex = await useCase.navigateAddPayout(int.parse(pageNum));
    if (pageIndex != null) {
      newEditDate = null;
      newEditComboPayoutType = '';
      codeNewEditController.clear();
      priceNewEditController.clear();
      descriptionNewEditController.clear();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllPayoutsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the payout screen
  @override
  navigateEditPayout(Payout payout) async {
    int? pageIndex =
        await useCase.navigateEditPayout(int.parse(pageNum), payout);
    if (pageIndex != null) {
      newEditDate = null;
      newEditComboPayoutType = '';
      codeNewEditController.clear();
      priceNewEditController.clear();
      descriptionNewEditController.clear();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllPayoutsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  //! Excel Methods
  /// Export payout data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

abstract class PayoutViewModelBase {
  getAllPayoutsStorage(bool isRefresh);
  PayoutType? getPayoutType();
  deletePayoutStorage(int id);
  Future<void> resetFilters();
  void initEditPayout(String isEdit);
  navigateAddPayout();
  navigateEditPayout(Payout payout);
  addPayoutStorage(BuildContext context, String isEdit);
  editPayoutStorage(String isEdit);
  PayoutType getPayoutTypeAddEdit(String isEdit);
  loadAllEmployeesStorage();
  exportExcel(BuildContext context);
  generateCode();
}

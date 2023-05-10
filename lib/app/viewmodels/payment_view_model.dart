import 'dart:math';

import 'package:business_light/utils/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:injectable/injectable.dart' show Injectable, Named;

import '../../domain/entity/order.dart';
import '../../domain/entity/payment.dart';
import '../../domain/usecase/payment_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class PaymentViewModel extends PaymentViewModelBase {
  PaymentViewModel(@Named('PaymentUseCase') this.useCase) {
    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<material.PaginatedDataTableState>();

    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Payment>();
    stater = BlocListCubit<Payment>();
    loadMore = BlocStateBuilderCubit();
    groupFilterCubit = BlocStateBuilderCubit();
    paymentSelectedOrder = BlocStateBuilderCubit();

    //! Init Controllers
    codeFilterController = TextEditingController();
    priceFilterController = TextEditingController();
    descriptionFilterController = TextEditingController();

    codeNewEditController = TextEditingController();
    priceNewEditController = TextEditingController();
    descriptionNewEditController = TextEditingController();
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
  String newEditComboPaymentType = '';
  String paymentTypeEditAdd = '';
  String paymentTypeFilter = '';

  //! Objects
  late BlocPaginationData<Payment> dataSource;
  Payment? editPayment;
  Order? selectedOrder;

  //! Blocs
  late final BlocDataTableCubit<Payment> brandDataTableCubit;
  late final BlocListCubit<Payment> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterCubit;
  late final BlocStateBuilderCubit paymentSelectedOrder;

  //! UseCase
  final PaymentUseCase useCase;

  //! Controllers
  late final TextEditingController codeFilterController;
  late final TextEditingController priceFilterController;
  late final TextEditingController descriptionFilterController;

  late final TextEditingController codeNewEditController;
  late final TextEditingController priceNewEditController;
  late final TextEditingController descriptionNewEditController;

  //! Lists
  List<Order> allOrders = [];

  //! Storage Methods
  /// Get all payments from storage
  @override
  getAllPaymentsStorage(bool isRefresh) {
    useCase.getAllPaymentsStorage(
        filterCode: codeFilterController.text,
        filterPrice: double.tryParse(priceFilterController.text),
        filterDescription: descriptionFilterController.text,
        paymentType: getPaymentType(),
        startDate: selectedStartDate,
        endDate: selectedEndDate,
        filterIndexSort: sortIndex,
        desc: desc,
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh);
  }

  /// Delete the payment from storage
  @override
  deletePaymentStorage(int id) async {
    await useCase.deletePaymentStorage(id);
    getAllPaymentsStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Get all orders from storage
  @override
  loadAllOrdersStorage() async {
    allOrders = await useCase.loadAllOrdersStorage();
  }

  /// Add new payment to storage
  @override
  addPaymentStorage(BuildContext context, String isEdit) async {
    PaymentType paymentType = getPaymentTypeAddEdit(isEdit);

    if (paymentType == PaymentType.order && selectedOrder == null) {
      CustomInfoBar.showDefault(
          context: context,
          title: 'message_cannot_add_payment_order'.tr(),
          severity: InfoBarSeverity.error);
    } else {
      useCase.addPaymentStorage(
          code: codeNewEditController.text,
          price: double.tryParse(priceNewEditController.text) ?? 0.0,
          description: descriptionNewEditController.text,
          date: newEditDate ?? DateTime.now(),
          paymentType: paymentType,
          selectedOrder: selectedOrder);
    }
  }

  /// Edit the payment to storage
  @override
  editPaymentStorage(String isEdit) => useCase.editPaymentStorage(
      id: editPayment!.id,
      code: codeNewEditController.text,
      price: double.tryParse(priceNewEditController.text) ?? 0.0,
      description: descriptionNewEditController.text,
      date: newEditDate ?? DateTime.now(),
      paymentType: getPaymentTypeAddEdit(isEdit));

  //! Operations Methods
  /// Get payment type from string
  @override
  PaymentType? getPaymentType() {
    if (paymentTypeFilter == PaymentType.order.name.tr()) {
      return PaymentType.order;
    } else if (paymentTypeFilter == PaymentType.other.name.tr()) {
      return PaymentType.other;
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
    paymentTypeFilter = '';
    codeFilterController.clear();
    priceFilterController.clear();
    descriptionFilterController.clear();

    selectedStartDate = null;
    selectedEndDate = null;

    groupFilterCubit.update();
  }

  /// Initial all parameters for add or edit screen
  @override
  void initEditPayment(String isEdit) {
    if (isEdit == 'true') {
      if (editPayment != null) {
        codeNewEditController.text = editPayment!.code ?? '';
        priceNewEditController.text = editPayment!.price.toString();
        descriptionNewEditController.text = editPayment!.description ?? '';
        newEditDate = editPayment!.date ?? DateTime.now();
        newEditComboPaymentType = editPayment!.paymentType.name.tr();
      }
    }
  }

  /// Generate random code to current payment
  @override
  generateCode() {
    codeNewEditController.text = Random().nextInt(10000000).toString();
  }

  /// A method to change paymentType value
  @override
  PaymentType getPaymentTypeAddEdit(String isEdit) {
    String paymentType;
    if (isEdit == 'true') {
      paymentType = paymentTypeEditAdd;
    } else {
      paymentType = newEditComboPaymentType;
    }

    if (paymentType == PaymentType.order.name.tr()) {
      return PaymentType.order;
    }
    //Other
    else {
      return PaymentType.other;
    }
  }

  //! Navigation Methods
  /// Navigate to add new payment screen
  @override
  navigateAddPayment() async {
    int? pageIndex = await useCase.navigateAddPayment(int.parse(pageNum));
    if (pageIndex != null) {
      newEditDate = null;
      newEditComboPaymentType = '';
      codeNewEditController.clear();
      priceNewEditController.clear();
      descriptionNewEditController.clear();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllPaymentsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the payment screen
  @override
  navigateEditPayment(Payment payment) async {
    int? pageIndex =
        await useCase.navigateEditPayment(int.parse(pageNum), payment);
    if (pageIndex != null) {
      newEditDate = null;
      newEditComboPaymentType = '';
      codeNewEditController.clear();
      priceNewEditController.clear();
      descriptionNewEditController.clear();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllPaymentsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  //! Excel Methods
  /// Export payments data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

abstract class PaymentViewModelBase {
  getAllPaymentsStorage(bool isRefresh);
  deletePaymentStorage(int id);
  loadAllOrdersStorage();
  addPaymentStorage(BuildContext context, String isEdit);
  editPaymentStorage(String isEdit);
  PaymentType getPaymentTypeAddEdit(String isEdit);

  PaymentType? getPaymentType();
  Future<void> resetFilters();
  void initEditPayment(String isEdit);
  generateCode();

  navigateAddPayment();
  navigateEditPayment(Payment payment);

  exportExcel(BuildContext context);
}

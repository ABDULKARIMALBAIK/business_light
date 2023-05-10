import 'dart:developer';

import 'package:business_light/domain/entity/user.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:injectable/injectable.dart' show Injectable, Named;

import '../../domain/entity/order.dart';
import '../../domain/entity/payment.dart';
import '../../domain/usecase/customer_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class CustomerViewModel extends CustomerViewModelBase {
  CustomerViewModel(@Named('CustomerUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<User>();
    brandDataTableOrdersCubit = BlocDataTableCubit<Order>();
    brandDataTablePaymentsCubit = BlocDataTableCubit<Payment>();
    stater = BlocListCubit<User>();
    staterOrders = BlocListCubit<Order>();
    staterPayments = BlocListCubit<Payment>();
    loadMore = BlocStateBuilderCubit();
    loadMoreOrders = BlocStateBuilderCubit();
    loadMorePayments = BlocStateBuilderCubit();
    groupFilterCubit = BlocStateBuilderCubit();
    imageUpdateCubit = BlocStateBuilderCubit();

    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<material.PaginatedDataTableState>();

    //! Init Controllers
    nameFilterController = TextEditingController();
    emailFilterController = TextEditingController();
    phoneFilterController = TextEditingController();
    jobDescriptionFilterController = TextEditingController();

    nameNewEditController = TextEditingController();
    emailNewEditController = TextEditingController();
    passwordNewEditController = TextEditingController();
    phoneNewEditController = TextEditingController();
    jobDescriptionNewEditController = TextEditingController();
  }

  //! Keys
  late GlobalKey<FormFieldState> statusComboBoxKey;
  late GlobalKey<FormFieldState> sortComboBoxKey;
  late GlobalKey<material.PaginatedDataTableState> pageKey;

  //! Variables
  String dataTableId = 'dataTableId';
  String dataTableIdOrders = 'dataTableIdOrders';
  String dataTableIdPayments = 'dataTableIdPayments';
  String pageNum = '0';
  int sortIndex = -1;
  String sortContent = '';
  bool desc = false;
  String newEditImage = '';
  double totalOrderPrice = 0.0;
  double totalPaymentPrice = 0.0;

  //! Objects
  late BlocPaginationData<User> dataSource;
  late BlocPaginationData<Order> dataSourceOrders;
  late BlocPaginationData<Payment> dataSourcePayments;
  User? editUser;
  User? userDetails;

  //! Blocs
  late final BlocDataTableCubit<User> brandDataTableCubit;
  late final BlocDataTableCubit<Order> brandDataTableOrdersCubit;
  late final BlocDataTableCubit<Payment> brandDataTablePaymentsCubit;
  late final BlocListCubit<User> stater;
  late final BlocListCubit<Order> staterOrders;
  late final BlocListCubit<Payment> staterPayments;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit loadMoreOrders;
  late final BlocStateBuilderCubit loadMorePayments;
  late final BlocStateBuilderCubit groupFilterCubit;
  late final BlocStateBuilderCubit imageUpdateCubit;

  //! UseCase
  final CustomerUseCase useCase;

  //! Controllers
  late final TextEditingController nameFilterController;
  late final TextEditingController emailFilterController;
  late final TextEditingController phoneFilterController;
  late final TextEditingController jobDescriptionFilterController;

  late final TextEditingController nameNewEditController;
  late final TextEditingController emailNewEditController;
  late final TextEditingController phoneNewEditController;
  late final TextEditingController passwordNewEditController;
  late final TextEditingController jobDescriptionNewEditController;

  //! Lists
  List<Order> userDetailsOrders = [];
  List<Payment> userDetailsPayments = [];

  //! Storage Methods
  /// Get all customers from storage
  @override
  getAllCustomersStorage(bool isRefresh) async {
    await useCase.getAllCustomersStorage(
        filterIndexSort: sortIndex,
        filterName: nameFilterController.text,
        filterEmail: emailFilterController.text,
        filterPhone: phoneFilterController.text,
        filterJobDescription: jobDescriptionFilterController.text,
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        desc: desc);
  }

  /// Get all customer's order from storage
  @override
  Future<void> getAllCustomerOrdersStorage(bool isRefresh) =>
      useCase.getAllCustomerOrdersStorage(
        customer: userDetails!,
        isRefresh: isRefresh,
        cubit: brandDataTableOrdersCubit,
        stater: staterOrders,
      );

  /// Get all customer's payments from storage
  @override
  Future<void> getAllCustomerPaymentsStorage(bool isRefresh) =>
      useCase.getAllCustomerPaymentsStorage(
        customer: userDetails!,
        isRefresh: isRefresh,
        cubit: brandDataTablePaymentsCubit,
        stater: staterPayments,
      );

  /// Delete the customer from storage
  @override
  deleteCustomerStorage(int id) async {
    await useCase.deleteCustomerStorage(id);
    getAllCustomersStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Add new customer to storage
  @override
  addCustomerStorage() async => useCase.addCustomerStorage(
      fullName: nameNewEditController.text,
      email: emailNewEditController.text,
      password: passwordNewEditController.text,
      phone: phoneNewEditController.text,
      imagePath: newEditImage,
      jobDescription: jobDescriptionNewEditController.text);

  /// Edit the company on storage
  @override
  editCustomerStorage() => useCase.editCustomerStorage(
      id: editUser!.id,
      fullName: nameNewEditController.text,
      email: emailNewEditController.text,
      password: passwordNewEditController.text,
      phone: phoneNewEditController.text,
      imagePath: newEditImage,
      jobDescription: jobDescriptionNewEditController.text);

  //! Operations Methods
  /// Reset all parameters that are used for filtering
  @override
  Future<void> resetFilters() async {
    sortIndex = -1;
    sortContent = '';
    desc = false;
    nameFilterController.clear();
    emailFilterController.clear();
    phoneFilterController.clear();
    jobDescriptionFilterController.clear();
    groupFilterCubit.update();
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
  void initEditCustomer(String isEdit) {
    if (isEdit == 'true') {
      if (editUser != null) {
        nameNewEditController.text = editUser!.fullName ?? '';
        passwordNewEditController.text = editUser!.password ?? '';
        emailNewEditController.text = editUser!.email ?? '';
        phoneNewEditController.text = editUser!.phone ?? '';
        jobDescriptionNewEditController.text = editUser!.jobDescription ?? '';

        newEditImage = editUser!.imagePath ?? '';
      }
    }
  }

  /// Load customer's payments and orders and save total payments price and total orders price
  @override
  Future<bool> loadData() async {
    await getAllCustomerOrdersStorage(false);
    await getAllCustomerPaymentsStorage(false);

    List<double> totalOrderPrices = brandDataTableOrdersCubit.data
        .map((order) => order.finalPrice ?? 0.0)
        .toList();
    double totalOrders = 0.0;
    for (double value in totalOrderPrices) {
      totalOrders += value;
    }
    totalOrderPrice = totalOrders;

    List<double> totalPaymentPrices = brandDataTablePaymentsCubit.data
        .map((payment) => payment.price ?? 0.0)
        .toList();

    double totalPayments = 0.0;
    for (double value in totalPaymentPrices) {
      totalPayments += value;
    }

    totalPaymentPrice = totalPayments;

    return true;
  }

  //! Navigation Methods
  /// Navigate to add new customer screen
  @override
  navigateAddCustomer() async {
    int? pageIndex = await useCase.navigateAddCustomer(int.parse(pageNum));
    if (pageIndex != null) {
      newEditImage = '';
      nameNewEditController.clear();
      emailNewEditController.clear();
      passwordNewEditController.clear();
      phoneNewEditController.clear();
      jobDescriptionNewEditController.clear();
      pageNum = pageIndex.toString();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllCustomersStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the customer screen
  @override
  navigateEditCustomer(User customer) async {
    int? pageIndex =
        await useCase.navigateEditCustomer(int.parse(pageNum), customer);
    if (pageIndex != null) {
      newEditImage = '';
      nameNewEditController.clear();
      emailNewEditController.clear();
      passwordNewEditController.clear();
      phoneNewEditController.clear();
      jobDescriptionNewEditController.clear();
      pageNum = pageIndex.toString();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllCustomersStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to customer's details screen
  @override
  void navigateCustomerDetails(User customer) async =>
      await useCase.navigateCustomerDetails(customer);

  //! Excel Methods
  /// Export customers data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);

  //! Saving and Printing Methods
  /// Save QR code in local files manager (Downloads folder)
  @override
  void saveCode({required String codeText, required String nameFile}) =>
      useCase.saveCode(codeText: codeText, nameFile: nameFile);

  /// Printing QR code and save it in local files manager (Downloads folder)
  @override
  void printCode(Order order) => useCase.printCode(order);
}

/// Declare all behaviors that will be used in the ViewModel
abstract class CustomerViewModelBase {
  getAllCustomersStorage(bool isRefresh);
  Future<void> getAllCustomerPaymentsStorage(bool isRefresh);
  Future<void> getAllCustomerOrdersStorage(bool isRefresh);
  editCustomerStorage();
  addCustomerStorage();
  deleteCustomerStorage(int id);

  void navigateCustomerDetails(User customer);
  navigateEditCustomer(User customer);
  navigateAddCustomer();

  Future<bool> loadData();
  void printCode(Order order);
  void initEditCustomer(String isEdit);
  void pickImage();
  void saveCode({required String codeText, required String nameFile});
  Future<void> resetFilters();

  exportExcel(BuildContext context);
}

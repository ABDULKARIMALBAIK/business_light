import 'dart:math';

import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:injectable/injectable.dart' show Injectable, Named;
import 'package:flutter/material.dart' as material;

import '../../domain/entity/order.dart';
import '../../domain/entity/product.dart';
import '../../domain/entity/product_order.dart';
import '../../domain/entity/user.dart';
import '../../domain/usecase/order_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class OrderViewModel extends OrderViewModelBase {
  OrderViewModel(@Named('OrderUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Order>();
    stater = BlocListCubit<Order>();
    loadMore = BlocStateBuilderCubit();
    groupFilterCubit = BlocStateBuilderCubit();
    showColumnsCubit = BlocStateBuilderCubit();
    orderPaymentsCubit = BlocStateBuilderCubit();
    orderProductsCubit = BlocStateBuilderCubit();
    selectedProductsCubit = BlocStateBuilderCubit();

    //! Init Controllers
    codeFilterController = TextEditingController();
    greaterTotalPriceFilterController = TextEditingController();
    lessTotalPriceFilterController = TextEditingController();
    greaterPricePiecesFilterController = TextEditingController();
    lessPricePiecesFilterController = TextEditingController();
    greaterFinalPriceFilterController = TextEditingController();
    lessFinalPriceFilterController = TextEditingController();
    descriptionFilterController = TextEditingController();

    codeNewEditController = TextEditingController();
    descriptionNewEditController = TextEditingController();
    totalQtyNewEditController = TextEditingController(text: '0');
    qtyPiecesNewEditController = TextEditingController(text: '0');
    totalPriceNewEditController = TextEditingController(text: '0.0');
    chargeCostNewEditController = TextEditingController(text: '0.0');
    otherCostNewEditController = TextEditingController(text: '0.0');
    balancerNewEditController = TextEditingController(text: '0.0');
    discountNewEditController = TextEditingController(text: '0.0');
    finalPriceNewEditController = TextEditingController(text: '0.0');

    searchProductNameNewEditController = TextEditingController();
    searchProductCodeNewEditController = TextEditingController();

    //! Init Keys
    pageKey = GlobalKey<material.PaginatedDataTableState>();
  }

  //! Keys
  late GlobalKey<material.PaginatedDataTableState> pageKey;

  //! Blocs
  late final BlocDataTableCubit<Order> brandDataTableCubit;
  late final BlocListCubit<Order> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterCubit;
  late final BlocStateBuilderCubit showColumnsCubit;
  late final BlocStateBuilderCubit orderPaymentsCubit;
  late final BlocStateBuilderCubit orderProductsCubit;
  late final BlocStateBuilderCubit selectedProductsCubit;

  //! Variables
  String dataTableId = 'dataTableId';
  String pageNum = '0';
  int sortIndex = -1;
  String sortContent = '';
  String typeFilter = '';
  bool desc = false;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? newEditDate = DateTime.now();
  String newEditComboOrderType = '';

  //! UseCase
  final OrderUseCase useCase;

  //! Controllers
  late final TextEditingController codeFilterController;
  late final TextEditingController greaterTotalPriceFilterController;
  late final TextEditingController lessTotalPriceFilterController;
  late final TextEditingController greaterPricePiecesFilterController;
  late final TextEditingController lessPricePiecesFilterController;
  late final TextEditingController greaterFinalPriceFilterController;
  late final TextEditingController lessFinalPriceFilterController;
  late final TextEditingController descriptionFilterController;

  late final TextEditingController codeNewEditController;
  late final TextEditingController descriptionNewEditController;
  late final TextEditingController totalQtyNewEditController;
  late final TextEditingController qtyPiecesNewEditController;
  late final TextEditingController totalPriceNewEditController;
  late final TextEditingController chargeCostNewEditController;
  late final TextEditingController otherCostNewEditController;
  late final TextEditingController balancerNewEditController;
  late final TextEditingController discountNewEditController;
  late final TextEditingController finalPriceNewEditController;

  late final TextEditingController searchProductNameNewEditController;
  late final TextEditingController searchProductCodeNewEditController;

  //! Objects
  late BlocPaginationData<Order> dataSource;
  User? filterCustomer;
  Order? orderDetailsProducts;
  Order? orderDetailsPayments;
  Order? editOrder;
  User? customerOrder;

  //! Lists
  List<User> customersList = [];
  List<Product> productsList = [];
  List<ProductOrder> selectedProductsList = [];

  //! Storage Methods
  /// Delete the order from storage
  @override
  deleteOrderStorage(int? id) async {
    await useCase.deleteOrderStorage(id);
    orderPaymentsCubit.change(false);
    orderProductsCubit.change(false);
    orderDetailsPayments = null;
    orderDetailsProducts = null;
    getAllOrdersStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Get all customers from storage
  @override
  Future<bool> getAllCustomersStorage() async {
    customersList = await useCase.getAllCustomersStorage();
    return true;
  }

  /// Get all orders from storage
  @override
  getAllOrdersStorage(bool isRefresh) {
    useCase.getAllOrdersStorage(
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        codeFilterController: codeFilterController.text,
        greaterTotalPriceFilterController:
            double.tryParse(greaterTotalPriceFilterController.text),
        lessTotalPriceFilterController:
            double.tryParse(lessTotalPriceFilterController.text),
        greaterPricePiecesFilterController:
            double.tryParse(greaterPricePiecesFilterController.text),
        lessPricePiecesFilterController:
            double.tryParse(lessPricePiecesFilterController.text),
        greaterFinalPriceFilterController:
            double.tryParse(greaterFinalPriceFilterController.text),
        lessFinalPriceFilterController:
            double.tryParse(lessFinalPriceFilterController.text),
        descriptionFilterController: descriptionFilterController.text,
        selectedStartDate: selectedStartDate,
        selectedEndDate: selectedEndDate,
        typeFilter: getType(typeFilter),
        filterCustomer: filterCustomer,
        filterIndexSort: sortIndex,
        desc: desc);
  }

  /// Add new order to storage
  @override
  Future<void> addOrderStorage() async => useCase.addOrderStorage(
      code: codeNewEditController.text,
      description: descriptionNewEditController.text,
      totalQty: int.tryParse(totalQtyNewEditController.text) ?? 0,
      qtyPieces: int.tryParse(qtyPiecesNewEditController.text) ?? 0,
      totalPrice: double.tryParse(totalPriceNewEditController.text) ?? 0.0,
      chargeCost: double.tryParse(chargeCostNewEditController.text) ?? 0.0,
      otherCost: double.tryParse(otherCostNewEditController.text) ?? 0.0,
      balancer: double.tryParse(balancerNewEditController.text) ?? 0.0,
      discount: double.tryParse(discountNewEditController.text) ?? 0.0,
      finalPrice: double.tryParse(finalPriceNewEditController.text) ?? 0.0,
      date: newEditDate ?? DateTime.now(),
      payments: [],
      productsOrder: selectedProductsList,
      selectedCustomer: customerOrder,
      orderType: getType(newEditComboOrderType));

  /// Get all products from storage
  @override
  Future<bool> getAllProductsStorage() async {
    productsList = await useCase.getAllProductsStorage();
    return true;
  }

  //! Operations Methods
  /// Get order type from string
  @override
  TypeOrder? getType(String currentType) {
    if (currentType == TypeOrder.negotiation.name.tr()) {
      return TypeOrder.negotiation;
    } else if (currentType == TypeOrder.deal.name.tr()) {
      return TypeOrder.deal;
    } else if (currentType == TypeOrder.sell.name.tr()) {
      return TypeOrder.sell;
    } else if (currentType == TypeOrder.complete.name.tr()) {
      return TypeOrder.complete;
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
    typeFilter = '';

    selectedStartDate = null;
    selectedEndDate = null;

    filterCustomer = null;

    codeFilterController.clear();
    greaterTotalPriceFilterController.clear();
    lessTotalPriceFilterController.clear();
    greaterPricePiecesFilterController.clear();
    lessPricePiecesFilterController.clear();
    greaterFinalPriceFilterController.clear();
    lessFinalPriceFilterController.clear();
    descriptionFilterController.clear();

    groupFilterCubit.update();
  }

  /// Initial all parameters for add or edit screen
  @override
  void initEditOrder(String isEdit) {
    if (isEdit == 'true') {
      codeNewEditController.text = editOrder!.code ?? '';
      descriptionNewEditController.text = editOrder!.description ?? '';
      totalQtyNewEditController.text = editOrder!.totalQty.toString();
      qtyPiecesNewEditController.text = editOrder!.qtyPieces.toString();
      totalPriceNewEditController.text = editOrder!.totalPrice.toString();
      chargeCostNewEditController.text = editOrder!.chargeCost.toString();
      otherCostNewEditController.text = editOrder!.otherCost.toString();
      balancerNewEditController.text = editOrder!.balancer.toString();
      discountNewEditController.text = editOrder!.discount.toString();
      finalPriceNewEditController.text = editOrder!.finalPrice.toString();

      newEditDate = editOrder!.date;
      newEditComboOrderType = editOrder!.type.name.tr();
      customerOrder = editOrder!.user.value;
    }
  }

  /// Columns are checked (true) will be shown
  @override
  void updateShowColumns() => showColumnsCubit.update();

  /// Generate random code to current order
  @override
  generateCode() {
    codeNewEditController.text = Random().nextInt(10000000).toString();
  }

  /// Using listeners to change values of text controllers
  @override
  void addListeners() {
    selectedProductsList = [];
    totalPriceNewEditController.addListener(() {
      updateFinalPriceController();
    });
    chargeCostNewEditController.addListener(() {
      updateFinalPriceController();
    });
    otherCostNewEditController.addListener(() {
      updateFinalPriceController();
    });
    balancerNewEditController.addListener(() {
      updateFinalPriceController();
    });
    discountNewEditController.addListener(() {
      updateFinalPriceController();
    });
  }

  /// Implement changing the value of controllers
  @override
  void updateFinalPriceController() {
    final double totalPrice =
        double.tryParse(totalPriceNewEditController.text) ?? 0.0;
    final double chargeCost =
        double.tryParse(chargeCostNewEditController.text) ?? 0.0;
    final double otherCost =
        double.tryParse(otherCostNewEditController.text) ?? 0.0;
    final double balancer =
        double.tryParse(balancerNewEditController.text) ?? 0.0;
    final double discount =
        double.tryParse(discountNewEditController.text) ?? 0.0;
    finalPriceNewEditController.text =
        (totalPrice + chargeCost + otherCost + balancer - discount).toString();
    // if (totalPrice != null &&
    //     chargeCost != null &&
    //     otherCost != null &&
    //     balancer != null &&
    //     discount != null) {
    //   finalPriceNewEditController.text =
    //       (totalPrice + chargeCost + otherCost + balancer - discount)
    //           .toString();
    // } else {
    //   finalPriceNewEditController.text = '0.0';
    // }
  }

  /// Hide payments and products sections of order
  @override
  void hidePaymentsProducts() {
    orderPaymentsCubit.change(false);
    orderProductsCubit.change(false);
  }

  /// Show products section of order
  @override
  void showProducts(Order order) {
    orderDetailsProducts = order;
    orderProductsCubit.change(true);
  }

  /// Show payments section of order
  @override
  void showPayments(Order order) {
    orderDetailsPayments = order;
    orderPaymentsCubit.change(true);
  }

  //! Saving and Printing Methods
  /// Save QR code in local files manager (Downloads folder)
  @override
  Future<void> saveCode({required String codeText, required String nameFile}) =>
      useCase.saveCode(codeText: codeText, nameFile: nameFile);

  /// Printing order data and save it in local files manager (Downloads folder)
  @override
  Future<void> printCode(Order order) => useCase.printCode(order);

  //! Card Methods
  /// Add new product to list of products of order
  @override
  Future<void> addProductCart(Product product) async {
    final newProductOrder = ProductOrder()
      ..productId = product.id
      ..name = product.name
      ..code = product.code
      ..piecesPerPackage = product.qtyPackage
      ..piecePrice = product.newFinalPrice
      ..piecesQty = product.qtyPackage
      ..packagePrice = product.newFinalPrice! * product.qtyPackage!
      ..packagesQty = 1
      ..packagesQtyStore = product.totalPackages
      ..imagePath = product.imagePath
      ..date = product.date;
    selectedProductsList.insert(0, newProductOrder);

    int totalQty = int.tryParse(totalQtyNewEditController.text) ?? 0;
    int qtyPieces = int.tryParse(qtyPiecesNewEditController.text) ?? 0;

    totalQty += 1;
    // qtyPieces +=
    //     newProductOrder.packagesQty! * newProductOrder.piecesPerPackage!;
    qtyPieces += newProductOrder.piecesPerPackage!;

    totalQtyNewEditController.text = totalQty.toString();
    qtyPiecesNewEditController.text = qtyPieces.toString();

    double totalPrice =
        double.tryParse(totalPriceNewEditController.text) ?? 0.0;

    // totalPrice += newProductOrder.piecePrice! *
    //     newProductOrder.packagesQty! *
    //     newProductOrder.piecesPerPackage!;
    totalPrice +=
        newProductOrder.piecePrice! * newProductOrder.piecesPerPackage!;

    totalPriceNewEditController.text = totalPrice.toStringAsFixed(2);
  }

  /// Increase number of packages (pieces) of product in current order
  @override
  Future<void> increaseOrderProduct(
      ProductOrder productOrder, int index) async {
    if (productOrder.packagesQty! < productOrder.packagesQtyStore!) {
      int totalQty = int.tryParse(totalQtyNewEditController.text) ?? 0;
      int qtyPieces = int.tryParse(qtyPiecesNewEditController.text) ?? 0;

      // totalQty -= selectedProductsList[index].packagesQty ?? 1;
      // qtyPieces -= selectedProductsList[index].packagesQty! *
      //     selectedProductsList[index].piecesQty!;

      selectedProductsList[index].packagesQty =
          selectedProductsList[index].packagesQty! + 1;

      selectedProductsList[index].piecesQty =
          selectedProductsList[index].piecesQty! +
              selectedProductsList[index].piecesPerPackage!;

      totalQty += 1;
      qtyPieces += selectedProductsList[index].piecesPerPackage ?? 0;

      // totalQty += selectedProductsList[index].packagesQty ?? 1;
      // qtyPieces += selectedProductsList[index].packagesQty! *
      //     selectedProductsList[index].piecesQty!;

      totalQtyNewEditController.text = totalQty.toString();
      qtyPiecesNewEditController.text = qtyPieces.toString();

      double totalPrice = 0.0;
      for (ProductOrder selectedProduct in selectedProductsList) {
        // double totalPricePieces = selectedProduct.piecePrice! *
        //     selectedProduct.packagesQty! *
        //     selectedProduct.piecesQty!;
        double totalPricePieces =
            selectedProduct.piecePrice! * selectedProduct.piecesQty!;
        totalPrice += totalPricePieces;
      }
      totalPriceNewEditController.text = totalPrice.toStringAsFixed(2);
    }
  }

  /// Decrease number of packages (pieces) of product in current order
  @override
  Future<void> decreaseOrderProduct(
      ProductOrder productOrder, int index) async {
    if (productOrder.packagesQty! > 1) {
      int totalQty = int.tryParse(totalQtyNewEditController.text) ?? 0;
      int qtyPieces = int.tryParse(qtyPiecesNewEditController.text) ?? 0;

      selectedProductsList[index].packagesQty =
          selectedProductsList[index].packagesQty! - 1;

      selectedProductsList[index].piecesQty =
          selectedProductsList[index].piecesQty! -
              selectedProductsList[index].piecesPerPackage!;

      // selectedProductsList[index].packagesQty =
      //     selectedProductsList[index].packagesQty! - 1;

      totalQty -= 1;
      qtyPieces -= selectedProductsList[index].piecesPerPackage ?? 0;
      // qtyPieces -= selectedProductsList[index].packagesQty! *
      //     selectedProductsList[index].piecesQty!;

      totalQtyNewEditController.text = totalQty.toString();
      qtyPiecesNewEditController.text = qtyPieces.toString();

      double totalPrice = 0.0;
      for (ProductOrder selectedProduct in selectedProductsList) {
        // double totalPricePieces = selectedProduct.piecePrice! *
        //     selectedProduct.packagesQty! *
        //     selectedProduct.piecesQty!;
        double totalPricePieces =
            selectedProduct.piecePrice! * selectedProduct.piecesQty!;
        totalPrice += totalPricePieces;
      }
      totalPriceNewEditController.text = totalPrice.toStringAsFixed(2);
    }
  }

  /// Delete the product from list of products of order
  @override
  Future<void> deleteProductCart(ProductOrder productOrder, int index) async {
    int totalQty = int.tryParse(totalQtyNewEditController.text) ?? 0;
    int qtyPieces = int.tryParse(qtyPiecesNewEditController.text) ?? 0;

    totalQty -= selectedProductsList[index].packagesQty ?? 0;
    // qtyPieces -= selectedProductsList[index].packagesQty! *
    //     selectedProductsList[index].piecesQty!;
    qtyPieces -= selectedProductsList[index].piecesQty!;

    totalQtyNewEditController.text = totalQty.toString();
    qtyPiecesNewEditController.text = qtyPieces.toString();

    selectedProductsList.removeAt(index);

    double totalPrice = 0.0;
    for (ProductOrder selectedProduct in selectedProductsList) {
      // double totalPricePieces = selectedProduct.piecePrice! *
      //     selectedProduct.packagesQty! *
      //     selectedProduct.piecesQty!;
      double totalPricePieces =
          selectedProduct.piecePrice! * selectedProduct.piecesQty!;
      totalPrice += totalPricePieces;
    }
    totalPriceNewEditController.text = totalPrice.toStringAsFixed(2);
  }

  //! Excel Methods
  /// Export orders data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);

  //! Navigation Methods
  /// Navigate to add new order screen
  @override
  void navigateAddOrder() async {
    int? pageIndex = await useCase.navigateAddOrder(int.parse(pageNum));
    if (pageIndex != null) {
      codeNewEditController.clear();
      descriptionNewEditController.clear();
      totalQtyNewEditController.clear();
      qtyPiecesNewEditController.clear();
      totalPriceNewEditController.clear();
      chargeCostNewEditController.clear();
      otherCostNewEditController.clear();
      balancerNewEditController.clear();
      discountNewEditController.clear();
      finalPriceNewEditController.clear();

      newEditDate = DateTime.now();
      newEditComboOrderType = '';
      customerOrder = null;

      pageNum = pageIndex.toString();
      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllOrdersStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }
}

/// Declare all behaviors that will be used in the ViewModel
abstract class OrderViewModelBase {
  deleteOrderStorage(int? id);
  Future<bool> getAllCustomersStorage();
  getAllOrdersStorage(bool isRefresh);
  Future<void> addOrderStorage();
  Future<bool> getAllProductsStorage();

  TypeOrder? getType(String currentType);
  Future<void> resetFilters();
  void initEditOrder(String isEdit);
  void updateShowColumns();
  Future<void> saveCode({required String codeText, required String nameFile});
  Future<void> printCode(Order order);
  generateCode();
  void addListeners();
  void updateFinalPriceController();
  Future<void> addProductCart(Product product);
  Future<void> increaseOrderProduct(ProductOrder productOrder, int index);
  Future<void> decreaseOrderProduct(ProductOrder productOrder, int index);
  Future<void> deleteProductCart(ProductOrder productOrder, int index);
  exportExcel(BuildContext context);
  void navigateAddOrder();
  void hidePaymentsProducts();
  void showProducts(Order order);
  void showPayments(Order order);
}

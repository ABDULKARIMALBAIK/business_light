import 'dart:math';

import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/entity/product.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart' as material;

import '../../domain/entity/status.dart';
import '../../domain/entity/store.dart';
import '../../domain/usecase/product_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class ProductViewModel extends ProductViewModelBase {
  ProductViewModel(@Named('ProductUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Product>();
    stater = BlocListCubit<Product>();
    loadMore = BlocStateBuilderCubit();
    groupFilterOneControllerCubit = BlocStateBuilderCubit();
    groupFilterTwoControllerCubit = BlocStateBuilderCubit();
    showColumnsCubit = BlocStateBuilderCubit();
    imageUpdateCubit = BlocStateBuilderCubit();

    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<material.PaginatedDataTableState>();

    //! Init Controllers
    nameFilterController = TextEditingController();
    codeFilterController = TextEditingController();
    skuFilterController = TextEditingController();
    descriptionFilterController = TextEditingController();
    qtyPackageFilterController = TextEditingController();
    totalPackagesFilterController = TextEditingController();
    paidTotalPackagesFilterController = TextEditingController();
    greaterNewFinalPriceStartController = TextEditingController();
    lessNewFinalPriceEndController = TextEditingController();
    greaterNewFinalPackageStartController = TextEditingController();
    lessNewFinalPackageEndController = TextEditingController();
    qtyUnitsFilterController = TextEditingController();

    nameNewEditController = TextEditingController();
    skuNewEditController = TextEditingController();
    codeNewEditController = TextEditingController();
    descriptionNewEditController = TextEditingController();
    weightNewEditController = TextEditingController();
    originalPriceNewEditController = TextEditingController();
    costsPriceNewEditController = TextEditingController();
    profitNewEditController = TextEditingController();
    oldFinalPriceNewEditController = TextEditingController();
    newFinalPriceNewEditController = TextEditingController();
    qtyPackageNewEditController = TextEditingController();
    oldFinalPricePackageNewEditController = TextEditingController();
    newFinalPricePackageNewEditController = TextEditingController();
    totalPackagesNewEditController = TextEditingController();
    paidTotalPackagesNewEditController = TextEditingController();
    paidTotalUnitsNewEditController = TextEditingController();
    totalPriceNewEditController = TextEditingController();
    paidTotalPriceNewEditController = TextEditingController();
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
  String newEditComboStatus = '';
  String statusFilter = '';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  DateTime? newEditDate;
  String imagePathNewEdit = '';

  //! Lists
  List<Brand> brandsList = [];
  List<Store> storesList = [];

  //! UseCase
  final ProductUseCase useCase;

  //! Objects
  late BlocPaginationData<Product> dataSource;
  Product? editProduct;
  Brand? filterBrands;
  Store? filterStores;
  Brand? newEditBrand;
  Store? newEditStore;

  //! Blocs
  late final BlocDataTableCubit<Product> brandDataTableCubit;
  late final BlocListCubit<Product> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterOneControllerCubit;
  late final BlocStateBuilderCubit groupFilterTwoControllerCubit;
  late final BlocStateBuilderCubit showColumnsCubit;
  late final BlocStateBuilderCubit imageUpdateCubit;

  //! Controllers
  late final TextEditingController nameFilterController;
  late final TextEditingController codeFilterController;
  late final TextEditingController skuFilterController;
  late final TextEditingController descriptionFilterController;
  late final TextEditingController qtyPackageFilterController;
  late final TextEditingController qtyUnitsFilterController;
  late final TextEditingController totalPackagesFilterController;
  late final TextEditingController paidTotalPackagesFilterController;
  late final TextEditingController greaterNewFinalPriceStartController;
  late final TextEditingController lessNewFinalPriceEndController;
  late final TextEditingController greaterNewFinalPackageStartController;
  late final TextEditingController lessNewFinalPackageEndController;

  late final TextEditingController nameNewEditController;
  late final TextEditingController codeNewEditController;
  late final TextEditingController skuNewEditController;
  late final TextEditingController descriptionNewEditController;
  late final TextEditingController weightNewEditController;
  late final TextEditingController originalPriceNewEditController;
  late final TextEditingController costsPriceNewEditController;
  late final TextEditingController profitNewEditController;
  late final TextEditingController oldFinalPriceNewEditController;
  late final TextEditingController newFinalPriceNewEditController;
  late final TextEditingController qtyPackageNewEditController;
  late final TextEditingController oldFinalPricePackageNewEditController;
  late final TextEditingController newFinalPricePackageNewEditController;
  late final TextEditingController totalPackagesNewEditController;
  late final TextEditingController paidTotalPackagesNewEditController;
  late final TextEditingController paidTotalUnitsNewEditController;
  late final TextEditingController totalPriceNewEditController;
  late final TextEditingController paidTotalPriceNewEditController;

  //! Storage Methods
  /// Get all products from storage
  @override
  getAllProductsStorage(bool isRefresh) {
    useCase.getAllProductsStorage(
        filterIndexSort: sortIndex,
        filterName: nameFilterController.text,
        filterCode: codeFilterController.text,
        filterSKU: skuFilterController.text,
        filterDescription: descriptionFilterController.text,
        filterBrand: filterBrands,
        filterStore: filterStores,
        filterStartDate: selectedStartDate,
        filterEndDate: selectedEndDate,
        filterGreaterPackagePrice:
            double.tryParse(greaterNewFinalPackageStartController.text),
        filterGreaterUnitPrice:
            double.tryParse(greaterNewFinalPriceStartController.text),
        filterLessPackagePrice:
            double.tryParse(lessNewFinalPackageEndController.text),
        filterLessUnitPrice:
            double.tryParse(lessNewFinalPriceEndController.text),
        filterPackagesQuantity: int.tryParse(qtyPackageFilterController.text),
        filterPaidPackagesQuantity:
            int.tryParse(paidTotalPackagesFilterController.text),
        filterUnitsQuantity: int.tryParse(qtyUnitsFilterController.text),
        filterStatus: getStatus(),
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        desc: desc);
  }

  /// Get all brands from storage
  @override
  Future<bool> getAllBrands() async {
    List<Brand> allBrands = await useCase.getAllBrandsStorage();
    brandsList = allBrands;
    return true;
  }

  /// Get all stores from storage
  @override
  Future<bool> getAllStores() async {
    List<Store> allStores = await useCase.getAllStoresStorage();
    storesList = allStores;
    return true;
  }

  /// Delete the product from storage
  @override
  deleteProductStorage(int? id) async {
    await useCase.deleteProductStorage(id);
    getAllProductsStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Add new product to storage
  @override
  Future<void> addProductStorage() async => useCase.addProductStorage(
        nameNewEditController.text,
        codeNewEditController.text,
        skuNewEditController.text,
        double.tryParse(weightNewEditController.text) ?? 0.0,
        double.tryParse(originalPriceNewEditController.text) ?? 0.0,
        double.tryParse(costsPriceNewEditController.text) ?? 0.0,
        double.tryParse(profitNewEditController.text) ?? 0.0,
        double.tryParse(oldFinalPriceNewEditController.text) ?? 0.0,
        double.tryParse(newFinalPriceNewEditController.text) ?? 0.0,
        int.tryParse(qtyPackageNewEditController.text) ?? 0,
        double.tryParse(oldFinalPricePackageNewEditController.text) ?? 0.0,
        double.tryParse(newFinalPricePackageNewEditController.text) ?? 0.0,
        int.tryParse(totalPackagesNewEditController.text) ?? 0,
        int.tryParse(paidTotalPackagesNewEditController.text) ?? 0,
        int.tryParse(paidTotalUnitsNewEditController.text) ?? 0,
        double.tryParse(totalPriceNewEditController.text) ?? 0.0,
        double.tryParse(paidTotalPriceNewEditController.text) ?? 0.0,
        imagePathNewEdit,
        descriptionNewEditController.text,
        newEditDate ?? DateTime.now(),
        getStatusAddEdit(),
        newEditStore!,
        newEditBrand!,
      );

  /// Edit the product on storage
  @override
  editProductStorage() async => useCase.editProductStorage(
        editProduct!.id,
        nameNewEditController.text,
        codeNewEditController.text,
        skuNewEditController.text,
        double.tryParse(weightNewEditController.text) ?? 0.0,
        double.tryParse(originalPriceNewEditController.text) ?? 0.0,
        double.tryParse(costsPriceNewEditController.text) ?? 0.0,
        double.tryParse(profitNewEditController.text) ?? 0.0,
        double.tryParse(oldFinalPriceNewEditController.text) ?? 0.0,
        double.tryParse(newFinalPriceNewEditController.text) ?? 0.0,
        int.tryParse(qtyPackageNewEditController.text) ?? 0,
        double.tryParse(oldFinalPricePackageNewEditController.text) ?? 0.0,
        double.tryParse(newFinalPricePackageNewEditController.text) ?? 0.0,
        int.tryParse(totalPackagesNewEditController.text) ?? 0,
        int.tryParse(paidTotalPackagesNewEditController.text) ?? 0,
        int.tryParse(paidTotalUnitsNewEditController.text) ?? 0,
        double.tryParse(totalPriceNewEditController.text) ?? 0.0,
        double.tryParse(paidTotalPriceNewEditController.text) ?? 0.0,
        imagePathNewEdit,
        descriptionNewEditController.text,
        newEditDate ?? DateTime.now(),
        getStatusAddEdit(),
        newEditStore!,
        newEditBrand!,
      );

  //! Operations Methods
  /// Get Status from string
  @override
  Status? getStatus() {
    String currentStatus = statusFilter;
    if (currentStatus == Status.active.name.tr()) {
      return Status.active;
    } else if (currentStatus == Status.inactive.name.tr()) {
      return Status.inactive;
    } else {
      return null;
    }
  }

  /// Columns are checked (true) will be shown
  @override
  void updateShowColumns() => showColumnsCubit.update();

  /// Reset all parameters that are used for filtering
  @override
  Future<void> resetFilters() async {
    sortIndex = -1;
    sortContent = '';
    desc = false;
    statusFilter = '';
    nameFilterController.clear();
    codeFilterController.clear();
    skuFilterController.clear();
    descriptionFilterController.clear();
    qtyPackageFilterController.clear();
    totalPackagesFilterController.clear();
    paidTotalPackagesFilterController.clear();
    greaterNewFinalPriceStartController.clear();
    lessNewFinalPriceEndController.clear();
    greaterNewFinalPackageStartController.clear();
    lessNewFinalPackageEndController.clear();

    filterBrands = null;
    filterStores = null;
    selectedStartDate = null;
    selectedEndDate = null;

    groupFilterOneControllerCubit.update();
    groupFilterTwoControllerCubit.update();
  }

  /// Initial all parameters for add or edit screen
  @override
  void initEditProduct(String isEdit) {
    if (isEdit == 'true') {
      if (editProduct != null) {
        newEditComboStatus = editProduct!.status.name.tr();
        nameNewEditController.text = editProduct!.name ?? '';
        codeNewEditController.text = editProduct!.code ?? '';
        skuNewEditController.text = editProduct!.sku ?? '';
        descriptionNewEditController.text = editProduct!.description ?? '';
        oldFinalPriceNewEditController.text =
            editProduct!.oldFinalPrice.toString();
        newFinalPriceNewEditController.text =
            editProduct!.newFinalPrice.toString();
        qtyPackageNewEditController.text = editProduct!.qtyPackage.toString();
        oldFinalPricePackageNewEditController.text =
            editProduct!.oldFinalPricePackage.toString();
        newFinalPricePackageNewEditController.text =
            editProduct!.newFinalPricePackage.toString();
        totalPackagesNewEditController.text =
            editProduct!.totalPackages.toString();
        paidTotalPackagesNewEditController.text =
            editProduct!.paidTotalPackages.toString();
        paidTotalUnitsNewEditController.text =
            editProduct!.paidTotalUnits.toString();
        totalPriceNewEditController.text = editProduct!.totalPrice.toString();
        paidTotalPriceNewEditController.text =
            editProduct!.paidTotalPrice.toString();
        weightNewEditController.text = editProduct!.weight.toString();
        originalPriceNewEditController.text =
            editProduct!.originalPrice.toString();
        costsPriceNewEditController.text = editProduct!.costsPrice.toString();
        profitNewEditController.text = editProduct!.profit.toString();

        imagePathNewEdit = editProduct!.imagePath ?? '';
        newEditDate = editProduct!.date;

        newEditComboStatus = editProduct!.status.name.tr();
        if (brandsList.isNotEmpty) {
          newEditBrand = brandsList.singleWhere((brand) =>
              brand.id ==
              editProduct!.brand.value!.id); //editProduct!.brand.value
        }

        if (storesList.isNotEmpty) {
          newEditStore = storesList.singleWhere((store) =>
              store.id ==
              editProduct!.store.value!.id); //editProduct!.store.value
        }
      }
    }
  }

  /// Pick image from local file manager
  @override
  void pickImage() async {
    String path = await useCase.pickImage();
    if (path.isNotEmpty) {
      imagePathNewEdit = path;
      imageUpdateCubit.update();
    }
  }

  /// Get Status from string
  @override
  Status getStatusAddEdit() {
    if (newEditComboStatus == Status.active.name.tr()) {
      return Status.active;
    }
    //Inactive
    else {
      return Status.inactive;
    }
  }

  /// Generate random code to current product
  @override
  generateCode() {
    codeNewEditController.text = Random().nextInt(10000000).toString();
  }

  //! Saving and Printing Methods
  /// Save QR code in local files manager (Downloads folder)
  @override
  Future<void> saveCode(
          {required String codeText, required String nameFile}) async =>
      useCase.saveCode(codeText: codeText, nameFile: nameFile);

  /// Printing product data and save it in local files manager (Downloads folder)
  @override
  Future<void> printCode(Product product) async => useCase.printCode(product);

  //! Listeners Methods
  /// Remove all listeners that are running in background controllers
  @override
  void removeListeners() {
    originalPriceNewEditController.removeListener(() {});
    costsPriceNewEditController.removeListener(() {});
    profitNewEditController.removeListener(() {});
    qtyPackageNewEditController.removeListener(() {});
    newFinalPriceNewEditController.removeListener(() {});
    totalPriceNewEditController.removeListener(() {});
  }

  /// Dispose all text controllers
  @override
  void dispose() {
    nameFilterController.dispose();
    codeFilterController.dispose();
    skuFilterController.dispose();
    descriptionFilterController.dispose();
    qtyPackageFilterController.dispose();
    qtyUnitsFilterController.dispose();
    totalPackagesFilterController.dispose();
    paidTotalPackagesFilterController.dispose();
    greaterNewFinalPriceStartController.dispose();
    lessNewFinalPriceEndController.dispose();
    greaterNewFinalPackageStartController.dispose();
    lessNewFinalPackageEndController.dispose();
    nameNewEditController.dispose();
    codeNewEditController.dispose();
    skuNewEditController.dispose();
    descriptionNewEditController.dispose();
    weightNewEditController.dispose();
    originalPriceNewEditController.dispose();
    costsPriceNewEditController.dispose();
    profitNewEditController.dispose();
    oldFinalPriceNewEditController.dispose();
    newFinalPriceNewEditController.dispose();
    qtyPackageNewEditController.dispose();
    oldFinalPricePackageNewEditController.dispose();
    newFinalPricePackageNewEditController.dispose();
    totalPackagesNewEditController.dispose();
    paidTotalPackagesNewEditController.dispose();
    paidTotalUnitsNewEditController.dispose();
    totalPriceNewEditController.dispose();
    paidTotalPriceNewEditController.dispose();
  }

  /// Using listeners to change values of text controllers
  @override
  void addListeners() {
    //Final Unit Price
    originalPriceNewEditController.addListener(() {
      updateNewFinalPriceController();
    });
    costsPriceNewEditController.addListener(() {
      updateNewFinalPriceController();
    });
    profitNewEditController.addListener(() {
      updateNewFinalPriceController();
    });

    //Final Package Price
    qtyPackageNewEditController.addListener(() {
      updateNewFinalPackagePriceController();
    });
    newFinalPriceNewEditController.addListener(() {
      updateNewFinalPackagePriceController();
    });

    //Total Price
    totalPackagesNewEditController.addListener(() {
      updateTotalPriceController();
    });
    newFinalPricePackageNewEditController.addListener(() {
      updateTotalPriceController();
    });

    // totalPriceNewEditController.addListener(() {
    //   updateTotalPriceController();
    // });
  }

  //! Implementation of Listeners Methods
  /// Change value of unit price variable when original price , costs price and profit are changed
  @override
  void updateNewFinalPriceController() {
    final double? original =
        double.tryParse(originalPriceNewEditController.text);
    final double? costs = double.tryParse(costsPriceNewEditController.text);
    final double? profit = double.tryParse(profitNewEditController.text);
    if (original != null && costs != null && profit != null) {
      newFinalPriceNewEditController.text =
          (original + costs + profit).toString();
    } else {
      newFinalPriceNewEditController.text = '0.0';
    }
  }

  /// Change value of package price variable when units amount per package and unit price  are changed
  @override
  void updateNewFinalPackagePriceController() {
    final double? qtyPackage =
        double.tryParse(qtyPackageNewEditController.text);
    final double? newFinalPrice =
        double.tryParse(newFinalPriceNewEditController.text);
    if (qtyPackage != null && newFinalPrice != null) {
      newFinalPricePackageNewEditController.text =
          (newFinalPrice * qtyPackage).toString();
    } else {
      newFinalPricePackageNewEditController.text = '0';
    }
  }

  /// Change value of total price variable when packages amount , unit price and are changed
  @override
  void updateTotalPriceController() {
    final double? newFinalPackagePrice =
        double.tryParse(newFinalPricePackageNewEditController.text);
    final double? totalPackages =
        double.tryParse(totalPackagesNewEditController.text);
    if (newFinalPackagePrice != null && totalPackages != null) {
      totalPriceNewEditController.text =
          (newFinalPackagePrice * totalPackages).toString();
    } else {
      totalPriceNewEditController.text = '0';
    }
  }

  //! Navigation Methods
  /// Navigate to add new product screen
  @override
  navigateAddProduct() async {
    int? pageIndex = await useCase.navigateAddProduct(int.parse(pageNum));
    if (pageIndex != null) {
      imagePathNewEdit = '';
      newEditDate = null;
      newEditComboStatus = '';
      newEditStore = null;
      newEditBrand = null;

      nameNewEditController.clear();
      codeNewEditController.clear();
      skuNewEditController.clear();
      weightNewEditController.clear();
      originalPriceNewEditController.clear();
      costsPriceNewEditController.clear();
      profitNewEditController.clear();
      oldFinalPriceNewEditController.clear();
      newFinalPriceNewEditController.clear();
      qtyPackageFilterController.clear();
      oldFinalPricePackageNewEditController.clear();
      newFinalPricePackageNewEditController.clear();
      totalPackagesNewEditController.clear();
      paidTotalPackagesNewEditController.clear();
      paidTotalUnitsNewEditController.clear();
      totalPriceNewEditController.clear();
      paidTotalPriceNewEditController.clear();
      descriptionNewEditController.clear();

      pageNum = pageIndex.toString();
      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllProductsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the product screen
  @override
  navigateEditProduct(Product product) async {
    int? pageIndex =
        await useCase.navigateEditProduct(int.parse(pageNum), product);
    if (pageIndex != null) {
      imagePathNewEdit = '';
      newEditDate = null;
      newEditComboStatus = '';
      newEditStore = null;
      newEditBrand = null;

      nameNewEditController.clear();
      codeNewEditController.clear();
      skuNewEditController.clear();
      weightNewEditController.clear();
      originalPriceNewEditController.clear();
      costsPriceNewEditController.clear();
      profitNewEditController.clear();
      oldFinalPriceNewEditController.clear();
      newFinalPriceNewEditController.clear();
      qtyPackageNewEditController.clear();
      oldFinalPricePackageNewEditController.clear();
      newFinalPricePackageNewEditController.clear();
      totalPackagesNewEditController.clear();
      paidTotalPackagesNewEditController.clear();
      paidTotalUnitsNewEditController.clear();
      totalPriceNewEditController.clear();
      paidTotalPriceNewEditController.clear();
      descriptionNewEditController.clear();

      pageNum = pageIndex.toString();
      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllProductsStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  //! Excel Methods
  /// Export products data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

abstract class ProductViewModelBase {
  getAllProductsStorage(bool isRefresh);
  Future<bool> getAllStores();
  Future<bool> getAllBrands();
  editProductStorage();
  Future<void> addProductStorage();
  deleteProductStorage(int? id);

  navigateEditProduct(Product product);
  navigateAddProduct();

  Status getStatusAddEdit();
  void pickImage();
  void initEditProduct(String isEdit);
  Future<void> resetFilters();
  void updateShowColumns();
  Status? getStatus();
  generateCode();

  void addListeners();
  void dispose();
  void removeListeners();

  void updateTotalPriceController();
  void updateNewFinalPackagePriceController();
  void updateNewFinalPriceController();

  Future<void> printCode(Product product);
  Future<void> saveCode({required String codeText, required String nameFile});

  exportExcel(BuildContext context);
}

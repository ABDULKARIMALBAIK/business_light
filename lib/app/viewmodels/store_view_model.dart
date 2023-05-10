import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:injectable/injectable.dart';

import '../../domain/entity/status.dart';
import '../../domain/entity/store.dart';
import '../../domain/usecase/store_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class StoreViewModel extends StoreViewModelBase {
  StoreViewModel(@Named('StoreUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Store>();
    stater = BlocListCubit<Store>();
    loadMore = BlocStateBuilderCubit();
    groupFilterCubit = BlocStateBuilderCubit();

    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<material.PaginatedDataTableState>();

    //! Init Controllers
    nameFilterController = TextEditingController();
    codeFilterController = TextEditingController();
    nameNewEditController = TextEditingController();
    codeNewEditController = TextEditingController();
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

  //! Objects
  late BlocPaginationData<Store> dataSource;
  Store? editStore;

  //! Blocs
  late final BlocDataTableCubit<Store> brandDataTableCubit;
  late final BlocListCubit<Store> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterCubit;

  //! UseCase
  final StoreUseCase useCase;

  //! Controllers
  late final TextEditingController nameFilterController;
  late final TextEditingController codeFilterController;
  late final TextEditingController nameNewEditController;
  late final TextEditingController codeNewEditController;

  //! Storage Methods
  /// Get all stores from storage
  @override
  getAllStoresStorage(bool isRefresh) {
    useCase.getAllStoresStorage(
        filterIndexSort: sortIndex,
        filterName: nameFilterController.text,
        filterCode: codeFilterController.text,
        filterStatus: getStatus(),
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        desc: desc);
  }

  /// Delete the store from storage
  @override
  Future<void> deleteStoreStorage(int? id) async {
    await useCase.deleteStoreStorage(id);
    getAllStoresStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Edit the store on storage
  @override
  Future<void> editStoreStorage() async => useCase.editStoreStorage(
      editStore!.id,
      nameNewEditController.text,
      codeNewEditController.text,
      getStatusAddEdit());

  /// Add new store to storage
  @override
  Future<void> addStoreStorage() async => useCase.addStoreStorage(
      getStatusAddEdit(),
      nameNewEditController.text,
      codeNewEditController.text);

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

  /// Reset all parameters that are used for filtering
  @override
  Future<void> resetFilters() async {
    sortIndex = -1;
    sortContent = '';
    desc = false;
    statusFilter = '';
    nameFilterController.clear();
    codeFilterController.clear();
    groupFilterCubit.update();
  }

  /// Generate random code to current store
  @override
  generateCode() {
    codeNewEditController.text = Random().nextInt(10000000).toString();
  }

  /// Initial all parameters for add or edit screen
  @override
  void initEditStore(String isEdit) {
    if (isEdit == 'true') {
      newEditComboStatus = editStore!.status.name.tr();
      nameNewEditController.text = editStore!.name ?? '';
      codeNewEditController.text = editStore!.code ?? '';
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

  //! Navigation Methods
  /// Navigate to add new store screen
  @override
  navigateAddStore() async {
    int? pageIndex = await useCase.navigateAddStore(int.parse(pageNum));
    if (pageIndex != null) {
      newEditComboStatus = '';
      nameNewEditController.clear();
      codeNewEditController.clear();
      pageNum = pageIndex.toString();
      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllStoresStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the store screen
  @override
  navigateEditStore(Store store) async {
    int? pageIndex = await useCase.navigateEditStore(int.parse(pageNum), store);
    if (pageIndex != null) {
      newEditComboStatus = '';
      nameNewEditController.clear();
      codeNewEditController.clear();
      pageNum = pageIndex.toString();
      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllStoresStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  //! Excel Methods
  /// Export stores data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

abstract class StoreViewModelBase {
  getAllStoresStorage(bool isRefresh);
  deleteStoreStorage(int? id);
  editStoreStorage();
  addStoreStorage();

  Status? getStatus();
  Future<void> resetFilters();
  generateCode();
  void initEditStore(String isEdit);
  Status getStatusAddEdit();

  navigateAddStore();
  navigateEditStore(Store store);

  exportExcel(BuildContext context);
}

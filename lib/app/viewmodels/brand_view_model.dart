import 'package:business_light/app/bloc/bloc_list.dart';
import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_state_builder.dart';
import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/usecase/brand_use_case.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' show PaginatedDataTableState;
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/status.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class BrandViewModel extends BrandViewModelBase {
  BrandViewModel(@Named('BrandUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Brand>();
    stater = BlocListCubit<Brand>();
    loadMore = BlocStateBuilderCubit();
    statusFilterCubit = BlocStateBuilderCubit(value: '');
    groupFilterCubit = BlocStateBuilderCubit();

    //! Init Controller
    nameFilterController = TextEditingController();
    nameNewEditController = TextEditingController();

    //! Init Keys
    statusComboBoxKey = GlobalKey<FormFieldState>();
    sortComboBoxKey = GlobalKey<FormFieldState>();
    pageKey = GlobalKey<PaginatedDataTableState>();
  }

  //! Keys
  late GlobalKey<FormFieldState> statusComboBoxKey;
  late GlobalKey<FormFieldState> sortComboBoxKey;
  late GlobalKey<PaginatedDataTableState> pageKey;

  //! Variables
  String dataTableId = 'dataTableId';
  String pageNum = '0';
  int sortIndex = -1;
  String sortContent = '';
  bool desc = false;
  String newEditComboStatus = '';

  //! Objects
  late BlocPaginationData<Brand> dataSource;
  Brand? editBrand;

  //! Blocs
  late final BlocDataTableCubit<Brand> brandDataTableCubit;
  late final BlocListCubit<Brand> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit statusFilterCubit;
  // late final BlocStateBuilderCubit sortFilterCubit;
  late final BlocStateBuilderCubit groupFilterCubit;

  //! UseCase
  final BrandUseCase useCase;

  //! Controllers
  late final TextEditingController nameFilterController;
  late final TextEditingController nameNewEditController;

  //! Storage Methods
  /// Get all brands from storage
  @override
  getAllBrandsStorage(bool isRefresh) {
    useCase.getAllBrandsStorage(
        filterIndexSort: sortIndex,
        filterName: nameFilterController.text,
        filterStatus: getStatus(),
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        desc: desc);
  }

  /// Delete the brand from storage
  @override
  Future<void> deleteBrandStorage(int? id) async {
    await useCase.deleteBrandStorage(id);
    getAllBrandsStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Add new brand to storage
  @override
  Future<void> addBrandStorage() async =>
      useCase.addBrandStorage(getStatusAddEdit(), nameNewEditController.text);

  /// Edit the brand on storage
  @override
  Future<void> editBrandStorage() async => useCase.editBrandStorage(
      editBrand!.id, nameNewEditController.text, getStatusAddEdit());

  //! Operations Methods
  /// Reset all parameters that are used for filtering
  @override
  Future<void> resetFilters() async {
    sortIndex = -1;
    sortContent = '';
    desc = false;

    statusFilterCubit.changeValue(false, '');
    nameFilterController.clear();

    groupFilterCubit.update();
  }

  /// Get status type from string
  @override
  Status? getStatus() {
    String currentStatus = statusFilterCubit.getValue;
    if (currentStatus == Status.active.name.tr()) {
      return Status.active;
    } else if (currentStatus == Status.inactive.name.tr()) {
      return Status.inactive;
    } else {
      return null;
    }
  }

  /// Edit the brand to storage
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

  /// Initial all parameters for add or edit screen
  @override
  void initEditBrand(String isEdit) {
    if (isEdit == 'true') {
      newEditComboStatus = editBrand!.status.name.tr();
      nameNewEditController.text = editBrand!.name ?? '';
    }
  }

  //! Excel Methods
  /// Export brands data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

/// Declare all behaviors that will be used in the ViewModel
abstract class BrandViewModelBase {
  getAllBrandsStorage(bool isRefresh);
  Future<void> deleteBrandStorage(int? id);
  Future<void> addBrandStorage();
  Future<void> editBrandStorage();

  Future<void> resetFilters();
  Status? getStatus();
  Status getStatusAddEdit();

  void initEditBrand(String isEdit);
  exportExcel(BuildContext context);
}

import 'dart:developer';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:injectable/injectable.dart';

import '../../domain/entity/company.dart';
import '../../domain/usecase/company_use_case.dart';
import '../bloc/bloc_list.dart';
import '../bloc/bloc_pagination_datatable.dart';
import '../bloc/bloc_state_builder.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class CompanyViewModel extends CompanyViewModelBase {
  CompanyViewModel(@Named('CompanyUseCase') this.useCase) {
    //! Init Blocs
    brandDataTableCubit = BlocDataTableCubit<Company>();
    stater = BlocListCubit<Company>();
    loadMore = BlocStateBuilderCubit();
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
    addressFilterController = TextEditingController();
    descriptionFilterController = TextEditingController();
    countryFilterController = TextEditingController();

    nameNewEditController = TextEditingController();
    emailNewEditController = TextEditingController();
    phoneNewEditController = TextEditingController();
    addressNewEditController = TextEditingController();
    countryNewEditController = TextEditingController();
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
  String newEditImage = '';

  //! Objects
  late BlocPaginationData<Company> dataSource;
  Company? editCompany;

  //! Blocs
  late final BlocDataTableCubit<Company> brandDataTableCubit;
  late final BlocListCubit<Company> stater;
  late final BlocStateBuilderCubit loadMore;
  late final BlocStateBuilderCubit groupFilterCubit;
  late final BlocStateBuilderCubit imageUpdateCubit;

  //! UseCase
  final CompanyUseCase useCase;

  //! Controllers
  late final TextEditingController nameFilterController;
  late final TextEditingController emailFilterController;
  late final TextEditingController phoneFilterController;
  late final TextEditingController addressFilterController;
  late final TextEditingController countryFilterController;
  late final TextEditingController descriptionFilterController;

  late final TextEditingController nameNewEditController;
  late final TextEditingController emailNewEditController;
  late final TextEditingController phoneNewEditController;
  late final TextEditingController addressNewEditController;
  late final TextEditingController countryNewEditController;
  late final TextEditingController descriptionNewEditController;

  //! Storage Methods
  /// Get all companies from storage
  @override
  getAllCompaniesStorage(bool isRefresh) {
    useCase.getAllCompaniesStorage(
        filterIndexSort: sortIndex,
        filterName: nameFilterController.text,
        filterEmail: emailFilterController.text,
        filterPhone: phoneFilterController.text,
        filterAddress: addressFilterController.text,
        filterBio: descriptionFilterController.text,
        filterCountry: countryFilterController.text,
        stater: stater,
        cubit: brandDataTableCubit,
        isRefresh: isRefresh,
        desc: desc);
  }

  /// Delete the company from storage
  @override
  deleteCompanyStorage(int id) async {
    await useCase.deleteCompanyStorage(id);
    getAllCompaniesStorage(brandDataTableCubit.data.isEmpty ? false : true);
  }

  /// Add new company to storage
  @override
  addCompanyStorage() async => useCase.addCompanyStorage(
      name: nameNewEditController.text,
      email: emailNewEditController.text,
      phone: phoneNewEditController.text,
      address: addressNewEditController.text,
      bio: descriptionNewEditController.text,
      country: countryNewEditController.text,
      imagePath: newEditImage);

  /// Edit the company on storage
  @override
  editCompanyStorage() => useCase.editCompanyStorage(
      id: editCompany!.id,
      name: nameNewEditController.text,
      email: emailNewEditController.text,
      phone: phoneNewEditController.text,
      address: addressNewEditController.text,
      bio: descriptionNewEditController.text,
      country: countryNewEditController.text,
      imagePath: newEditImage);

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
    addressFilterController.clear();
    countryFilterController.clear();
    descriptionFilterController.clear();

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
  void initEditCompany(String isEdit) {
    if (isEdit == 'true') {
      if (editCompany != null) {
        nameNewEditController.text = editCompany!.name ?? '';
        phoneNewEditController.text = editCompany!.phone ?? '';
        emailNewEditController.text = editCompany!.email ?? '';
        addressNewEditController.text = editCompany!.address ?? '';
        descriptionNewEditController.text = editCompany!.bio ?? '';
        countryFilterController.text = editCompany!.country ?? '';

        newEditImage = editCompany!.imagePath ?? '';
      }
    }
  }

  //! Navigation Methods
  /// Navigate to add new company screen
  @override
  navigateAddCompany() async {
    int? pageIndex = await useCase.navigateAddCompany(int.parse(pageNum));
    if (pageIndex != null) {
      newEditImage = '';
      nameNewEditController.clear();
      phoneNewEditController.clear();
      emailNewEditController.clear();
      addressNewEditController.clear();
      descriptionNewEditController.clear();
      countryFilterController.clear();
      pageNum = pageIndex.toString();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllCompaniesStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  /// Navigate to edit the company screen
  @override
  navigateEditCompany(Company company) async {
    int? pageIndex =
        await useCase.navigateEditCompany(int.parse(pageNum), company);
    if (pageIndex != null) {
      newEditImage = '';
      nameNewEditController.clear();
      phoneNewEditController.clear();
      emailNewEditController.clear();
      addressNewEditController.clear();
      descriptionNewEditController.clear();
      countryFilterController.clear();
      pageNum = pageIndex.toString();

      Future.delayed(const Duration(milliseconds: 400)).then((value) =>
          getAllCompaniesStorage(
              stater.getType() == BlocListType.noData ? false : true));
    }
  }

  //! Excel Methods
  /// Export companies data as excel file
  @override
  exportExcel(BuildContext context) =>
      useCase.exportDataExcel(context, brandDataTableCubit.data);
}

/// Declare all behaviors that will be used in the ViewModel
abstract class CompanyViewModelBase {
  getAllCompaniesStorage(bool isRefresh);
  deleteCompanyStorage(int id);
  addCompanyStorage();
  editCompanyStorage();

  Future<void> resetFilters();
  void pickImage();
  void initEditCompany(String isEdit);

  navigateAddCompany();
  navigateEditCompany(Company company);

  exportExcel(BuildContext context);
}

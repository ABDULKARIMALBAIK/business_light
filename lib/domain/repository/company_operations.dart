import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/company.dart';

///Declare all operations to Company screen (Data and operations)
abstract class CompanyOperations {
  getAllCompaniesStorage(
      {required BlocListCubit<Company> stater,
      required BlocDataTableCubit<Company> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterAddress,
      String? filterCountry,
      String? filterBio,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteCompanyStorage(int? id);
  Future<void> addCompanyStorage({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String imagePath,
    required String country,
    required String bio,
  });
  Future<void> editCompanyStorage(
      {required int? id,
      required String name,
      required String email,
      required String phone,
      required String address,
      required String imagePath,
      required String country,
      required String bio});

  getAllCompaniesRemote();
  deleteCompanyRemote();
  addCompanyRemote();
  editCompanyRemote();

  Future<int?> navigateAddCompany(int pageIndex);
  Future<int?> navigateEditCompany(int pageIndex, Company company);

  Future<String> pickImage();

  checkPermissionExportExcel(BuildContext context, List<Company> companies);
  exportDataExcel(BuildContext context, List<Company> companies);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

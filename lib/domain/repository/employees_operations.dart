import 'package:business_light/domain/entity/user.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/payout.dart';

///Declare all operations to Employees screen (Data and operations)
abstract class EmployeesOperations {
  getAllEmployeesStorage(
      {required BlocListCubit<User> stater,
      required BlocDataTableCubit<User> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      UserLevel? filterLevel,
      String? filterGreaterSalary,
      String? filterLowerSalary,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteEmployeeStorage(int? id);
  Future<void> addEmployeeStorage({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String salary,
    required String jobDescription,
    required String imagePath,
    required UserLevel level,
  });
  Future<void> editEmployeeStorage({
    int? id,
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String salary,
    required String jobDescription,
    required String imagePath,
    required UserLevel level,
  });

  getAllPayoutsStorage(
      {required BlocListCubit<Payout> stater,
      required BlocDataTableCubit<Payout> cubit,
      required bool isRefresh,
      User? userDetails,
      double? filterPrice,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePayoutStorage(int? id);

  getAllEmployeesRemote();
  deleteEmployeeRemote();
  addEmployeeRemote();
  editEmployeeRemote();
  getAllPayoutsRemote();
  deletePayoutRemote();

  Future<int?> navigateAddEmployee(int pageIndex);
  Future<int?> navigateEditEmployee(int pageIndex, User user);
  Future<int?> navigateEditPayout(int pageIndex, Payout payout);
  navigateEmployeeDetails(User employee);

  Future<String> pickImage();

  checkPermissionExportExcel(BuildContext context, List<User> employees);
  exportDataExcel(BuildContext context, List<User> employees);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

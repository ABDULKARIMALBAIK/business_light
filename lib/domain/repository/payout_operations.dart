import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/payout.dart';
import '../entity/user.dart';

///Declare all operations to Payout screen (Data and operations)
abstract class PayoutOperations {
  getAllPayoutsStorage(
      {required BlocListCubit<Payout> stater,
      required BlocDataTableCubit<Payout> cubit,
      required bool isRefresh,
      String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PayoutType? payoutType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePayoutStorage(int? id);
  Future<void> addPayoutStorage(
      {required String code,
      required double price,
      required String description,
      required PayoutType payoutType,
      required User? selectedEmployeeSalary,
      required DateTime date});
  Future<void> editPayoutStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PayoutType payoutType,
      required DateTime date});
  Future<List<User>> loadAllEmployeesStorage();

  getAllPayoutsRemote();
  deletePayoutRemote();
  addPayoutRemote();
  editPayoutRemote();
  loadAllEmployeesRemote();

  Future<int?> navigateAddPayout(int pageIndex);
  Future<int?> navigateEditPayout(int pageIndex, Payout payout);

  checkPermissionExportExcel(BuildContext context, List<Payout> payouts);
  exportDataExcel(BuildContext context, List<Payout> payouts);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

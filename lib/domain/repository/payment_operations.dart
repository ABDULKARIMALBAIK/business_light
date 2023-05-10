import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/order.dart';
import '../entity/payment.dart';

///Declare all operations to Payment screen (Data and operations)
abstract class PaymentOperations {
  getAllPaymentsStorage(
      {required BlocListCubit<Payment> stater,
      required BlocDataTableCubit<Payment> cubit,
      required bool isRefresh,
      String? filterCode,
      double? filterPrice,
      String? filterDescription,
      PaymentType? paymentType,
      DateTime? startDate,
      DateTime? endDate,
      int? filterIndexSort,
      bool? desc});

  Future<void> deletePaymentStorage(int? id);
  Future<void> addPaymentStorage(
      {required String code,
      required double price,
      required String description,
      required PaymentType paymentType,
      required DateTime date,
      Order? selectedOrder});
  Future<void> editPaymentStorage(
      {required int? id,
      required String code,
      required double price,
      required String description,
      required PaymentType paymentType,
      required DateTime date});

  Future<List<Order>> loadAllOrdersStorage();

  getAllPaymentsRemote();
  deletePaymentRemote();
  addPaymentRemote();
  editPaymentRemote();
  loadAllOrdersRemote();

  Future<int?> navigateAddPayment(int pageIndex);
  Future<int?> navigateEditPayment(int pageIndex, Payment payment);

  checkPermissionExportExcel(BuildContext context, List<Payment> payments);
  exportDataExcel(BuildContext context, List<Payment> payments);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

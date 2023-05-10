import 'package:business_light/domain/entity/user.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/order.dart';
import '../entity/payment.dart';

///Declare all operations to Customer screen (Data and operations)
abstract class CustomerOperations {
  getAllCustomersStorage(
      {required BlocListCubit<User> stater,
      required BlocDataTableCubit<User> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterEmail,
      String? filterPhone,
      String? filterJobDescription,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteCustomerStorage(int? id);
  Future<void> addCustomerStorage(
      {required String fullName,
      required String email,
      required String password,
      required String phone,
      required String jobDescription,
      required String imagePath});
  Future<void> editCustomerStorage(
      {int? id,
      required String fullName,
      required String email,
      required String password,
      required String phone,
      required String jobDescription,
      required String imagePath});

  Future<void> getAllCustomerOrdersStorage({
    required User customer,
    required BlocListCubit<Order> stater,
    required BlocDataTableCubit<Order> cubit,
    required bool isRefresh,
  });

  Future<void> getAllCustomerPaymentsStorage({
    required User customer,
    required BlocListCubit<Payment> stater,
    required BlocDataTableCubit<Payment> cubit,
    required bool isRefresh,
  });

  getAllCustomersRemote();
  deleteCustomerRemote();
  addCustomerRemote();
  editCustomerRemote();
  getAllCustomerOrdersRemote();
  getAllCustomerPaymentsRemote();

  Future<int?> navigateAddCustomer(int pageIndex);
  Future<int?> navigateEditCustomer(int pageIndex, User user);
  navigateCustomerDetails(User customer);

  Future<String> pickImage();
  saveCode({required String codeText, required String nameFile});
  printCode(Order order);

  checkPermissionExportExcel(BuildContext context, List<User> customers);
  exportDataExcel(BuildContext context, List<User> customers);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

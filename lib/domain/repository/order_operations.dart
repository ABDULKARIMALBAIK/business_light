import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/order.dart';
import '../entity/payment.dart';
import '../entity/product.dart';
import '../entity/product_order.dart';
import '../entity/user.dart';

///Declare all operations to Order screen (Data and operations)
abstract class OrderOperations {
  getAllOrdersStorage(
      {required BlocListCubit<Order> stater,
      required BlocDataTableCubit<Order> cubit,
      required bool isRefresh,
      String? codeFilterController,
      double? greaterTotalPriceFilterController,
      double? lessTotalPriceFilterController,
      double? greaterPricePiecesFilterController,
      double? lessPricePiecesFilterController,
      double? greaterFinalPriceFilterController,
      double? lessFinalPriceFilterController,
      String? descriptionFilterController,
      DateTime? selectedStartDate,
      DateTime? selectedEndDate,
      TypeOrder? typeFilter,
      User? filterCustomer,
      int? filterIndexSort,
      bool? desc});

  Future<List<User>> getAllCustomersStorage();
  Future<List<Product>> getAllProductsStorage();

  Future<void> deleteOrderStorage(int? id);
  Future<void> addOrderStorage(
      {String? code,
      int? totalQty,
      int? qtyPieces,
      double? totalPrice,
      double? chargeCost,
      double? otherCost,
      double? balancer,
      double? discount,
      DateTime? date,
      double? finalPrice,
      String? description,
      User? selectedCustomer,
      required List<Payment> payments,
      required List<ProductOrder> productsOrder,
      TypeOrder? orderType});

  getAllOrdersRemote();
  deleteOrderRemote();
  addOrderRemote();
  getAllCustomersRemote();
  getAllProductsRemote();

  Future<int?> navigateAddOrder(int pageIndex);

  checkPermissionExportExcel(BuildContext context, List<Order> orders);
  exportDataExcel(BuildContext context, List<Order> orders);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);

  printCode(Order order);
  saveCode({required String codeText, required String nameFile});
}

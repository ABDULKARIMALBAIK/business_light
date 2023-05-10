import 'package:business_light/domain/entity/store.dart';
import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/status.dart';

///Declare all operations to Store screen (Data and operations)
abstract class StoreOperations {
  getAllStoresStorage(
      {required BlocListCubit<Store> stater,
      required BlocDataTableCubit<Store> cubit,
      required bool isRefresh,
      String? filterName,
      String? filterCode,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteStoreStorage(int? id);
  Future<void> addStoreStorage(Status status, String name, String code);
  Future<void> editStoreStorage(
      int? id, String name, String code, Status statusAddEdit);

  getAllStoresRemote();
  deleteStoreRemote();
  addStoreRemote();
  editStoreRemote();

  Future<int?> navigateAddStore(int pageIndex);
  Future<int?> navigateEditStore(int pageIndex, Store store);

  checkPermissionExportExcel(BuildContext context, List<Store> stores);
  exportDataExcel(BuildContext context, List<Store> stores);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

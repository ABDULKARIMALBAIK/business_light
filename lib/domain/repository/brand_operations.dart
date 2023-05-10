import 'package:excel/excel.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../app/bloc/bloc_list.dart';
import '../../app/bloc/bloc_pagination_datatable.dart';
import '../entity/brand.dart';
import '../entity/status.dart';

///Declare all operations to brand screen (Data and operations)
abstract class BrandOperations {
  getAllBrandsStorage(
      {required BlocListCubit<Brand> stater,
      required BlocDataTableCubit<Brand> cubit,
      required bool isRefresh,
      String? filterName,
      Status? filterStatus,
      int? filterIndexSort,
      bool? desc});

  Future<void> deleteBrandStorage(int? id);
  Future<void> addBrandStorage(Status status, String name);
  Future<void> editBrandStorage(int? id, String name, Status statusAddEdit);

  getAllBrandsRemote();
  deleteBrandRemote();
  addBrandRemote();
  editBrandRemote();

  checkPermissionExportExcel(BuildContext context, List<Brand> brands);
  exportDataExcel(BuildContext context, List<Brand> brands);
  saveExcelFile(BuildContext context, String sheetName, Excel excel);
}

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/* #region Bloc */
@immutable
//ignore: must_be_immutable
abstract class AbstractBlocDataTable<T> extends Equatable {
  List<T> dataList = [];
  bool sortAscending = true;
  int sortColumnIndex = 1;
  int rowsPerPage = 10;

  AbstractBlocDataTable(this.dataList, this.sortAscending, this.sortColumnIndex,
      this.rowsPerPage);
}

//ignore: must_be_immutable
class BlocDataTable<T> extends AbstractBlocDataTable<T> {
  BlocDataTable(
      {required List<T> dataList,
      required bool sortAscending,
      required int sortColumnIndex,
      required int rowsPerPage})
      : super(dataList, sortAscending, sortColumnIndex, rowsPerPage);

  @override
  List<Object?> get props =>
      [dataList, sortAscending, sortColumnIndex, rowsPerPage];
}

class BlocDataTableCubit<T> extends Cubit<BlocDataTable<T>> {
  BlocDataTableCubit(
      {List<T>? list,
      bool sortAscending = false,
      int sortColumnIndex = 1,
      int rowsPerPage = 10})
      : super(BlocDataTable(
            dataList: list ??= [],
            sortAscending: sortAscending,
            sortColumnIndex: sortColumnIndex,
            rowsPerPage: rowsPerPage));

  void update() => emit(state);

  /* #region Getter */
  List<T> get data => state.dataList;
  bool get asc => state.sortAscending;
  int get sortColumnIndex => state.sortColumnIndex;
  int get rowsPerPage => state.rowsPerPage;
  /* #endregion */

  /* #region Setter */
  set setData(List<T> newData) => state.dataList = newData;
  set setAsc(bool value) => state.sortAscending = value;
  set setSortColumnIndex(int index) => state.sortColumnIndex = index;
  set setRowsPerPage(int num) => state.rowsPerPage = num;
  /* #endregion */
}

/* #endregion */

/* #region Data Table */

// ignore: must_be_immutable
class BlocPaginationDataTable<T> extends StatelessWidget {
  BlocPaginationDataTable({
    super.key,
    required this.bloc,
    required this.cellsPerRow,
    required this.currentPage,
    required this.pageKey,
    required this.columnsData,
    required this.header,
    // required this.scrollController,
    // required this.onRowChanged,
    this.actions,
  }) {
    paginationData = BlocPaginationData(bloc: bloc, cellsPerRow: cellsPerRow);
  }
  final BlocDataTableCubit<T> bloc;
  final List<DataColumnsSorter> columnsData;
  Widget? header;
  List<Widget>? actions;

  // Function onRowChanged;
  List<DataCell> Function(dynamic object) cellsPerRow;
  void Function(int currentPage) currentPage;
  late BlocPaginationData<T> paginationData;
  GlobalKey<PaginatedDataTableState> pageKey;
  // final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocProvider<BlocDataTableCubit>.value(
        value: bloc,
        child: BlocBuilder<BlocDataTableCubit, BlocDataTable>(
            buildWhen: (oldState, newState) => true,
            builder: (context, state) {
              return PaginatedDataTable(
                  // controller: scrollController,
                  // key: pageKey,
                  source: paginationData,
                  header: header,
                  columns: dataColumns(),
                  actions: actions ?? [],
                  columnSpacing: (MediaQuery.of(context).size.width /
                                  columnsData.length -
                              30) <
                          80
                      ? 80
                      : MediaQuery.of(context).size.width / columnsData.length -
                          30,
                  horizontalMargin: 24,
                  sortColumnIndex: bloc.sortColumnIndex,
                  sortAscending: bloc.asc,
                  showCheckboxColumn: false,
                  showFirstLastButtons: true,
                  onPageChanged: (index) {
                    bloc.setRowsPerPage = index;
                    currentPage(index);
                  },
                  rowsPerPage: 10);
            }),
      ),
    );
  }

  List<DataColumn> dataColumns() {
    return List.generate(
      columnsData.length,
      (index) {
        DataColumnsSorter sorter = columnsData[index];
        return DataColumn(
          label: Text(sorter.columnName),
          // tooltip: sorter.columnName,
          numeric: sorter.isNumeric,
          // onSort: (colIndex, asc) {
          //   _sort<num>(sorter.onSort!, colIndex, asc, paginationData, bloc);
          // }
        );
      },
    );
  }

  // void _sort<X>(
  //   Comparable<X> Function(T d) getField,
  //   int colIndex,
  //   bool asc,
  //   BlocPaginationData paginationData,
  //   BlocDataTableCubit bloc,
  // ) {
  //   paginationData.sort<X>(getField, asc);
  //   bloc.setAsc = asc;
  //   bloc.setSortColumnIndex = colIndex;
  // }
}

class BlocPaginationData<T> extends DataTableSource {
  BlocPaginationData({required this.bloc, required this.cellsPerRow});

  BlocDataTableCubit bloc;
  final List<DataCell> Function(T obj) cellsPerRow;

  // void sort<S>(Comparable<S> Function(T d) getField, bool asc) {
  //   bloc.data.sort((a, b) {
  //     final aValue = getField(a);
  //     final bValue = getField(b);
  //     return asc
  //         ? Comparable.compare(aValue, bValue)
  //         : Comparable.compare(bValue, aValue);
  //   });

  //   notifyListeners();
  // }

  @override
  DataRow? getRow(int index) {
    T dataObject = bloc.data[index] as T;
    return DataRow.byIndex(
      index: index,
      cells: cellsPerRow.call(dataObject),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => bloc.data.length;

  @override
  int get selectedRowCount => 0;
}

/* #endregion */

/* #region Column Model */
class DataColumnsSorter<T, R> {
  DataColumnsSorter(
      {required this.isNumeric,
      required this.type,
      required this.columnName,
      this.onSort});
  bool isNumeric;
  dynamic type;
  String columnName;
  Comparable<R> Function(T)? onSort; //Comparable<S>
}
/* #endregion */

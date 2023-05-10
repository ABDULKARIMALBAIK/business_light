import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import '../../../domain/entity/status.dart';
import '../../../domain/entity/store.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../bloc/bloc_state_builder.dart';
import '../../viewmodels/store_view_model.dart';

// ignore: must_be_immutable
class StorePage extends StatefulWidget {
  StorePage({super.key});

  @override
  State<StatefulWidget> createState() => _StorePageState();

  // Sort items list
  List<String> sortComboBox = [
    'id'.tr(),
    'name'.tr(),
    'code'.tr(),
    'status'.tr()
  ];

  // Status types list
  List<String> statusComboBox = [
    Status.active.name.tr(),
    Status.inactive.name.tr()
  ];
}

class _StorePageState extends State<StorePage> {
  late StoreViewModel viewModel;

  @override
  void initState() {
    viewModel = getItClient.get<StoreViewModel>();
    viewModel.getAllStoresStorage(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynMouseScroll(
        builder: (context, scrollController, physics) => ScrollConfiguration(
              behavior: const FluentScrollBehavior(),
              child: ScaffoldPage.scrollable(
                scrollController: scrollController,
                ////////////// * Header * /////////////
                header: header(context),
                children: [
                  ////////////// * Filters & Sorting * /////////////
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: BlocStateBuilder(
                        cubit: viewModel.groupFilterCubit,
                        builder: (context, state) {
                          return Wrap(
                            direction: Axis.horizontal,
                            spacing: 15,
                            runSpacing: 15,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ////////////// * Filter Button * /////////////
                              filterButton(context),
                              ////////////// * Reset Button * /////////////
                              resetButton(context),
                              ////////////// * Filter Name * /////////////
                              name(context),
                              ////////////// * Filter Code * /////////////
                              code(context),
                              ////////////// * Filter Status * /////////////
                              statusFilter(context),
                              ////////////// * Sorters * /////////////
                              sorter(context),
                              ////////////// * Checkbox Desc * /////////////
                              checkDesc(context),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ////////////// * Data Table * /////////////
                  dataTableWidget(context),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ));
  }

  //! Store DataTable Widgets
  BlocPaginationDataTable<Store> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Store> dataTable =
        BlocPaginationDataTable<Store>(
      bloc: viewModel.brandDataTableCubit,
      cellsPerRow: (obj) => _cellsPerRow(context, obj),
      columnsData: _columnData(),
      header: headerDataTable(context),
      actions: actions(context),
      pageKey: viewModel.pageKey,
      // scrollController: viewModel.scrollController,
      currentPage: (pageNum) {
        viewModel.pageNum = pageNum.toString();
      },
      // onRowChanged: onRowChanged
    );
    viewModel.dataSource = dataTable.paginationData;
    return dataTable;
  }

  List<Widget>? actions(BuildContext context) {
    return [
      Tooltip(
        displayHorizontally: false,
        message: 'refresh'.tr(),
        enableFeedback: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: IconButton(
            iconButtonMode: IconButtonMode.large,
            icon: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(
                FluentIcons.refresh,
                size: 20,
              ),
            ),
            onPressed: () {
              viewModel.getAllStoresStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  List<material.DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    Store? store = obj as Store?;

    return [
      material.DataCell(
        SelectableText(store!.id.toString()),
      ),
      material.DataCell(
        SelectableText(store.name ?? ''),
      ),
      material.DataCell(
        SelectableText(store.code ?? ''),
      ),
      material.DataCell(
        SelectableText(store.status.name.tr(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: (store.status.name.tr() == Status.active.name.tr())
                    ? DataHelper.isDark()
                        ? FluentColors.green.toAccentColor().lighter
                        : FluentColors.green.toAccentColor().darker
                    : DataHelper.isDark()
                        ? FluentColors.red.toAccentColor().lighter
                        : FluentColors.red.toAccentColor().darker)),
      ),
      // ignore: prefer_inlined_adds
    ]..add(material.DataCell(Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        children: [
          Tooltip(
            displayHorizontally: false,
            message: 'edit'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(
                      FluentTheme.of(context).scaffoldBackgroundColor),
                ),
                icon: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    FluentIcons.edit,
                    size: 15,
                    color: DataHelper.getCurrentColor(),
                  ),
                ),
                onPressed: () async {
                  viewModel.navigateEditStore(store);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          Tooltip(
            displayHorizontally: false,
            message: 'delete'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                style: ButtonStyle(
                  backgroundColor: ButtonState.all(
                      FluentTheme.of(context).scaffoldBackgroundColor),
                ),
                icon: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    FluentIcons.delete,
                    size: 15,
                    color: DataHelper.isDark()
                        ? FluentColors.red.toAccentColor().lighter
                        : FluentColors.red.toAccentColor().darker,
                  ),
                ),
                onPressed: () async {
                  await viewModel.deleteStoreStorage(store.id);

                  // ignore: use_build_context_synchronously
                  CustomInfoBar.showDefault(
                      context: context,
                      title: 'brand_infoBar_delete_success'.tr(),
                      severity: InfoBarSeverity.success);
                },
              ),
            ),
          ),
        ],
      )));
  }

  List<DataColumnsSorter<Store, dynamic>> _columnData() {
    return [
      DataColumnsSorter<Store, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (store) => store.id ?? 0,
          type: 0),
      DataColumnsSorter<Store, String>(
          columnName: 'name'.tr(),
          isNumeric: false,
          onSort: (store) => store.name ?? '',
          type: ''),
      DataColumnsSorter<Store, String>(
          columnName: 'code'.tr(),
          isNumeric: false,
          onSort: (store) => store.code ?? '',
          type: ''),
      DataColumnsSorter<Store, dynamic>(
          columnName: 'status'.tr(),
          isNumeric: false,
          onSort: null,
          type: Status.inactive),
      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<Store, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  Widget headerDataTable(BuildContext context) {
    return Text(
      'store_title'.tr(),
      style: FluentTheme.of(context)
          .typography
          .caption!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  //! Build Widgets
  Widget header(BuildContext context) {
    return PageHeader(
      title: Text('store_header'.tr()),
      commandBar: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ////////////// * Export Excel * /////////////
        SizedBox(
          width: 170,
          child: FilledButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('export_excel'.tr()),
              ),
              onPressed: () => viewModel.exportExcel(context)),
        ),
        const SizedBox(
          width: 15,
        ),
        ////////////// * Add Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: 'store_tooltip_add_store'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: IconButton(
                iconButtonMode: IconButtonMode.large,
                style: ButtonStyle(
                  backgroundColor:
                      ButtonState.all(FluentTheme.of(context).cardColor),
                ),
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    FluentIcons.add,
                    size: 22,
                    color: DataHelper.getCurrentColor(),
                  ),
                ),
                onPressed: () async {
                  viewModel.navigateAddStore();
                },
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget filterButton(BuildContext context) {
    return Tooltip(
      displayHorizontally: false,
      message: 'start_filtering'.tr(),
      enableFeedback: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          iconButtonMode: IconButtonMode.large,
          style: ButtonStyle(
            backgroundColor: ButtonState.all(FluentTheme.of(context).cardColor),
          ),
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              FluentIcons.filter,
              size: 20,
              color: DataHelper.getCurrentColor(),
            ),
          ),
          onPressed: () {
            viewModel.getAllStoresStorage(false);
          },
        ),
      ),
    );
  }

  Widget resetButton(BuildContext context) {
    return Tooltip(
      displayHorizontally: false,
      message: 'reset'.tr(),
      enableFeedback: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          iconButtonMode: IconButtonMode.large,
          style: ButtonStyle(
            backgroundColor: ButtonState.all(FluentTheme.of(context).cardColor),
          ),
          icon: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              FluentIcons.reset,
              size: 20,
              color: DataHelper.getCurrentColor(),
            ),
          ),
          onPressed: () async {
            await viewModel.resetFilters();
          },
        ),
      ),
    );
  }

  Widget name(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.nameFilterController,
        placeholder: 'store_textBox_name_placeHolder'.tr(),
        expands: false,
      ),
    );
  }

  Widget code(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.codeFilterController,
        placeholder: 'store_textBox_code_placeHolder'.tr(),
        expands: false,
      ),
    );
  }

  Widget statusFilter(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('status'.tr()),
          value: viewModel.statusFilter.isEmpty ? null : viewModel.statusFilter,
          items:
              widget.statusComboBox.map<ComboBoxItem<String>>((String status) {
            return ComboBoxItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? status) {
            if (status != null) {
              viewModel.statusFilter = status;
              state(() {});
            }
          });
    });
  }

  Widget sorter(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('sort'.tr()),
          value: viewModel.sortContent.isEmpty ? null : viewModel.sortContent,
          items: widget.sortComboBox.map<ComboBoxItem<String>>((String sort) {
            return ComboBoxItem<String>(value: sort, child: Text(sort));
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? sort) {
            if (sort == 'id'.tr()) {
              viewModel.sortContent = 'id'.tr();
              viewModel.sortIndex = 0;
            } else if (sort == 'name'.tr()) {
              viewModel.sortContent = 'name'.tr();
              viewModel.sortIndex = 1;
            } else if (sort == 'code'.tr()) {
              viewModel.sortContent = 'code'.tr();
              viewModel.sortIndex = 2;
            }
            //'status'.tr()
            else {
              viewModel.sortContent = 'status'.tr();
              viewModel.sortIndex = 3;
            }
            state(() {});
          });
    });
  }

  Widget checkDesc(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return Tooltip(
          displayHorizontally: false,
          message: 'desc'.tr(),
          enableFeedback: true,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Checkbox(
              checked: viewModel.desc,
              onChanged: (value) {
                viewModel.desc = !viewModel.desc;
                state(() {});
              },
            ),
          ),
        );
      },
    );
  }

  Widget dataTableWidget(BuildContext context) {
    return Center(
      child: BlocList<Store>(
          id: viewModel.dataTableId,
          isPagination: false,
          isRemoteData: false,
          cubit: viewModel.stater,
          loadMoreCubit: viewModel.loadMore,
          onRetryFunction: () {
            viewModel.getAllStoresStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return dataTable(context);
          }),
    );
  }
}

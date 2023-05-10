import 'package:business_light/app/bloc/bloc_pagination_datatable.dart';
import 'package:business_light/app/bloc/bloc_state_builder.dart';
import 'package:business_light/app/viewmodels/brand_view_model.dart';
import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/services/di/injection.dart';
import 'package:business_light/utils/app_color.dart';
import 'package:business_light/utils/constants.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter/material.dart' as page_key;
// ignore: implementation_imports
import 'package:flutter/src/material/data_table.dart';

import '../../../domain/entity/status.dart';
import '../../../services/router/router_generator.dart';
import '../../../services/router/routers.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';

// ignore: must_be_immutable
class BrandPage extends StatefulWidget {
  const BrandPage({super.key});

  @override
  State<StatefulWidget> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  late BrandViewModel viewModel;

  @override
  void initState() {
    viewModel = getItClient.get<BrandViewModel>();
    viewModel.getAllBrandsStorage(false);
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
                        ////////////// * Filter Status * /////////////
                        status(context),
                        ////////////// * Sorters * /////////////
                        sorter(context),
                        ////////////// * Checkbox Desc * /////////////
                        checkDesc(context)
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
      ),
    );
  }

  //! Brand DataTable Widgets
  List<DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    Brand? brand = obj as Brand?;

    return [
      DataCell(
        SelectableText(brand!.id.toString()),
      ),
      DataCell(
        SelectableText(brand.name ?? ''),
      ),
      DataCell(
        SelectableText(brand.status.name.tr(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: (brand.status.name.tr() == Status.active.name.tr())
                    ? DataHelper.isDark()
                        ? FluentColors.green.toAccentColor().lighter
                        : FluentColors.green.toAccentColor().darker
                    : DataHelper.isDark()
                        ? FluentColors.red.toAccentColor().lighter
                        : FluentColors.red.toAccentColor().darker)),
      ),
      // ignore: prefer_inlined_adds
    ]..add(DataCell(Wrap(
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
                  int? pageNum = await RouteGenerator.routerClient
                      .pushNamed<int>(Routers.newEditBrandName,
                          params: {"newEditBrand": brand.id!.toString()},
                          extra: brand,
                          queryParams: {
                            "isEdit": "true",
                            "pageNum": viewModel.pageNum
                          });

                  if (pageNum != null) {
                    Future.delayed(const Duration(milliseconds: 700))
                        .then((value) => viewModel.getAllBrandsStorage(true));
                    viewModel.newEditComboStatus = '';
                    viewModel.nameNewEditController.clear();
                    viewModel.pageNum = pageNum.toString();
                    // if (viewModel.pageKey == null) {
                    //   viewModel.pageKey =
                    //       GlobalKey<page_key.PaginatedDataTableState>();
                    // }
                    // Future.delayed(const Duration(milliseconds: 3000)).then(
                    //     (value) => viewModel.pageKey.currentState!
                    //         .pageTo(int.parse(viewModel.pageNum)));
                  }
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
                  await viewModel.deleteBrandStorage(brand.id);

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

  List<DataColumnsSorter<Brand, dynamic>> _columnData() {
    return [
      DataColumnsSorter<Brand, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (brand) => brand.id ?? 0,
          type: 0),
      DataColumnsSorter<Brand, String>(
          columnName: 'name'.tr(),
          isNumeric: false,
          onSort: (brand) => brand.name ?? '',
          type: ''),
      DataColumnsSorter<Brand, dynamic>(
          columnName: 'status'.tr(),
          isNumeric: false,
          onSort: null,
          type: Status.inactive),
      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<Brand, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  Widget headerDataTable(BuildContext context) {
    return Text(
      'brand_title'.tr(),
      style: FluentTheme.of(context)
          .typography
          .caption!
          .copyWith(fontWeight: FontWeight.bold),
    );
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
              viewModel.getAllBrandsStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  BlocPaginationDataTable<Brand> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Brand> dataTable =
        BlocPaginationDataTable<Brand>(
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

  //! Build Widgets
  Widget header(BuildContext context) {
    return PageHeader(
      title: Text('brand_header'.tr()),
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
            message: 'brand_tooltip_add_brand'.tr(),
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
                  int? pageNum = await RouteGenerator.routerClient
                      .pushNamed<int>(Routers.newEditBrandName,
                          params: {"newEditBrand": 0.toString()},
                          extra: null,
                          queryParams: {
                            "isEdit": "false",
                            "pageNum": viewModel.pageNum
                          });

                  if (pageNum != null) {
                    Future.delayed(const Duration(milliseconds: 700))
                        .then((value) => viewModel.getAllBrandsStorage(true));
                    viewModel.newEditComboStatus = '';
                    viewModel.nameNewEditController.clear();
                    viewModel.pageNum = pageNum.toString();
                    // if (viewModel.pageKey == null) {
                    //   viewModel.pageKey =
                    //       GlobalKey<page_key.PaginatedDataTableState>();
                    // }
                    // Future.delayed(const Duration(milliseconds: 2000)).then(
                    //     (value) => viewModel.pageKey.currentState!
                    //         .pageTo(int.parse(viewModel.pageNum)));
                  }
                },
              ),
            ),
          ),
          // iconButtonMode: IconButtonMode.large,
          // onPressed: () {
          // },
        )
      ]),
    );
  }

  Widget filterButton(BuildContext context) {
    return Tooltip(
      displayHorizontally: false,
      message: 'brand_tooltip_filter'.tr(),
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
            viewModel.getAllBrandsStorage(false);
          },
        ),
      ),
    );
  }

  Widget resetButton(BuildContext context) {
    return Tooltip(
      displayHorizontally: false,
      message: 'brand_tooltip_reset'.tr(),
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
      width: 150,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.nameFilterController,
        placeholder: 'brand_textBox_placeHolder'.tr(),
        expands: false,
      ),
    );
  }

  Widget status(BuildContext context) {
    return BlocStateBuilder(
        cubit: viewModel.statusFilterCubit,
        builder: (context, state) {
          return ComboBox<String>(
              placeholder: Text('brand_comboBox_status_placeHolder'.tr()),
              value: (viewModel.statusFilterCubit.getValue as String).isEmpty
                  ? null
                  : viewModel.statusFilterCubit.getValue,
              items: [Status.active.name.tr(), Status.inactive.name.tr()]
                  .map<ComboBoxItem<String>>((String status) {
                return ComboBoxItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              iconEnabledColor: FluentTheme.of(context).accentColor,
              onChanged: (String? status) {
                if (status != null) {
                  viewModel.statusFilterCubit.changeValue(true, status);
                }
              });
        });
  }

  Widget sorter(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('sort'.tr()),
          value: viewModel.sortContent.isEmpty ? null : viewModel.sortContent,
          items: ['id'.tr(), 'name'.tr(), 'status'.tr()]
              .map<ComboBoxItem<String>>((String sort) {
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
            }
            //'status'.tr()
            else {
              viewModel.sortContent = 'status'.tr();
              viewModel.sortIndex = 2;
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
      child: BlocList<Brand>(
          id: viewModel.dataTableId,
          isPagination: false,
          isRemoteData: false,
          cubit: viewModel.stater,
          loadMoreCubit: viewModel.loadMore,
          onRetryFunction: () {
            viewModel.getAllBrandsStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return dataTable(context);
          }),
    );
  }
}

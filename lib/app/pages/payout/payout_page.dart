import 'package:business_light/app/viewmodels/payout_view_model.dart';
import 'package:business_light/utils/constants.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import '../../../domain/entity/payout.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../bloc/bloc_state_builder.dart';
import '../../widgets/description_dialog.dart';

// ignore: must_be_immutable
class PayoutPage extends StatefulWidget {
  const PayoutPage({super.key});

  @override
  State<StatefulWidget> createState() => _PayoutPageState();
}

class _PayoutPageState extends State<PayoutPage> {
  late PayoutViewModel viewModel;

  // Payout types list
  List<String> payoutTypes = [
    PayoutType.debt.name.tr(),
    PayoutType.salary.name.tr(),
    PayoutType.tax.name.tr(),
    PayoutType.other.name.tr(),
  ];

  // Sort items list
  List<String> sortComboBox = [
    'id'.tr(),
    'code'.tr(),
    'price'.tr(),
    'description'.tr(),
    'date'.tr(),
    'payout_type'.tr(),
  ];

  @override
  void initState() {
    viewModel = getItClient.get<PayoutViewModel>();
    viewModel.getAllPayoutsStorage(false);
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
                            ////////////// * Filter Code * /////////////
                            code(context),
                            ////////////// * Filter price * /////////////
                            price(context),
                            ////////////// * Filter description * /////////////
                            description(context),
                            ////////////// * Filter Payout Type * /////////////
                            payoutTypeData(context),
                            ////////////// * Sorters * /////////////
                            sorter(context),
                            ////////////// * Checkbox Desc * /////////////
                            StatefulBuilder(
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
                            ),
                            ////////////// * Filter Start Date * /////////////
                            startDate(context),
                            ////////////// * Filter End Date * /////////////
                            endDate(context),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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

  //! Payouts DataTable Widgets
  BlocPaginationDataTable<Payout> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Payout> dataTable =
        BlocPaginationDataTable<Payout>(
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

  Widget headerDataTable(BuildContext context) {
    return Text(
      'payout_title'.tr(),
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
              viewModel.getAllPayoutsStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  List<DataColumnsSorter<Payout, dynamic>> _columnData() {
    return [
      DataColumnsSorter<Payout, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (payment) => payment.id ?? 0,
          type: 0),
      DataColumnsSorter<Payout, String>(
          columnName: 'code'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.code ?? '',
          type: ''),
      DataColumnsSorter<Payout, dynamic>(
          columnName: 'price'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.price ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Payout, String>(
          columnName: 'description'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.description ?? '',
          type: ''),
      DataColumnsSorter<Payout, dynamic>(
          columnName: 'date'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.date ?? DateTime.now(),
          type: DateTime.now()),
      DataColumnsSorter<Payout, dynamic>(
          columnName: 'payout_type'.tr(),
          isNumeric: false,
          onSort: null,
          type: PayoutType.other),
      DataColumnsSorter<Payout, String>(
          columnName: 'employee'.tr(),
          isNumeric: false,
          onSort: null,
          type: ''),
      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<Payout, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  List<material.DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    Payout? payout = obj as Payout?;

    return [
      material.DataCell(
        SelectableText(payout!.id.toString()),
      ),
      material.DataCell(
        SelectableText(payout.code ?? ''),
      ),
      material.DataCell(
        SelectableText(
            '${payout.price} \$'), //! change to usd or other currencies !!!
      ),
      material.DataCell(
        Text(
            '${payout.description!.length <= 15 ? payout.description! : '${payout.description!.substring(0, 15)}...'} '),
        onTap: () async {
          await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (_) => DescriptionDialog(
                    name: payout.code ?? '',
                    description: payout.description ?? '',
                  ));
        },
      ),
      material.DataCell(
        SelectableText(
            DateFormat(('yyyy-MM-dd hh:mm')).format(payout.date!).toString()),
      ),
      material.DataCell(
        SelectableText(payout.payoutType.name.tr(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.purple.toAccentColor().lighter
                    : FluentColors.purple.toAccentColor().darker)),
      ),
      material.DataCell(
        SelectableText(payout.employeeSalary.value == null
            ? ''
            : payout.employeeSalary.value!.fullName ?? ''),
      ),
      // ignore: prefer_inlined_adds
    ]..add(material.DataCell(Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        children: [
          ////////////// * Edit * /////////////
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
                  viewModel.navigateEditPayout(payout);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          ////////////// * Delete * /////////////
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
                  await viewModel.deletePayoutStorage(payout.id!);

                  // ignore: use_build_context_synchronously
                  CustomInfoBar.showDefault(
                      context: context,
                      title: 'brand_infoBar_delete_success'.tr(),
                      severity: InfoBarSeverity.success);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
        ],
      )));
  }

  //! Build Widgets
  Widget header(BuildContext context) {
    return PageHeader(
      title: Text('payout_header'.tr()),
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
            message: 'payout_tooltip_add_payout'.tr(),
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
                  viewModel.navigateAddPayout();
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
            viewModel.getAllPayoutsStorage(false);
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

  Widget code(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.codeFilterController,
        placeholder: 'code'.tr(),
        expands: false,
      ),
    );
  }

  Widget price(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.priceFilterController,
        placeholder: 'price'.tr(),
        expands: false,
      ),
    );
  }

  Widget description(BuildContext context) {
    return SizedBox(
      width: 230,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.descriptionFilterController,
        placeholder: 'description'.tr(),
        expands: false,
      ),
    );
  }

  Widget payoutTypeData(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('payout_type'.tr()),
          value: viewModel.payoutTypeFilter.isEmpty
              ? null
              : viewModel.payoutTypeFilter,
          items: payoutTypes.map<ComboBoxItem<String>>((String type) {
            return ComboBoxItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? type) {
            if (type != null) {
              viewModel.payoutTypeFilter = type;
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
          items: sortComboBox.map<ComboBoxItem<String>>((String sort) {
            return ComboBoxItem<String>(value: sort, child: Text(sort));
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? sort) {
            if (sort == 'id'.tr()) {
              viewModel.sortContent = 'id'.tr();
              viewModel.sortIndex = 0;
            } else if (sort == 'code'.tr()) {
              viewModel.sortContent = 'code'.tr();
              viewModel.sortIndex = 1;
            } else if (sort == 'price'.tr()) {
              viewModel.sortContent = 'price'.tr();
              viewModel.sortIndex = 2;
            } else if (sort == 'description'.tr()) {
              viewModel.sortContent = 'description'.tr();
              viewModel.sortIndex = 3;
            } else if (sort == 'date'.tr()) {
              viewModel.sortContent = 'date'.tr();
              viewModel.sortIndex = 4;
            }
            //Payout Type
            else {
              viewModel.sortContent = 'payout_type'.tr();
              viewModel.sortIndex = 5;
            }
            state(() {});
          });
    });
  }

  Widget startDate(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return DatePicker(
          startYear: 2000,
          endYear: 2100,
          showDay: true,
          showMonth: true,
          showYear: true,
          header: 'product_infoLabel_start_date'.tr(),
          selected: viewModel.selectedStartDate,
          onChanged: (time) {
            viewModel.selectedStartDate = time;
            state(() {});
          });
    });
  }

  Widget endDate(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return DatePicker(
          startYear: 2000,
          endYear: 2100,
          showDay: true,
          showMonth: true,
          showYear: true,
          header: 'product_infoLabel_end_date'.tr(),
          selected: viewModel.selectedEndDate,
          onChanged: (time) {
            viewModel.selectedEndDate = time;
            state(() {});
          });
    });
  }

  Widget dataTableWidget(BuildContext context) {
    return Center(
      child: BlocList<Payout>(
          id: viewModel.dataTableId,
          isPagination: false,
          isRemoteData: false,
          cubit: viewModel.stater,
          loadMoreCubit: viewModel.loadMore,
          onRetryFunction: () {
            viewModel.getAllPayoutsStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return dataTable(context);
          }),
    );
  }
}

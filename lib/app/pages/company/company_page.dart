import 'dart:io';

import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/company.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../bloc/bloc_state_builder.dart';
import '../../viewmodels/company_view_model.dart';
import '../../widgets/description_dialog.dart';
import '../../widgets/image_dialog.dart';

// ignore: must_be_immutable
class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<StatefulWidget> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  late CompanyViewModel viewModel;

  /// Sort items list
  List<String> sortComboBox = [
    'id'.tr(),
    'name'.tr(),
    'email'.tr(),
    'phone'.tr(),
    'address'.tr(),
    'description'.tr(),
    'country'.tr(),
  ];

  @override
  void initState() {
    viewModel = getItClient.get<CompanyViewModel>();
    viewModel.getAllCompaniesStorage(false);
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
                            ////////////// * Filter Email * /////////////
                            email(context),
                            ////////////// * Filter Phone * /////////////
                            phone(context),
                            ////////////// * Filter Address * /////////////
                            address(context),
                            ////////////// * Filter Bio * /////////////
                            bio(context),
                            ////////////// * Filter Country * /////////////
                            country(context),
                            ////////////// * Sorters * /////////////
                            sorter(context),
                            ////////////// * Checkbox Desc * /////////////
                            checkDesc(context),
                          ],
                        );
                      })),
              const SizedBox(
                height: 12,
              ),
              ////////////// * Data Table * /////////////
              dataTableWidget(context),
              const SizedBox(
                height: 20,
              ),
            ],
          )),
    );
  }

  //! Company DataTable Widgets
  BlocPaginationDataTable<Company> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Company> dataTable =
        BlocPaginationDataTable<Company>(
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
      'company_title'.tr(),
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
              viewModel.getAllCompaniesStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  List<material.DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    Company? company = obj as Company?;

    return [
      material.DataCell(
        SelectableText(company!.id.toString()),
      ),
      material.DataCell(
          company.imagePath!.isEmpty
              ? Center(
                  child: Card(
                      borderRadius: BorderRadius.circular(250),
                      child: const Center(
                        child: Icon(
                          FluentIcons.user_window,
                          size: 15,
                        ),
                      )))
              : Center(
                  child: ClipRRect(
                  borderRadius: BorderRadius.circular(250),
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: OctoImage(
                        image: FileImage(File(company.imagePath!)),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, imageChunk) =>
                            const SizedBox(
                                width: 25, height: 25, child: ProgressRing()),
                        errorBuilder: (context, error, stackTrace) => Center(
                            child: Card(
                          borderRadius: BorderRadius.circular(250),
                          child: const Center(
                            child: Icon(
                              FluentIcons.error,
                              size: 10,
                            ),
                          ),
                        )),
                      )),
                )),
          onTap: company.imagePath!.isEmpty
              ? null
              : () async {
                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => ImageDialog(
                            urlImage: company.imagePath!,
                          ));
                }),

      material.DataCell(
        SelectableText(company.name ?? ''),
      ),
      material.DataCell(
        SelectableText(company.email ?? ''),
      ),
      material.DataCell(
        SelectableText(company.phone ?? ''),
      ),
      material.DataCell(
        SelectableText(company.address ?? ''),
      ),
      material.DataCell(
        SelectableText(company.country ?? ''),
      ),
      material.DataCell(
          Text(
            '${company.bio!.length <= 15 ? company.bio! : '${company.bio!.substring(0, 15)}...'} ',
          ), onTap: () async {
        await showDialog<String>(
            context: context,
            barrierDismissible: true,
            builder: (_) => DescriptionDialog(
                  name: company.name ?? '',
                  description: company.bio ?? '',
                ));
      }),
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
                  viewModel.navigateEditCompany(company);
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
                  await viewModel.deleteCompanyStorage(company.id!);

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

  List<DataColumnsSorter<Company, dynamic>> _columnData() {
    return [
      DataColumnsSorter<Company, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (company) => company.id ?? 0,
          type: 0),
      DataColumnsSorter<Company, String>(
          columnName: 'image_path'.tr(),
          isNumeric: false,
          onSort: (user) => user.imagePath ?? '',
          type: ''),
      DataColumnsSorter<Company, String>(
          columnName: 'name'.tr(),
          isNumeric: false,
          onSort: (company) => company.name ?? '',
          type: ''),
      DataColumnsSorter<Company, String>(
          columnName: 'email'.tr(),
          isNumeric: false,
          onSort: (company) => company.email ?? '',
          type: ''),
      DataColumnsSorter<Company, String>(
          columnName: 'phone'.tr(),
          isNumeric: false,
          onSort: (company) => company.phone ?? '',
          type: ''),
      DataColumnsSorter<Company, String>(
          columnName: 'address'.tr(),
          isNumeric: false,
          onSort: (company) => company.address ?? '',
          type: ''),
      DataColumnsSorter<Company, String>(
          columnName: 'country'.tr(),
          isNumeric: false,
          onSort: (company) => company.country ?? '',
          type: ''),
      DataColumnsSorter<Company, String>(
          columnName: 'description'.tr(),
          isNumeric: false,
          onSort: (company) => company.bio ?? '',
          type: ''),
      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<Company, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  //! Build Widgets
  Widget header(BuildContext context) {
    return PageHeader(
      title: Text('company_header'.tr()),
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
            message: 'company_tooltip_add_company'.tr(),
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
                  viewModel.navigateAddCompany();
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
            viewModel.getAllCompaniesStorage(false);
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
        placeholder: 'name'.tr(),
        expands: false,
      ),
    );
  }

  Widget email(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.emailFilterController,
        placeholder: 'email'.tr(),
        expands: false,
      ),
    );
  }

  Widget phone(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.phoneFilterController,
        placeholder: 'phone'.tr(),
        expands: false,
      ),
    );
  }

  Widget address(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.addressFilterController,
        placeholder: 'address'.tr(),
        expands: false,
      ),
    );
  }

  Widget bio(BuildContext context) {
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

  Widget country(BuildContext context) {
    return SizedBox(
      width: 230,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.countryFilterController,
        placeholder: 'country'.tr(),
        expands: false,
      ),
    );
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
            } else if (sort == 'name'.tr()) {
              viewModel.sortContent = 'name'.tr();
              viewModel.sortIndex = 1;
            } else if (sort == 'email'.tr()) {
              viewModel.sortContent = 'email'.tr();
              viewModel.sortIndex = 2;
            } else if (sort == 'phone'.tr()) {
              viewModel.sortContent = 'phone'.tr();
              viewModel.sortIndex = 3;
            } else if (sort == 'address'.tr()) {
              viewModel.sortContent = 'address'.tr();
              viewModel.sortIndex = 4;
            } else if (sort == 'description'.tr()) {
              viewModel.sortContent = 'description'.tr();
              viewModel.sortIndex = 5;
            }
            //Country
            else {
              viewModel.sortContent = 'country'.tr();
              viewModel.sortIndex = 6;
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
      child: BlocList<Company>(
          id: viewModel.dataTableId,
          isPagination: false,
          isRemoteData: false,
          cubit: viewModel.stater,
          loadMoreCubit: viewModel.loadMore,
          onRetryFunction: () {
            viewModel.getAllCompaniesStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return dataTable(context);
          }),
    );
  }
}

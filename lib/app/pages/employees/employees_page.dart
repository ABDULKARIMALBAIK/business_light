import 'dart:io';

import 'package:business_light/utils/app_color.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/user.dart';
import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../bloc/bloc_state_builder.dart';
import '../../viewmodels/employees_view_model.dart';
import '../../widgets/description_dialog.dart';
import '../../widgets/image_dialog.dart';

// ignore: must_be_immutable
class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<StatefulWidget> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  late EmployeesViewModel viewModel;

  // Levels list filter
  List<String> levelsComboBox = [
    UserLevel.worker.name.tr(),
    UserLevel.manager.name.tr(),
    UserLevel.other.name.tr()
  ];

  // Sort items list
  List<String> sortComboBox = [
    'id'.tr(),
    'name'.tr(),
    'email'.tr(),
    'salary'.tr(),
    'phone'.tr(),
    'job_desc'.tr(),
    'level'.tr()
  ];

  @override
  void initState() {
    viewModel = getItClient.get<EmployeesViewModel>();
    viewModel.getAllEmployeesStorage(false);
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
                              ////////////// * Filter Greater Salary * /////////////
                              greaterSalary(context),
                              ////////////// * Filter Lower Salary * /////////////
                              lowerSalary(context),
                              ////////////// * Filter Phone * /////////////
                              phone(context),
                              ////////////// * Filter Job Description * /////////////
                              jobDescription(context),
                              ////////////// * Filter Level * /////////////
                              levels(context),
                              ////////////// * Sorters * /////////////
                              sorter(context),
                              ////////////// * Checkbox Desc * /////////////
                              checkDesc(context),
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ////////////// * Data Table * /////////////
                  dataTableWidget(context),
                  const SizedBox(
                    height: 14,
                  ),
                ],
              ),
            ));
  }

  //! Employees DataTable Widgets
  BlocPaginationDataTable<User> dataTable(BuildContext context) {
    final BlocPaginationDataTable<User> dataTable =
        BlocPaginationDataTable<User>(
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
      'employees_title'.tr(),
      style: FluentTheme.of(context)
          .typography
          .caption!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<material.DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    User? employee = obj as User?;

    return [
      material.DataCell(
        SelectableText(employee!.id.toString()),
      ),
      material.DataCell(
          employee.imagePath!.isEmpty
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
                      width: 35,
                      height: 35,
                      child: OctoImage(
                        image: FileImage(File(employee.imagePath!)),
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
          onTap: employee.imagePath!.isEmpty
              ? null
              : () async {
                  await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) => ImageDialog(
                            urlImage: employee.imagePath!,
                          ));
                }),

      material.DataCell(
        SelectableText(employee.fullName ?? ''),
      ),
      material.DataCell(
        const Text(
          '***********',
        ),
        onTap: () async {
          await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (_) => DescriptionDialog(
                    name: employee.fullName ?? '',
                    description: employee.password ?? '',
                  ));
        },
      ),
      material.DataCell(
        SelectableText(employee.email ?? ''),
      ),
      material.DataCell(
        SelectableText(employee.salary == null
            ? 0.0.toString()
            : employee.salary.toString()),
      ),
      material.DataCell(
        SelectableText(employee.phone ?? ''),
      ),
      material.DataCell(
        Text(
          '${employee.jobDescription!.length <= 15 ? employee.jobDescription! : '${employee.jobDescription!.substring(0, 15)}...'} ',
        ),
        onTap: () async {
          await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (_) => DescriptionDialog(
                    name: employee.fullName ?? '',
                    description: employee.jobDescription ?? '',
                  ));
        },
      ),
      material.DataCell(
        SelectableText(employee.level.name.tr(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.purple.toAccentColor().lighter
                    : FluentColors.purple.toAccentColor().darker)),
      ),
      // ignore: prefer_inlined_adds
    ]..add(material.DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  viewModel.navigateEditEmployee(employee);
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
                  await viewModel.deleteEmployeeStorage(employee.id!);

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
          ////////////// * Details * /////////////
          Tooltip(
            displayHorizontally: false,
            message: 'details'.tr(),
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
                    FluentIcons.info,
                    size: 15,
                    color: DataHelper.isDark()
                        ? FluentColors.blue.toAccentColor().lighter
                        : FluentColors.blue.toAccentColor().darker,
                  ),
                ),
                onPressed: () async {
                  viewModel.navigateEmployeeDetails(employee);
                },
              ),
            ),
          ),
        ],
      )));
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
              viewModel.getAllEmployeesStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  List<DataColumnsSorter<User, dynamic>> _columnData() {
    return [
      DataColumnsSorter<User, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (user) => user.id ?? 0,
          type: 0),
      DataColumnsSorter<User, String>(
          columnName: 'image_path'.tr(),
          isNumeric: false,
          onSort: (user) => user.imagePath ?? '',
          type: ''),
      DataColumnsSorter<User, String>(
          columnName: 'name'.tr(),
          isNumeric: false,
          onSort: (user) => user.fullName ?? '',
          type: ''),
      DataColumnsSorter<User, String>(
          columnName: 'password'.tr(),
          isNumeric: false,
          onSort: (user) => user.password ?? '',
          type: ''),
      DataColumnsSorter<User, String>(
          columnName: 'email'.tr(),
          isNumeric: false,
          onSort: (user) => user.email ?? '',
          type: ''),
      DataColumnsSorter<User, dynamic>(
          columnName: 'salary'.tr(),
          isNumeric: false,
          onSort: (user) => user.salary ?? 0.0,
          type: 0.0),
      DataColumnsSorter<User, String>(
          columnName: 'phone'.tr(),
          isNumeric: false,
          onSort: (user) => user.phone ?? '',
          type: ''),
      DataColumnsSorter<User, String>(
          columnName: 'job_desc'.tr(),
          isNumeric: false,
          onSort: (user) => user.jobDescription ?? '',
          type: ''),

      DataColumnsSorter<User, dynamic>(
          columnName: 'level'.tr(),
          isNumeric: false,
          onSort: null,
          type: UserLevel.other),
      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<User, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  //! Build Widgets
  Widget header(BuildContext context) {
    return PageHeader(
      title: Text('employees_header'.tr()),
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
            message: 'employees_tooltip_add_employee'.tr(),
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
                  viewModel.navigateAddEmployee();
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
            viewModel.getAllEmployeesStorage(false);
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

  Widget greaterSalary(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.salaryFilterGreaterController,
        placeholder: 'salary_greater'.tr(),
        expands: false,
      ),
    );
  }

  Widget lowerSalary(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.salaryFilterLowerController,
        placeholder: 'salary_lower'.tr(),
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

  Widget jobDescription(BuildContext context) {
    return SizedBox(
      width: 230,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.jobDescriptionFilterController,
        placeholder: 'job_desc'.tr(),
        expands: false,
      ),
    );
  }

  Widget levels(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('level'.tr()),
          value: viewModel.levelFilter.isEmpty ? null : viewModel.levelFilter,
          items: levelsComboBox.map<ComboBoxItem<String>>((String status) {
            return ComboBoxItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? level) {
            if (level != null) {
              viewModel.levelFilter = level;
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
            } else if (sort == 'name'.tr()) {
              viewModel.sortContent = 'name'.tr();
              viewModel.sortIndex = 1;
            } else if (sort == 'email'.tr()) {
              viewModel.sortContent = 'email'.tr();
              viewModel.sortIndex = 2;
            } else if (sort == 'phone'.tr()) {
              viewModel.sortContent = 'phone'.tr();
              viewModel.sortIndex = 3;
            } else if (sort == 'job_desc'.tr()) {
              viewModel.sortContent = 'job_desc'.tr();
              viewModel.sortIndex = 4;
            } else if (sort == 'salary'.tr()) {
              viewModel.sortContent = 'salary'.tr();
              viewModel.sortIndex = 5;
            }
            //'level'.tr()
            else {
              viewModel.sortContent = 'level'.tr();
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
      child: BlocList<User>(
          id: viewModel.dataTableId,
          isPagination: false,
          isRemoteData: false,
          cubit: viewModel.stater,
          loadMoreCubit: viewModel.loadMore,
          onRetryFunction: () {
            viewModel.getAllEmployeesStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return dataTable(context);
          }),
    );
  }
}

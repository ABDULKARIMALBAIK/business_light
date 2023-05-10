import 'dart:io';

import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/payout.dart';
import '../../../domain/entity/user.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../bloc/bloc_state_builder.dart';
import '../../viewmodels/employees_view_model.dart';
import 'package:flutter/material.dart' as material;

import '../../widgets/description_dialog.dart';

// ignore: must_be_immutable
class EmployeesDetails extends StatefulWidget {
  EmployeesDetails({
    super.key,
    required this.isEmployee,
    User? userDetails,
  }) {
    viewModel = getItClient.get<EmployeesViewModel>();
    viewModel.userDetails = userDetails;
  }

  late EmployeesViewModel viewModel;
  String isEmployee = "false";

  // Sort items list
  List<String> sortComboBoxDetails = [
    'id'.tr(),
    'price'.tr(),
    'date'.tr(),
  ];

  //! Employee(Payouts) DataTable Widgets
  BlocPaginationDataTable<Payout> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Payout> dataTable =
        BlocPaginationDataTable<Payout>(
      bloc: viewModel.brandDataTableCubitDetails,
      cellsPerRow: (obj) => _cellsPerRow(context, obj),
      columnsData: _columnData(),
      header: header(context),
      actions: actions(context),
      pageKey: viewModel.pageKey,
      // scrollController: viewModel.scrollController,
      currentPage: (pageNum) {
        viewModel.pageNum = pageNum.toString();
      },
      // onRowChanged: onRowChanged
    );
    viewModel.dataSourceDetails = dataTable.paginationData;
    return dataTable;
  }

  Widget header(BuildContext context) {
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
      // ignore: prefer_inlined_adds
    ];
    // ..add(DataColumnsSorter<Payout, dynamic>(
    //     columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
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
      // ignore: prefer_inlined_adds
    ];
    // ..add(material.DataCell(Wrap(
    //     alignment: WrapAlignment.start,
    //     crossAxisAlignment: WrapCrossAlignment.center,
    //     spacing: 0,
    //     children: [
    //       ////////////// * Edit * /////////////
    //       Tooltip(
    //         displayHorizontally: false,
    //         message: 'edit'.tr(),
    //         enableFeedback: true,
    //         child: MouseRegion(
    //           cursor: SystemMouseCursors.click,
    //           child: IconButton(
    //             style: ButtonStyle(
    //               backgroundColor: ButtonState.all(
    //                   FluentTheme.of(context).scaffoldBackgroundColor),
    //             ),
    //             icon: Padding(
    //               padding: const EdgeInsets.all(3.0),
    //               child: Icon(
    //                 FluentIcons.edit,
    //                 size: 15,
    //                 color: DataHelper.getCurrentColor(),
    //               ),
    //             ),
    //             onPressed: () async {
    //               viewModel.navigateEditPayout(payout);
    //             },
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 4,
    //       ),
    //       ////////////// * Delete * /////////////
    //       Tooltip(
    //         displayHorizontally: false,
    //         message: 'delete'.tr(),
    //         enableFeedback: true,
    //         child: MouseRegion(
    //           cursor: SystemMouseCursors.click,
    //           child: IconButton(
    //             style: ButtonStyle(
    //               backgroundColor: ButtonState.all(
    //                   FluentTheme.of(context).scaffoldBackgroundColor),
    //             ),
    //             icon: Padding(
    //               padding: const EdgeInsets.all(3.0),
    //               child: Icon(
    //                 FluentIcons.delete,
    //                 size: 15,
    //                 color: FluentColors.red,
    //               ),
    //             ),
    //             onPressed: () async {
    //               await viewModel.deletePayoutStorage(payout.id!);

    //               // ignore: use_build_context_synchronously
    //               CustomInfoBar.showDefault(
    //                   context: context,
    //                   title: 'brand_infoBar_delete_success'.tr(),
    //                   severity: InfoBarSeverity.success);
    //             },
    //           ),
    //         ),
    //       ),
    //       const SizedBox(
    //         width: 4,
    //       ),
    //     ],
    //   )));
  }

  @override
  State<StatefulWidget> createState() => _EmployeesDetailsState();
}

class _EmployeesDetailsState extends State<EmployeesDetails> {
  @override
  void initState() {
    widget.viewModel.getAllEmployeesStorage(false);
    widget.viewModel.getAllPayoutsStorage(false);
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
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Image * /////////////
                image(context),
                const SizedBox(
                  height: 30,
                ),
                ////////////// * Name * /////////////
                name(context),
                const SizedBox(
                  height: 30,
                ),
                ////////////// * Email * /////////////
                email(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Password * /////////////
                password(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Phone * /////////////
                phone(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Salary * /////////////
                salary(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Job Description * /////////////
                jobDescription(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Level * /////////////
                levelEmployee(context),
                const SizedBox(
                  height: 70,
                ),
                ////////////// * Filters & Sorting * /////////////
                Text(
                  'payout_header'.tr(),
                  style: FluentTheme.of(context).typography.title,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: BlocStateBuilder(
                    cubit: widget.viewModel.groupDetailsFilterCubit,
                    builder: (context, state) {
                      return Wrap(
                        direction: Axis.horizontal,
                        spacing: 15,
                        runSpacing: 15,
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          ////////////// * Filter Button * /////////////
                          filterButton(context),
                          ////////////// * Reset Button * /////////////
                          resetButton(context),
                          ////////////// * Filter Start Date * /////////////
                          filterStartDate(context),
                          ////////////// * Filter End Date * /////////////
                          filterEndDate(context),
                          ////////////// * Filter price * /////////////
                          filterPrice(context),
                          ////////////// * Sorters * /////////////
                          sorter(context),
                          ////////////// * Checkbox Desc * /////////////
                          checkDesc(context),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ////////////// * Payouts * /////////////
                payoutsEmployee(context)
              ],
            )));
  }

  Widget header(BuildContext context) {
    return PageHeader(
      title: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          RotatedBox(
            quarterTurns: DataHelper.rotateBackButton(),
            child: Tooltip(
              displayHorizontally: false,
              message: 'back'.tr(),
              enableFeedback: true,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  iconButtonMode: IconButtonMode.large,
                  icon: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      FluentIcons.back,
                      size: 19,
                      // color: DataHelper.currentColor,
                    ),
                  ),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop<int>(int.parse(widget.viewModel.pageNum));
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text('employees_details_header'.tr())
        ],
      ),
    );
  }

  Widget image(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: SizedBox(
            width: 250,
            height: 250,
            child: OctoImage(
              image: FileImage(
                  File(widget.viewModel.userDetails!.imagePath ?? '')),
              width: 250,
              height: 250,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, imageChunk) =>
                  const SizedBox(width: 30, height: 30, child: ProgressRing()),
              errorBuilder: (context, error, stackTrace) => Center(
                  child: ClipRRect(
                borderRadius: BorderRadius.circular(200),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Card(
                      child: Center(
                    child: Icon(
                      FluentIcons.user_clapper,
                      size: 60,
                      color: FluentTheme.of(context).accentColor,
                    ),
                  )),
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }

  Widget name(BuildContext context) {
    return Center(
      child: Text(
        widget.viewModel.userDetails!.fullName ?? '',
        style: FluentTheme.of(context).typography.title,
      ),
    );
  }

  Widget email(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.public_email,
        size: 35,
      ),
      title: Text(
        'email'.tr(),
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        widget.viewModel.userDetails!.email ?? '',
        style: FluentTheme.of(context).typography.subtitle,
      ),
    );
  }

  Widget password(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.password_field,
        size: 35,
      ),
      title: Text(
        'password'.tr(),
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        widget.viewModel.userDetails!.password ?? '',
        style: FluentTheme.of(context).typography.subtitle,
      ),
    );
  }

  Widget phone(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.phone,
        size: 35,
      ),
      title: Text(
        'phone'.tr(),
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        widget.viewModel.userDetails!.phone ?? '',
        style: FluentTheme.of(context).typography.subtitle,
      ),
    );
  }

  Widget salary(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.money,
        size: 35,
      ),
      title: Text(
        'salary'.tr(),
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        widget.viewModel.userDetails!.salary == null
            ? "${0.0.toString()} \$"
            : "${widget.viewModel.userDetails!.salary.toString()} \$",
        style: FluentTheme.of(context).typography.subtitle,
      ),
    );
  }

  Widget jobDescription(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.pen_workspace,
        size: 35,
      ),
      title: Text(
        'job_desc'.tr(),
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        widget.viewModel.userDetails!.jobDescription ?? '',
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 15),
      ),
    );
  }

  Widget levelEmployee(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.accept,
        size: 35,
      ),
      title: Text(
        'level'.tr(),
        style:
            FluentTheme.of(context).typography.subtitle!.copyWith(fontSize: 18),
      ),
      subtitle: Text(
        widget.viewModel.userDetails!.level.name.tr(),
        style: FluentTheme.of(context)
            .typography
            .subtitle!
            .copyWith(color: FluentTheme.of(context).accentColor),
      ),
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
            widget.viewModel.getAllPayoutsStorage(false);
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
            await widget.viewModel.resetFiltersDetails();
          },
        ),
      ),
    );
  }

  Widget filterStartDate(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return DatePicker(
          startYear: 2000,
          endYear: 2100,
          showDay: true,
          showMonth: true,
          showYear: true,
          header: 'product_infoLabel_start_date'.tr(),
          selected: widget.viewModel.selectedStartDateDetails,
          onChanged: (time) {
            widget.viewModel.selectedStartDateDetails = time;
            state(() {});
          });
    });
  }

  Widget filterEndDate(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return DatePicker(
          startYear: 2000,
          endYear: 2100,
          showDay: true,
          showMonth: true,
          showYear: true,
          header: 'product_infoLabel_end_date'.tr(),
          selected: widget.viewModel.selectedEndDateDetails,
          onChanged: (time) {
            widget.viewModel.selectedEndDateDetails = time;
            state(() {});
          });
    });
  }

  Widget filterPrice(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: widget.viewModel.priceFilterDetailsController,
        placeholder: 'price'.tr(),
        expands: false,
      ),
    );
  }

  Widget sorter(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('sort'.tr()),
          value: widget.viewModel.sortContentDetails.isEmpty
              ? null
              : widget.viewModel.sortContentDetails,
          items: widget.sortComboBoxDetails
              .map<ComboBoxItem<String>>((String sort) {
            return ComboBoxItem<String>(value: sort, child: Text(sort));
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? sort) {
            //Id
            if (sort == 'id'.tr()) {
              widget.viewModel.sortContentDetails = 'id'.tr();
              widget.viewModel.sortIndexDetails = 0;
            }
            //Price
            else if (sort == 'price'.tr()) {
              widget.viewModel.sortContentDetails = 'price'.tr();
              widget.viewModel.sortIndexDetails = 1;
            }
            //Date
            else {
              widget.viewModel.sortContentDetails = 'date'.tr();
              widget.viewModel.sortIndexDetails = 2;
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
              checked: widget.viewModel.descDetails,
              onChanged: (value) {
                widget.viewModel.descDetails = !widget.viewModel.descDetails;
                state(() {});
              },
            ),
          ),
        );
      },
    );
  }

  payoutsEmployee(BuildContext context) {
    return Center(
      child: BlocList<Payout>(
          id: widget.viewModel.dataTableIdDetails,
          isPagination: false,
          isRemoteData: false,
          cubit: widget.viewModel.staterDetails,
          loadMoreCubit: widget.viewModel.loadMoreDetails,
          onRetryFunction: () {
            widget.viewModel.getAllPayoutsStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return widget.dataTable(context);
          }),
    );
  }
}

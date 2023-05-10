import 'package:business_light/app/viewmodels/payout_view_model.dart';
import 'package:business_light/domain/entity/payout.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';

import '../../../domain/entity/user.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_state_builder.dart';

// ignore: must_be_immutable
class PayoutAddPage extends StatefulWidget {
  PayoutAddPage({
    super.key,
    required this.isEdit,
    required this.payoutType,
    required this.pageNum,
    Payout? editPayout,
  }) {
    viewModel = getItClient.get<PayoutViewModel>();
    viewModel.editPayout = editPayout;
    viewModel.pageNum = pageNum;
    viewModel.payoutTypeEditAdd = payoutType;
    viewModel.initEditPayout(isEdit);
  }

  late PayoutViewModel viewModel;
  String isEdit = "false";
  String pageNum;
  String payoutType;

  @override
  State<StatefulWidget> createState() => _PayoutAddPageState();
}

class _PayoutAddPageState extends State<PayoutAddPage> {
  @override
  void initState() {
    widget.viewModel.loadAllEmployeesStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynMouseScroll(
        builder: (context, scrollController, physics) =>
            ScaffoldPage.scrollable(
              scrollController: scrollController,
              ////////////// * Header * /////////////
              header: header(context),
              children: [
                ////////////// * Date * /////////////
                const SizedBox(
                  height: 20,
                ),
                datePayout(context),
                ////////////// * Code * /////////////
                const SizedBox(
                  height: 20,
                ),
                code(context),
                const SizedBox(
                  height: 7,
                ),
                generateCodeButton(context),
                ////////////// * Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                price(context),
                ////////////// * Description * /////////////
                const SizedBox(
                  height: 20,
                ),
                description(context),
                ////////////// * Payout Type * /////////////
                const SizedBox(
                  height: 20,
                ),
                ...payoutTypeData(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Employee For Salary Type * /////////////
                selectEmployeeSalary(context),
              ],
            ));
  }

  Widget header(BuildContext context) {
    return PageHeader(
      title: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ////////////// * Back Button * /////////////
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
          Text(widget.isEdit == 'true'
              ? 'payout_edit_header'.tr()
              : 'payout_add_header'.tr()),
        ],
      ),
      commandBar: Wrap(alignment: WrapAlignment.end, children: [
        ////////////// * Save/Edit Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: widget.isEdit == 'true'
                ? 'payout_tooltip_editButton'.tr()
                : 'payout_tooltip_saveButton'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: () async {
                  //! Edit
                  if (widget.isEdit == 'true') {
                    await widget.viewModel.editPayoutStorage(widget.isEdit);
                    // ignore: use_build_context_synchronously
                    CustomInfoBar.showDefault(
                        context: context,
                        title: 'edited_successfully'.tr(),
                        severity: InfoBarSeverity.success);
                    Future.delayed(const Duration(milliseconds: 1000));
                    // ignore: use_build_context_synchronously
                    if (context.canPop()) {
                      // ignore: use_build_context_synchronously
                      context.pop<int>(int.parse(widget.viewModel.pageNum));
                    }
                  }
                  //! Save
                  else {
                    await widget.viewModel
                        .addPayoutStorage(context, widget.isEdit);
                    // ignore: use_build_context_synchronously
                    CustomInfoBar.showDefault(
                        context: context,
                        title: 'inserted_successfully'.tr(),
                        severity: InfoBarSeverity.success);
                    Future.delayed(const Duration(milliseconds: 1000));

                    // ignore: use_build_context_synchronously
                    if (context.canPop()) {
                      // ignore: use_build_context_synchronously
                      context.pop<int>(int.parse(widget.viewModel.pageNum));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      widget.isEdit == 'true' ? 'edit'.tr() : 'save'.tr(),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget datePayout(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return InfoLabel(
        label: 'product_add_infoBar_date'.tr(),
        child: DatePicker(
            startYear: 2000,
            endYear: 2100,
            showDay: true,
            showMonth: true,
            showYear: true,
            // header: 'date'.tr(),
            selected: widget.viewModel.newEditDate,
            onChanged: (time) {
              widget.viewModel.newEditDate = time;
              state(() {});
            }),
      );
    });
  }

  Widget code(BuildContext context) {
    return InfoLabel(
      label: 'payout_add_infoBar_code'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.codeNewEditController,
          placeholder: 'code'.tr(),
          enabled: false,
          expands: false,
        ),
      ),
    );
  }

  Widget generateCodeButton(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 180,
          child: FilledButton(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text('generate_code'.tr()),
              ),
              onPressed: () => widget.viewModel.generateCode()),
        ),
      ],
    );
  }

  Widget price(BuildContext context) {
    return InfoLabel(
      label: 'payout_add_infoBar_price'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.priceNewEditController,
          placeholder: 'price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget description(BuildContext context) {
    return InfoLabel(
      label: 'payout_add_infoBar_description'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.descriptionNewEditController,
          placeholder: 'description'.tr(),
          maxLines: 3,
          expands: false,
        ),
      ),
    );
  }

  List<Widget> payoutTypeData(BuildContext context) {
    if (widget.isEdit == 'true') {
      return [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          runSpacing: 7,
          spacing: 7,
          children: [
            Text('payout_type'.tr()),
            Text(widget.viewModel.payoutTypeEditAdd,
                style: FluentTheme.of(context).typography.body!.copyWith(
                    color: DataHelper.isDark()
                        ? FluentColors.purple.toAccentColor().lighter
                        : FluentColors.purple.toAccentColor().darker)),
          ],
        ),
      ];
    } else {
      return [
        InfoLabel(
          label: 'payout_add_infoBar_comboBox'.tr(),
          child: StatefulBuilder(builder: (context, state) {
            return ComboBox<String>(
                placeholder: Text('payout_type'.tr()),
                value: widget.viewModel.newEditComboPayoutType.isEmpty
                    ? null
                    : widget.viewModel.newEditComboPayoutType,
                items: [
                  PayoutType.tax.name.tr(),
                  PayoutType.debt.name.tr(),
                  PayoutType.salary.name.tr(),
                  PayoutType.other.name.tr(),
                ].map<ComboBoxItem<String>>((String type) {
                  return ComboBoxItem<String>(value: type, child: Text(type));
                }).toList(),
                iconEnabledColor: FluentTheme.of(context).accentColor,
                onChanged: (String? type) {
                  widget.viewModel.newEditComboPayoutType = type ?? '';
                  if (widget.viewModel.newEditComboPayoutType ==
                      PayoutType.salary.name.tr()) {
                    widget.viewModel.employeeSelectedSalary.change(true);
                  } else {
                    widget.viewModel.employeeSelectedSalary.change(false);
                    widget.viewModel.selectedEmployee = null;
                  }
                  state(() {});
                });
          }),
        ),
      ];
    }
  }

  Widget selectEmployeeSalary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: BlocStateBuilder(
          cubit: widget.viewModel.employeeSelectedSalary,
          builder: (context, state) {
            return Visibility(
              visible: widget.viewModel.employeeSelectedSalary.getIsChanged,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.vertical,
                runSpacing: 7,
                children: [
                  InfoLabel(
                    label: 'payout_add_infoBar_comboBox_employee_salary'.tr(),
                    child: StatefulBuilder(builder: (context, setState) {
                      return ComboBox<User>(
                          placeholder: Text('employee'.tr()),
                          value: widget.viewModel.selectedEmployee,
                          items: widget.viewModel.allEmployees
                              .map<ComboBoxItem<User>>((User employee) {
                            return ComboBoxItem<User>(
                                value: employee,
                                child: Text(employee.fullName ?? ''));
                          }).toList(),
                          iconEnabledColor: FluentTheme.of(context).accentColor,
                          onChanged: (User? employee) {
                            widget.viewModel.selectedEmployee = employee;

                            setState(() {});
                          });
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }),
    );
  }
}

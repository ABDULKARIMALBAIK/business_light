import 'package:business_light/app/viewmodels/payment_view_model.dart';
import 'package:business_light/domain/entity/payment.dart';
import 'package:business_light/utils/app_color.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';

import '../../../domain/entity/order.dart';
import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_state_builder.dart';

// ignore: must_be_immutable
class PaymentAddPage extends StatefulWidget {
  PaymentAddPage({
    super.key,
    required this.isEdit,
    required this.paymentType,
    required this.pageNum,
    Payment? editPayment,
  }) {
    viewModel = getItClient.get<PaymentViewModel>();
    viewModel.editPayment = editPayment;
    viewModel.pageNum = pageNum;
    viewModel.paymentTypeEditAdd = paymentType;
    viewModel.initEditPayment(isEdit);
  }

  late PaymentViewModel viewModel;
  String isEdit = "false";
  String pageNum;
  String paymentType;

  @override
  State<StatefulWidget> createState() => _PaymentAddPageState();
}

class _PaymentAddPageState extends State<PaymentAddPage> {
  @override
  void initState() {
    widget.viewModel.loadAllOrdersStorage();
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
                datePayment(context),
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
                pricePayment(context),
                ////////////// * Description * /////////////
                const SizedBox(
                  height: 20,
                ),
                description(context),
                ////////////// * Payment Type * /////////////
                const SizedBox(
                  height: 20,
                ),
                ...paymentType(context),
                const SizedBox(
                  height: 20,
                ),
                ////////////// * order For Order Type * /////////////
                selectOrderPaymentOrderType(context),
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
              ? 'payment_edit_header'.tr()
              : 'payment_add_header'.tr()),
        ],
      ),
      commandBar: Wrap(alignment: WrapAlignment.end, children: [
        ////////////// * Save/Edit Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: widget.isEdit == 'true'
                ? 'payment_tooltip_editButton'.tr()
                : 'payment_tooltip_saveButton'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: () async {
                  //! Edit
                  if (widget.isEdit == 'true') {
                    await widget.viewModel.editPaymentStorage(widget.isEdit);
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
                        .addPaymentStorage(context, widget.isEdit);
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

  Widget datePayment(BuildContext context) {
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
      label: 'payment_add_infoBar_code'.tr(),
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

  Widget pricePayment(BuildContext context) {
    return InfoLabel(
      label: 'payment_add_infoBar_price'.tr(),
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
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
        ),
      ),
    );
  }

  Widget description(BuildContext context) {
    return InfoLabel(
      label: 'payment_add_infoBar_description'.tr(),
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

  List<Widget> paymentType(BuildContext context) {
    if (widget.isEdit == 'true') {
      return [
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.vertical,
          runSpacing: 7,
          spacing: 7,
          children: [
            Text('payment_type'.tr()),
            Text(widget.viewModel.paymentTypeEditAdd,
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
          label: 'payment_add_infoBar_comboBox'.tr(),
          child: StatefulBuilder(builder: (context, state) {
            return ComboBox<String>(
                placeholder: Text('payment_type'.tr()),
                value: widget.viewModel.newEditComboPaymentType.isEmpty
                    ? null
                    : widget.viewModel.newEditComboPaymentType,
                items: [
                  PaymentType.order.name.tr(),
                  PaymentType.other.name.tr()
                ].map<ComboBoxItem<String>>((String type) {
                  return ComboBoxItem<String>(value: type, child: Text(type));
                }).toList(),
                iconEnabledColor: FluentTheme.of(context).accentColor,
                onChanged: (String? type) {
                  widget.viewModel.newEditComboPaymentType = type ?? '';
                  if (widget.viewModel.newEditComboPaymentType ==
                      PaymentType.order.name.tr()) {
                    widget.viewModel.paymentSelectedOrder.change(true);
                  } else {
                    widget.viewModel.paymentSelectedOrder.change(false);
                  }
                  state(() {});

                  widget.viewModel.newEditComboPaymentType = type ?? '';
                  state(() {});
                });
          }),
        ),
      ];
    }
  }

  Widget selectOrderPaymentOrderType(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: BlocStateBuilder(
          cubit: widget.viewModel.paymentSelectedOrder,
          builder: (context, state) {
            return Visibility(
              visible: widget.viewModel.paymentSelectedOrder.getIsChanged,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.vertical,
                runSpacing: 7,
                children: [
                  InfoLabel(
                    label: 'payment_add_infoBar_comboBox_order'.tr(),
                    child: StatefulBuilder(builder: (context, setState) {
                      return ComboBox<Order>(
                          placeholder: Text('order'.tr()),
                          value: widget.viewModel.selectedOrder,
                          items: widget.viewModel.allOrders
                              .map<ComboBoxItem<Order>>((Order order) {
                            return ComboBoxItem<Order>(
                                value: order, child: Text(order.code ?? ''));
                          }).toList(),
                          iconEnabledColor: FluentTheme.of(context).accentColor,
                          onChanged: (Order? order) {
                            widget.viewModel.selectedOrder = order;

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

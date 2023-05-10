import 'dart:io';

import 'package:business_light/domain/entity/payment.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:go_router_flow/go_router_flow.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/order.dart';
import '../../../domain/entity/user.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../viewmodels/customer_view_model.dart';
import '../../widgets/code_dialog.dart';
import '../../widgets/description_dialog.dart';

// ignore: must_be_immutable
class CustomerDetails extends StatefulWidget {
  CustomerDetails({
    super.key,
    User? userDetails,
  }) {
    viewModel = getItClient.get<CustomerViewModel>();
    viewModel.userDetails = userDetails;
  }

  late CustomerViewModel viewModel;

  BlocPaginationDataTable<Payment> dataTablePayments(BuildContext context) {
    final BlocPaginationDataTable<Payment> dataTable =
        BlocPaginationDataTable<Payment>(
      bloc: viewModel.brandDataTablePaymentsCubit,
      cellsPerRow: (obj) => _cellsPerRowPayments(context, obj),
      columnsData: _columnDataPayments(),
      header: headerPayments(context),
      actions: actionsPayments(context),
      pageKey: viewModel.pageKey,
      // scrollController: viewModel.scrollController,
      currentPage: (pageNum) {
        viewModel.pageNum = pageNum.toString();
      },
      // onRowChanged: onRowChanged
    );
    viewModel.dataSourcePayments = dataTable.paginationData;
    return dataTable;
  }

  Widget headerPayments(BuildContext context) {
    return Text(
      'payment_title'.tr(),
      style: FluentTheme.of(context)
          .typography
          .caption!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget>? actionsPayments(BuildContext context) {
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
              viewModel.getAllCustomerPaymentsStorage(true);
            },
          ),
        ),
      ),
    ];
  }

  List<material.DataCell> _cellsPerRowPayments(
      BuildContext context, dynamic obj) {
    Payment? payment = obj as Payment?;

    return [
      material.DataCell(
        SelectableText(payment!.id.toString()),
      ),
      material.DataCell(
        SelectableText(payment.code ?? ''),
      ),
      material.DataCell(
        SelectableText(
            '${payment.price} \$'), //! change to usd or other currencies !!!
      ),
      material.DataCell(
        SelectableText(
            '${payment.description!.length <= 15 ? payment.description! : '${payment.description!.substring(0, 15)}...'} '),
        onTap: () async {
          await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (_) => DescriptionDialog(
                    name: payment.code ?? '',
                    description: payment.description ?? '',
                  ));
        },
      ),
      material.DataCell(
        SelectableText(
            DateFormat(('yyyy-MM-dd hh:mm')).format(payment.date!).toString()),
      ),
      material.DataCell(
        SelectableText(payment.paymentType.name.tr(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.purple.toAccentColor().lighter
                    : FluentColors.purple.toAccentColor().darker)),
      ),
      // ignore: prefer_inlined_adds
    ];
  }

  List<DataColumnsSorter<Payment, dynamic>> _columnDataPayments() {
    return [
      DataColumnsSorter<Payment, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (payment) => payment.id ?? 0,
          type: 0),
      DataColumnsSorter<Payment, String>(
          columnName: 'code'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.code ?? '',
          type: ''),
      DataColumnsSorter<Payment, dynamic>(
          columnName: 'price'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.price ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Payment, String>(
          columnName: 'description'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.description ?? '',
          type: ''),
      DataColumnsSorter<Payment, dynamic>(
          columnName: 'date'.tr(),
          isNumeric: false,
          onSort: (payment) => payment.date ?? DateTime.now(),
          type: DateTime.now()),
      DataColumnsSorter<Payment, dynamic>(
          columnName: 'payment_type'.tr(),
          isNumeric: false,
          onSort: null,
          type: PaymentType.other),
      // ignore: prefer_inlined_adds
    ];
  }

  BlocPaginationDataTable<Order> dataTableOrders(BuildContext context) {
    final BlocPaginationDataTable<Order> dataTable =
        BlocPaginationDataTable<Order>(
      bloc: viewModel.brandDataTableOrdersCubit,
      cellsPerRow: (obj) => _cellsPerRowOrders(context, obj),
      columnsData: _columnDataOrders(),
      header: headerOrders(context),
      actions: actionsOrders(context),
      pageKey: viewModel.pageKey,
      // scrollController: viewModel.scrollController,
      currentPage: (pageNum) {
        viewModel.pageNum = pageNum.toString();
      },
      // onRowChanged: onRowChanged
    );
    viewModel.dataSourceOrders = dataTable.paginationData;
    return dataTable;
  }

  Widget headerOrders(BuildContext context) {
    return Text(
      'order_title'.tr(),
      style: FluentTheme.of(context)
          .typography
          .caption!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  List<Widget>? actionsOrders(BuildContext context) {
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
              viewModel.getAllCustomerOrdersStorage(true);
            },
          ),
        ),
      ),
    ];
  }

  List<DataColumnsSorter<Order, dynamic>> _columnDataOrders() {
    return [
      DataColumnsSorter<Order, num>(
          columnName: 'id'.tr(),
          isNumeric: true,
          onSort: (order) => order.id ?? 0,
          type: 0),
      DataColumnsSorter<Order, String>(
          columnName: 'code'.tr(),
          isNumeric: false,
          onSort: (order) => order.code ?? '',
          type: ''),
      DataColumnsSorter<Order, String>(
          columnName: 'description'.tr(),
          isNumeric: false,
          onSort: (order) => order.description ?? '',
          type: ''),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_sorter_totalQty'.tr(),
          isNumeric: true,
          onSort: (order) => order.totalQty ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_sorter_qtyPieces'.tr(),
          isNumeric: true,
          onSort: (order) => order.qtyPieces ?? 0.0,
          type: 0.0),
      // if (showColumns[5]) ...[
      //   DataColumnsSorter<Order, dynamic>(
      //       columnName: 'order_sorter_pricePieces'.tr(),
      //       isNumeric: true,
      //       onSort: (order) => order.pricePieces ?? 0.0,
      //       type: 0.0),
      // ],
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_sorter_totalPrice'.tr(),
          isNumeric: true,
          onSort: (order) => order.totalPrice ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_chargeCost'.tr(),
          isNumeric: true,
          onSort: (order) => order.chargeCost ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_otherCost'.tr(),
          isNumeric: true,
          onSort: (order) => order.otherCost ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_balancer'.tr(),
          isNumeric: true,
          onSort: (order) => order.balancer ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_discount'.tr(),
          isNumeric: true,
          onSort: (order) => order.discount ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_sorter_finalPrice'.tr(),
          isNumeric: true,
          onSort: (order) => order.finalPrice ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'order_paymentTotal'.tr(),
          isNumeric: true,
          onSort: (order) {
            double totalPayments = 0.0;
            for (Payment pay in order.payments) {
              totalPayments += pay.price ?? 0.0;
            }
            return totalPayments;
          },
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'is_paid'.tr(),
          isNumeric: false,
          onSort: (order) =>
              order.finalPrice ?? 0.0, //totalPayments >= order.finalPrice
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'date'.tr(),
          isNumeric: false,
          onSort: (order) => order.finalPrice ?? 0.0,
          type: 0.0),
      DataColumnsSorter<Order, dynamic>(
          columnName: 'customer'.tr(),
          isNumeric: false,
          onSort: (order) => order.user.value!.fullName ?? '',
          type: ''),
      // DataColumnsSorter<Order, dynamic>(
      //     columnName: 'product_header'.tr(),
      //     isNumeric: false,
      //     onSort: (order) => '',
      //     type: ''),
      // DataColumnsSorter<Order, dynamic>(
      //     columnName: 'payment_header'.tr(),
      //     isNumeric: false,
      //     onSort: (order) => '',
      //     type: ''),
      // ignore: prefer_inlined_adds
    ];
  }

  List<material.DataCell> _cellsPerRowOrders(
      BuildContext context, dynamic obj) {
    Order? order = obj as Order?;

    double totalPayments = 0.0;
    List<double> payments =
        order!.payments.map<double>((pay) => pay.price ?? 0.0).toList();
    for (double pay in payments) {
      totalPayments += pay;
    }

    String isPaid = '';
    if (totalPayments >= order.finalPrice!) {
      isPaid = 'is_paid'.tr();
    } else {
      isPaid = 'is_not_paid'.tr();
    }

    return [
      material.DataCell(
        SelectableText(order.id.toString()),
      ),
      material.DataCell(
        SelectableText(order.code.toString()),
        onTap: () async {
          String? result = await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (_) => CodeDialog(
                    name: 'order'.tr(),
                    code: order.code ?? '',
                  ));

          if (result != null) {
            if (result == 'save') {
              viewModel.saveCode(
                  codeText: order.code ?? '', nameFile: 'order'.tr());
            } else if (result == 'print') {
              viewModel.printCode(order);
            }
          }
        },
      ),
      material.DataCell(
        SelectableText(
            '${order.description!.length <= 15 ? order.description! : '${order.description!.substring(0, 15)}...'} '),
        onTap: () async {
          await showDialog<String>(
              context: context,
              barrierDismissible: true,
              builder: (_) => DescriptionDialog(
                    name: 'order'.tr(),
                    description: order.description ?? '',
                  ));
        },
      ),
      material.DataCell(
        SelectableText(order.totalQty.toString()),
      ),
      material.DataCell(
        SelectableText(order.qtyPieces.toString()),
      ),
      // if (showColumns[5]) ...[
      //   material.DataCell(
      //     SelectableText(order.pricePieces.toString()),
      //   ),
      // ],
      material.DataCell(
        SelectableText(order.totalPrice.toString()),
      ),
      material.DataCell(
        SelectableText(order.chargeCost.toString()),
      ),
      material.DataCell(
        SelectableText(order.otherCost.toString()),
      ),
      material.DataCell(
        SelectableText(order.balancer.toString()),
      ),
      material.DataCell(
        SelectableText(order.discount.toString()),
      ),
      material.DataCell(
        SelectableText(order.finalPrice.toString()),
      ),
      material.DataCell(
        SelectableText(totalPayments.toStringAsFixed(2)),
      ),
      material.DataCell(
        SelectableText(isPaid,
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: isPaid == 'is_paid'.tr()
                    ? DataHelper.isDark()
                        ? FluentColors.green.toAccentColor().lighter
                        : FluentColors.green.toAccentColor().darker
                    : DataHelper.isDark()
                        ? FluentColors.red.toAccentColor().lighter
                        : FluentColors.red.toAccentColor().darker)),
      ),
      material.DataCell(
        SelectableText(DateFormat('yyyy-MM-dd hh:mm')
            .format(order.date ?? DateTime.now())),
      ),
      material.DataCell(
        SelectableText(
            order.user.value == null ? '' : order.user.value!.fullName ?? ''),
      ),
      // material.DataCell(SelectableText('show_products'.tr()), onTap: () {
      //   viewModel.orderDetails = order;
      //   viewModel.orderPaymentsCubit.change(true);
      // }),
      // material.DataCell(SelectableText('show_payments'.tr()), onTap: () {
      //   viewModel.orderDetails = order;
      //   viewModel.orderPaymentsCubit.change(true);
      // }),
      // ignore: prefer_inlined_adds
    ];
  }

  @override
  State<StatefulWidget> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: widget.viewModel.loadData(),
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: ProgressRing(),
            );
          } else if (snapshot.data == false) {
            return const Center(
              child: ProgressRing(),
            );
          } else {
            return mainWidget(context);
          }
        });
  }

  Widget mainWidget(BuildContext context) {
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
                    height: 20,
                  ),
                  ////////////// * Name * /////////////
                  name(context),
                  const SizedBox(
                    height: 38,
                  ),
                  ////////////// * Orders + Payments * /////////////
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ////////////// * Total Orders Price * /////////////
                      totalOrdersCustomer(context),
                      const SizedBox(
                        width: 10,
                      ),
                      ////////////// * Total Payments Price * /////////////
                      totalPaymentsCustomer(context),
                    ],
                  ),
                  const SizedBox(
                    width: 120,
                  ),

                  ////////////// * Email * /////////////
                  email(context),
                  const SizedBox(
                    height: 25,
                  ),
                  ////////////// * Phone * /////////////
                  phone(context),
                  const SizedBox(
                    height: 50,
                  ),
                  ////////////// * Orders * /////////////
                  Text('order_header'.tr(),
                      style: FluentTheme.of(context).typography.subtitle!),
                  const SizedBox(
                    height: 7,
                  ),
                  ordersCustomerDataTable(context),
                  const SizedBox(
                    height: 50,
                  ),
                  ////////////// * Payments * /////////////
                  Text('payment_header'.tr(),
                      style: FluentTheme.of(context).typography.subtitle!),
                  const SizedBox(
                    height: 7,
                  ),
                  paymentsCustomerDataTable(context),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
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
          Text('customer_details_header'.tr())
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
      child: Text(widget.viewModel.userDetails!.fullName ?? '',
          style: FluentTheme.of(context)
              .typography
              .title!
              .copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget totalOrdersCustomer(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 5,
      runSpacing: 5,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'order_details_total_Order'.tr(),
          style: FluentTheme.of(context)
              .typography
              .subtitle!
              .copyWith(color: FluentTheme.of(context).accentColor),
        ),
        Text(
          '${widget.viewModel.totalOrderPrice.toStringAsFixed(2)} \$',
          style: FluentTheme.of(context).typography.subtitle,
        ),
      ],
    );
  }

  Widget totalPaymentsCustomer(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 5,
      runSpacing: 5,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'order_details_total_payments'.tr(),
          style: FluentTheme.of(context)
              .typography
              .subtitle!
              .copyWith(color: FluentTheme.of(context).accentColor),
        ),
        Text(
          '${widget.viewModel.totalPaymentPrice.toStringAsFixed(2)} \$',
          style: FluentTheme.of(context).typography.subtitle,
        ),
      ],
    );
  }

  Widget email(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.public_email,
        size: 30,
      ),
      title: Text('email'.tr(),
          style: FluentTheme.of(context).typography.subtitle),
      subtitle: Text(
        widget.viewModel.userDetails!.email ?? '',
        style: FluentTheme.of(context).typography.bodyLarge,
      ),
    );
  }

  Widget phone(BuildContext context) {
    return ListTile(
      leading: const Icon(
        FluentIcons.phone,
        size: 30,
      ),
      title: Text('phone'.tr(),
          style: FluentTheme.of(context).typography.subtitle),
      subtitle: Text(
        widget.viewModel.userDetails!.phone ?? '',
        style: FluentTheme.of(context).typography.bodyLarge,
      ),
    );
  }

  Widget ordersCustomerDataTable(BuildContext context) {
    return Center(
      child: BlocList<Order>(
          id: widget.viewModel.dataTableIdOrders,
          isPagination: false,
          isRemoteData: false,
          cubit: widget.viewModel.staterOrders,
          loadMoreCubit: widget.viewModel.loadMoreOrders,
          onRetryFunction: () {
            widget.viewModel.getAllCustomerOrdersStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return widget.dataTableOrders(context);
          }),
    );
  }

  Widget paymentsCustomerDataTable(BuildContext context) {
    return Center(
      child: BlocList<Payment>(
          id: widget.viewModel.dataTableIdPayments,
          isPagination: false,
          isRemoteData: false,
          cubit: widget.viewModel.staterPayments,
          loadMoreCubit: widget.viewModel.loadMorePayments,
          onRetryFunction: () {
            widget.viewModel.getAllCustomerPaymentsStorage(false);
          },
          showDebug: false,
          builder:
              (BlocListType widgetState, ScrollController scrollController) {
            return widget.dataTablePayments(context);
          }),
    );
  }
}

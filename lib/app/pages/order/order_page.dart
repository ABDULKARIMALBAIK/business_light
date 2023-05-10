import 'dart:io';

import 'package:business_light/domain/entity/order.dart';
import 'package:business_light/domain/entity/payment.dart';
import 'package:business_light/domain/entity/product_order.dart';
import 'package:business_light/domain/entity/user.dart';
import 'package:business_light/utils/app_color.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:octo_image/octo_image.dart';

import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import '../../bloc/bloc_state_builder.dart';
import 'package:flutter/material.dart' as material;

import '../../viewmodels/order_view_model.dart';
import '../../widgets/code_dialog.dart';
import '../../widgets/description_dialog.dart';
import '../../widgets/image_dialog.dart';

// ignore: must_be_immutable
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<StatefulWidget> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late OrderViewModel viewModel;

  // Sort items list
  List<String> sortComboBox = [
    'id'.tr(),
    'code'.tr(),
    'order_sorter_totalQty'.tr(),
    'order_sorter_qtyPieces'.tr(),
    // 'order_sorter_pricePieces'.tr(),
    'order_sorter_totalPrice'.tr(),
    'order_sorter_finalPrice'.tr(),
    'date'.tr(),
  ];

  // Order Types list
  List<String> typeComboBox = [
    TypeOrder.negotiation.name.tr(),
    TypeOrder.deal.name.tr(),
    TypeOrder.sell.name.tr(),
    TypeOrder.complete.name.tr()
  ];

  List<bool> showColumns = [for (int i = 0; i < 19; i++) true]; //19

  @override
  void initState() {
    viewModel = getItClient.get<OrderViewModel>();
    viewModel.getAllOrdersStorage(false);
    viewModel.getAllCustomersStorage();
    viewModel.hidePaymentsProducts();
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
                  ////////////// * Expander Filters & Sorting * /////////////
                  expanderFiltersSorting(context),
                  const SizedBox(
                    height: 7,
                  ),

                  ////////////// * Expander Show Columns * /////////////
                  expanderShowsColumn(context),
                  const SizedBox(
                    height: 20,
                  ),
                  ////////////// * Data Table * /////////////
                  ordersDataTable(context),
                  const SizedBox(
                    height: 34,
                  ),

                  ////////////// * Payments Order * /////////////
                  orderPayments(context),
                  const SizedBox(
                    height: 25,
                  ),
                  ////////////// * Products Order * /////////////
                  orderProducts(context),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ));
  }

  //! Order DataTable Widgets
  BlocPaginationDataTable<Order> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Order> dataTable =
        BlocPaginationDataTable<Order>(
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
      'order_title'.tr(),
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
              viewModel.getAllOrdersStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  List<DataColumnsSorter<Order, dynamic>> _columnData() {
    return [
      if (showColumns[0]) ...[
        DataColumnsSorter<Order, num>(
            columnName: 'id'.tr(),
            isNumeric: true,
            onSort: (order) => order.id ?? 0,
            type: 0),
      ],
      if (showColumns[1]) ...[
        DataColumnsSorter<Order, String>(
            columnName: 'code'.tr(),
            isNumeric: false,
            onSort: (order) => order.code ?? '',
            type: ''),
      ],
      if (showColumns[2]) ...[
        DataColumnsSorter<Order, String>(
            columnName: 'description'.tr(),
            isNumeric: false,
            onSort: (order) => order.description ?? '',
            type: ''),
      ],
      if (showColumns[3]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_sorter_totalQty'.tr(),
            isNumeric: true,
            onSort: (order) => order.totalQty ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[4]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_sorter_qtyPieces'.tr(),
            isNumeric: true,
            onSort: (order) => order.qtyPieces ?? 0.0,
            type: 0.0),
      ],
      // if (showColumns[5]) ...[
      //   DataColumnsSorter<Order, dynamic>(
      //       columnName: 'order_sorter_pricePieces'.tr(),
      //       isNumeric: true,
      //       onSort: (order) => order.pricePieces ?? 0.0,
      //       type: 0.0),
      // ],
      if (showColumns[6]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_sorter_totalPrice'.tr(),
            isNumeric: true,
            onSort: (order) => order.totalPrice ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[7]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_chargeCost'.tr(),
            isNumeric: true,
            onSort: (order) => order.chargeCost ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[8]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_otherCost'.tr(),
            isNumeric: true,
            onSort: (order) => order.otherCost ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[9]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_balancer'.tr(),
            isNumeric: true,
            onSort: (order) => order.balancer ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[10]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_discount'.tr(),
            isNumeric: true,
            onSort: (order) => order.discount ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[11]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_sorter_finalPrice'.tr(),
            isNumeric: true,
            onSort: (order) => order.finalPrice ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[12]) ...[
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
      ],
      if (showColumns[13]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'is_paid'.tr(),
            isNumeric: false,
            onSort: (order) =>
                order.finalPrice ?? 0.0, //totalPayments >= order.finalPrice
            type: 0.0),
      ],
      if (showColumns[14]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'date'.tr(),
            isNumeric: false,
            onSort: (order) => order.finalPrice ?? 0.0,
            type: 0.0),
      ],
      if (showColumns[15]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'customer'.tr(),
            isNumeric: false,
            onSort: (order) => order.user.value!.fullName ?? '',
            type: ''),
      ],
      if (showColumns[16]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'product_header'.tr(),
            isNumeric: false,
            onSort: (order) => '',
            type: ''),
      ],
      if (showColumns[17]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'payment_header'.tr(),
            isNumeric: false,
            onSort: (order) => '',
            type: ''),
      ],
      if (showColumns[18]) ...[
        DataColumnsSorter<Order, dynamic>(
            columnName: 'order_type'.tr(),
            isNumeric: false,
            onSort: (order) => '',
            type: ''),
      ],
      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<Order, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  List<material.DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    Order? order = obj as Order?;

    String isPaid = '';
    List<double> payments =
        order!.payments.map<double>((pay) => pay.price ?? 0.0).toList();
    double totalPayments = 0.0;
    for (double payment in payments) {
      totalPayments += payment;
    }

    if (totalPayments >= order.finalPrice!) {
      isPaid = 'is_paid'.tr();
    } else {
      isPaid = 'is_not_paid'.tr();
    }

    return [
      if (showColumns[0]) ...[
        material.DataCell(
          Center(child: SelectableText(order.id.toString())),
        ),
      ],
      if (showColumns[1]) ...[
        material.DataCell(
          Center(child: SelectableText(order.code.toString())),
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
                await viewModel.saveCode(
                    codeText: order.code ?? '', nameFile: 'order'.tr());

                // ignore: use_build_context_synchronously
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'code_created_successfully'.tr(),
                    severity: InfoBarSeverity.success);
              } else if (result == 'print') {
                await viewModel.printCode(order);

                // ignore: use_build_context_synchronously
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'data_save_successfully'.tr(),
                    severity: InfoBarSeverity.success);
              }
            }
          },
        ),
      ],
      if (showColumns[2]) ...[
        material.DataCell(
          Center(
            child: Text(
                '${order.description!.length <= 15 ? order.description! : '${order.description!.substring(0, 15)}...'} '),
          ),
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
      ],
      if (showColumns[3]) ...[
        material.DataCell(
          Center(child: SelectableText(order.totalQty.toString())),
        ),
      ],
      if (showColumns[4]) ...[
        material.DataCell(
          Center(child: SelectableText(order.qtyPieces.toString())),
        ),
      ],
      // if (showColumns[5]) ...[
      //   material.DataCell(
      //     SelectableText(order.pricePieces.toString()),
      //   ),
      // ],
      if (showColumns[6]) ...[
        material.DataCell(
          Center(
              child: SelectableText(
            order.totalPrice.toString(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.magenta.toAccentColor().lighter
                    : FluentColors.magenta.toAccentColor().darker),
          )),
        ),
      ],
      if (showColumns[7]) ...[
        material.DataCell(
          Center(child: SelectableText(order.chargeCost.toString())),
        ),
      ],
      if (showColumns[8]) ...[
        material.DataCell(
          Center(child: SelectableText(order.otherCost.toString())),
        ),
      ],
      if (showColumns[9]) ...[
        material.DataCell(
          Center(child: SelectableText(order.balancer.toString())),
        ),
      ],
      if (showColumns[10]) ...[
        material.DataCell(
          Center(child: SelectableText(order.discount.toString())),
        ),
      ],
      if (showColumns[11]) ...[
        material.DataCell(
          Center(
              child: SelectableText(
            order.finalPrice.toString(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.teal.toAccentColor().lighter
                    : FluentColors.teal.toAccentColor().darker),
          )),
        ),
      ],
      if (showColumns[12]) ...[
        material.DataCell(
          Center(
              child: SelectableText(
            totalPayments.toStringAsFixed(2),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.green.toAccentColor().lighter
                    : FluentColors.green.toAccentColor().darker),
          )),
        ),
      ],
      if (showColumns[13]) ...[
        material.DataCell(Center(
          child: SelectableText(
            isPaid,
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.red.toAccentColor().lighter
                    : FluentColors.red.toAccentColor().darker),
          ),
        ))
      ],
      if (showColumns[14]) ...[
        material.DataCell(
          Center(
            child: SelectableText(DateFormat('yyyy-MM-dd hh:mm')
                .format(order.date ?? DateTime.now())),
          ),
        ),
      ],
      if (showColumns[15]) ...[
        material.DataCell(
          Center(
              child: SelectableText(order.user.value == null
                  ? ''
                  : order.user.value!.fullName ?? '')),
        ),
      ],
      if (showColumns[16]) ...[
        material.DataCell(Center(child: Text('show_products'.tr())), onTap: () {
          if (viewModel.orderDetailsProducts != null) {
            if (order.id == viewModel.orderDetailsProducts!.id) {
              viewModel.orderProductsCubit.update();
            } else {
              viewModel.showProducts(order);
            }
          } else {
            viewModel.showProducts(order);
          }
        }),
      ],
      if (showColumns[17]) ...[
        material.DataCell(Center(child: Text('show_payments'.tr())), onTap: () {
          if (viewModel.orderDetailsPayments != null) {
            if (order.id == viewModel.orderDetailsPayments!.id) {
              viewModel.orderPaymentsCubit.update();
            } else {
              viewModel.showPayments(order);
            }
          } else {
            viewModel.showPayments(order);
          }
        }),
      ],
      if (showColumns[18]) ...[
        material.DataCell(Center(
          child: SelectableText(
            order.type.name.tr(),
            style: FluentTheme.of(context).typography.body!.copyWith(
                color: DataHelper.isDark()
                    ? FluentColors.orange.toAccentColor().lighter
                    : FluentColors.orange.toAccentColor().darker),
          ),
        ))
      ],
      // ignore: prefer_inlined_adds
    ]..add(material.DataCell(Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        children: [
          // Tooltip(
          //   displayHorizontally: false,
          //   message: 'edit'.tr(),
          //   enableFeedback: true,
          //   child: MouseRegion(
          //     cursor: SystemMouseCursors.click,
          //     child: IconButton(
          //       style: ButtonStyle(
          //         backgroundColor: ButtonState.all(
          //             FluentTheme.of(context).scaffoldBackgroundColor),
          //       ),
          //       icon: Padding(
          //         padding: const EdgeInsets.all(3.0),
          //         child: Icon(
          //           FluentIcons.edit,
          //           size: 15,
          //           color: DataHelper.currentColor,
          //         ),
          //       ),
          //       onPressed: () async {
          //         viewModel.navigateEditProduct(product!);
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   width: 4,
          // ),
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
                  await viewModel.deleteOrderStorage(order.id);

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
          Tooltip(
            displayHorizontally: false,
            message: 'print'.tr(),
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
                    FluentIcons.print,
                    size: 15,
                    color: DataHelper.isDark()
                        ? FluentColors.yellow.toAccentColor().lighter
                        : FluentColors.yellow.toAccentColor().darker,
                  ),
                ),
                onPressed: () async {
                  await viewModel.printCode(order);

                  // ignore: use_build_context_synchronously
                  CustomInfoBar.showDefault(
                      context: context,
                      title: 'data_save_successfully'.tr(),
                      severity: InfoBarSeverity.success);
                },
              ),
            ),
          ),
        ],
      )));
  }

  //! Build Widgets
  Widget header(BuildContext context) {
    return PageHeader(
      title: Text('order_header'.tr()),
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
            message: 'order_tooltip_add_order'.tr(),
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
                  viewModel.navigateAddOrder();
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
              size: 17,
              color: DataHelper.getCurrentColor(),
            ),
          ),
          onPressed: () {
            viewModel.getAllOrdersStorage(false);
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
              size: 17,
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

  Widget greaterTotalPrice(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.greaterTotalPriceFilterController,
        placeholder: 'order_placeHolder_greater_totalPrice'.tr(),
        expands: false,
      ),
    );
  }

  Widget lessTotalPrice(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.lessTotalPriceFilterController,
        placeholder: 'order_placeHolder_less_totalPrice'.tr(),
        expands: false,
      ),
    );
  }

  Widget greaterFinalPrice(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.greaterFinalPriceFilterController,
        placeholder: 'order_placeHolder_greater_FinalPrice'.tr(),
        expands: false,
      ),
    );
  }

  Widget lessFinalPrice(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.lessFinalPriceFilterController,
        placeholder: 'order_placeHolder_less_FinalPrice'.tr(),
        expands: false,
      ),
    );
  }

  Widget description(BuildContext context) {
    return SizedBox(
      width: 170,
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

  Widget customerFilter(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<User>(
          placeholder: Text('customer_header'.tr()),
          value: viewModel.filterCustomer,
          items:
              viewModel.customersList.map<ComboBoxItem<User>>((User customer) {
            return ComboBoxItem<User>(
                value: customer, child: Text(customer.fullName!.toString()));
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (User? customer) {
            viewModel.filterCustomer = customer;
            state(() {});
          });
    });
  }

  Widget typeFilter(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('order_type'.tr()),
          value: viewModel.typeFilter.isEmpty ? null : viewModel.typeFilter,
          items: typeComboBox.map<ComboBoxItem<String>>((String type) {
            return ComboBoxItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? type) {
            if (type != null) {
              viewModel.typeFilter = type;
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
            } else if (sort == 'order_sorter_totalQty'.tr()) {
              viewModel.sortContent = 'order_sorter_totalQty'.tr();
              viewModel.sortIndex = 2;
            } else if (sort == 'order_sorter_qtyPieces'.tr()) {
              viewModel.sortContent = 'order_sorter_qtyPieces'.tr();
              viewModel.sortIndex = 3;
            }
            // else if (sort ==
            //     'order_sorter_pricePieces'.tr()) {
            //   viewModel.sortContent =
            //       'order_sorter_pricePieces'.tr();
            //   viewModel.sortIndex = 4;
            // }
            else if (sort == 'order_sorter_totalPrice'.tr()) {
              viewModel.sortContent = 'order_sorter_totalPrice'.tr();
              viewModel.sortIndex = 5;
            } else if (sort == 'order_sorter_finalPrice'.tr()) {
              viewModel.sortContent = 'order_sorter_finalPrice'.tr();
              viewModel.sortIndex = 6;
            }
            //Date
            else {
              viewModel.sortContent = 'date'.tr();
              viewModel.sortIndex = 7;
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

  Widget expanderFiltersSorting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Expander(
        header: Text('filters'.tr()),
        trailing: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 7,
          direction: Axis.horizontal,
          runSpacing: 7,
          children: [
            ////////////// * Filter Button * /////////////
            filterButton(context),
            ////////////// * Reset Button * /////////////
            resetButton(context),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: BlocStateBuilder(
              cubit: viewModel.groupFilterCubit,
              builder: (context, state) {
                return Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    ////////////// * Start Date * /////////////
                    startDate(context),
                    ////////////// * End Date * /////////////
                    endDate(context),

                    ////////////// * Filter Code * /////////////
                    code(context),
                    ////////////// * Filter Greater Total Price * /////////////
                    greaterTotalPrice(context),
                    ////////////// * Filter Less Total Price * /////////////
                    lessTotalPrice(context),
                    ////////////// * Filter Greater Price Pieces * /////////////
                    // SizedBox(
                    //   width: 170,
                    //   child: TextBox(
                    //     autocorrect: true,
                    //     enableIMEPersonalizedLearning: true,
                    //     enableInteractiveSelection: true,
                    //     enableSuggestions: true,
                    //     controller: viewModel
                    //         .greaterPricePiecesFilterController,
                    //     placeholder:
                    //         'order_placeHolder_greater_PricePieces'
                    //             .tr(),
                    //     expands: false,
                    //   ),
                    // ),
                    ////////////// * Filter Less Price Pieces * /////////////
                    // SizedBox(
                    //   width: 170,
                    //   child: TextBox(
                    //     autocorrect: true,
                    //     enableIMEPersonalizedLearning: true,
                    //     enableInteractiveSelection: true,
                    //     enableSuggestions: true,
                    //     controller: viewModel
                    //         .lessPricePiecesFilterController,
                    //     placeholder:
                    //         'order_placeHolder_less_PricePieces'
                    //             .tr(),
                    //     expands: false,
                    //   ),
                    // ),
                    ////////////// * Filter Greater Final Price * /////////////
                    greaterFinalPrice(context),
                    ////////////// * Filter Less Final Price * /////////////
                    lessFinalPrice(context),
                    ////////////// * Filter Description * /////////////
                    description(context),
                    ////////////// * Filter Customers * /////////////
                    customerFilter(context),
                    ////////////// * Filter Type * /////////////
                    typeFilter(context),
                    ////////////// * Sorters * /////////////
                    sorter(context),
                    ////////////// * Checkbox Desc * /////////////
                    checkDesc(context),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget expanderShowsColumn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Expander(
        header: Text('show_columns'.tr()),
        trailing: Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 7,
          direction: Axis.horizontal,
          runSpacing: 7,
          children: [
            ////////////// * Show Columns Button * /////////////
            Tooltip(
              displayHorizontally: false,
              message: 'processing'.tr(),
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
                      FluentIcons.check_list,
                      size: 17,
                      color: DataHelper.getCurrentColor(),
                    ),
                  ),
                  onPressed: () {
                    viewModel.updateShowColumns();
                  },
                ),
              ),
            ),
          ],
        ),
        content: showsColumnsList(context),
      ),
    );
  }

  Widget showsColumnsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 10,
        direction: Axis.horizontal,
        runSpacing: 7,
        children: [
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('id'.tr()),
                checked: showColumns[0],
                onChanged: (checked) {
                  showColumns[0] = !showColumns[0];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('code'.tr()),
                checked: showColumns[1],
                onChanged: (checked) {
                  showColumns[1] = !showColumns[1];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('description'.tr()),
                checked: showColumns[2],
                onChanged: (checked) {
                  showColumns[2] = !showColumns[2];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_sorter_totalQty'.tr()),
                checked: showColumns[3],
                onChanged: (checked) {
                  showColumns[3] = !showColumns[3];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_sorter_qtyPieces'.tr()),
                checked: showColumns[4],
                onChanged: (checked) {
                  showColumns[4] = !showColumns[4];
                  state(() {});
                });
          }),
          // StatefulBuilder(builder: (context, state) {
          //   return Checkbox(
          //       content:
          //           Text('order_sorter_pricePieces'.tr()),
          //       checked: showColumns[5],
          //       onChanged: (checked) {
          //         showColumns[5] =
          //             !showColumns[5];
          //         state(() {});
          //       });
          // }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_sorter_totalPrice'.tr()),
                checked: showColumns[6],
                onChanged: (checked) {
                  showColumns[6] = !showColumns[6];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_chargeCost'.tr()),
                checked: showColumns[7],
                onChanged: (checked) {
                  showColumns[7] = !showColumns[7];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_otherCost'.tr()),
                checked: showColumns[8],
                onChanged: (checked) {
                  showColumns[8] = !showColumns[8];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_balancer'.tr()),
                checked: showColumns[9],
                onChanged: (checked) {
                  showColumns[9] = !showColumns[9];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_discount'.tr()),
                checked: showColumns[10],
                onChanged: (checked) {
                  showColumns[10] = !showColumns[10];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_sorter_finalPrice'.tr()),
                checked: showColumns[11],
                onChanged: (checked) {
                  showColumns[11] = !showColumns[11];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_paymentTotal'.tr()),
                checked: showColumns[12],
                onChanged: (checked) {
                  showColumns[12] = !showColumns[12];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('is_paid'.tr()),
                checked: showColumns[13],
                onChanged: (checked) {
                  showColumns[13] = !showColumns[13];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('date'.tr()),
                checked: showColumns[14],
                onChanged: (checked) {
                  showColumns[14] = !showColumns[14];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('customer'.tr()),
                checked: showColumns[15],
                onChanged: (checked) {
                  showColumns[15] = !showColumns[15];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('product_header'.tr()),
                checked: showColumns[16],
                onChanged: (checked) {
                  showColumns[16] = !showColumns[16];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('payment_header'.tr()),
                checked: showColumns[17],
                onChanged: (checked) {
                  showColumns[17] = !showColumns[17];
                  state(() {});
                });
          }),
          StatefulBuilder(builder: (context, state) {
            return Checkbox(
                content: Text('order_type'.tr()),
                checked: showColumns[18],
                onChanged: (checked) {
                  showColumns[18] = !showColumns[18];
                  state(() {});
                });
          }),
        ],
      ),
    );
  }

  Widget ordersDataTable(BuildContext context) {
    return Center(
      child: BlocStateBuilder(
          cubit: viewModel.showColumnsCubit,
          builder: (context, state) {
            return BlocList<Order>(
                id: viewModel.dataTableId,
                isPagination: false,
                isRemoteData: false,
                cubit: viewModel.stater,
                loadMoreCubit: viewModel.loadMore,
                onRetryFunction: () {
                  viewModel.getAllOrdersStorage(false);
                },
                showDebug: false,
                builder: (BlocListType widgetState,
                    ScrollController scrollController) {
                  return dataTable(context);
                });
          }),
    );
  }

  Widget orderPayments(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: BlocStateBuilder(
        cubit: viewModel.orderPaymentsCubit,
        builder: (context, state) {
          if (viewModel.orderDetailsPayments == null) {
            return const SizedBox.shrink();
          } else {
            return Visibility(
              visible: viewModel.orderPaymentsCubit.getIsChanged,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 0,
                direction: Axis.vertical,
                runSpacing: 0,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 7,
                        direction: Axis.vertical,
                        runSpacing: 7,
                        children: [
                          ////////////// * Title  * /////////////
                          Text(
                            "${'order_payments'.tr()} (${viewModel.orderDetailsPayments!.code})",
                            style: FluentTheme.of(context)
                                .typography
                                .subtitle!
                                .copyWith(color: DataHelper.getCurrentColor()),
                          ),
                          ////////////// * List  * /////////////
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Builder(builder: (context) {
                              if (viewModel
                                  .orderDetailsPayments!.payments.isEmpty) {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 70),
                                      child: Text(
                                        "✨  ${'bloc_widgets_noData'.tr()}  ✨",
                                        style: FluentTheme.of(context)
                                            .typography
                                            .subtitle,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 155,
                                  child: ListView.builder(
                                    itemCount: viewModel
                                        .orderDetailsPayments!.payments.length,
                                    scrollDirection: Axis.horizontal,
                                    addAutomaticKeepAlives: true,
                                    addRepaintBoundaries: true,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    physics:
                                        const material.BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Payment payment = viewModel
                                          .orderDetailsPayments!.payments
                                          .elementAt(index);
                                      return orderPaymentsCard(
                                          context, payment);
                                    },
                                  ),
                                );
                              }
                            }),
                          )
                        ],
                      )),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget orderPaymentsCard(BuildContext context, Payment payment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 6,
          runSpacing: 6,
          children: [
            Text(
              '#${payment.code ?? ''}',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context)
                  .typography
                  .subtitle!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${payment.price.toString()} \$',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context).typography.bodyLarge!.copyWith(),
            ),
            Text(
              '${'date'.tr()}: ${DateFormat('yyyy-MM-dd hh:mm').format(payment.date ?? DateTime.now())}',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context)
                  .typography
                  .bodyLarge!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderProducts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: BlocStateBuilder(
        cubit: viewModel.orderProductsCubit,
        builder: (context, state) {
          if (viewModel.orderDetailsProducts == null) {
            return const SizedBox.shrink();
          } else {
            return Visibility(
              visible: viewModel.orderProductsCubit.getIsChanged,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 0,
                direction: Axis.vertical,
                runSpacing: 0,
                children: [
                  const SizedBox(
                    height: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      spacing: 7,
                      direction: Axis.vertical,
                      runSpacing: 7,
                      children: [
                        ////////////// * Title  * /////////////
                        Text(
                          "${'order_products'.tr()} (${viewModel.orderDetailsProducts!.code})",
                          style: FluentTheme.of(context)
                              .typography
                              .subtitle!
                              .copyWith(color: DataHelper.getCurrentColor()),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        ////////////// * List  * /////////////
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Builder(builder: (context) {
                            if (viewModel
                                .orderDetailsProducts!.products.isEmpty) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 70),
                                    child: Text(
                                      "✨  ${'bloc_widgets_noData'.tr()}  ✨",
                                      style: FluentTheme.of(context)
                                          .typography
                                          .subtitle,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 210,
                                child: ListView.builder(
                                  itemCount: viewModel
                                      .orderDetailsProducts!.products.length,
                                  scrollDirection: Axis.horizontal,
                                  addAutomaticKeepAlives: true,
                                  addRepaintBoundaries: true,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  physics:
                                      const material.BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    ProductOrder product = viewModel
                                        .orderDetailsProducts!.products
                                        .elementAt(index);
                                    return orderProductsCard(context, product);
                                  },
                                ),
                              );
                            }
                          }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget orderProductsCard(BuildContext context, ProductOrder product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              ////////////// * Image * /////////////
              Padding(
                  padding: const EdgeInsets.all(0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (_) => ImageDialog(
                                  urlImage: product.imagePath!,
                                ));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(250),
                        child: SizedBox(
                            width: 80,
                            height: 80,
                            child: OctoImage(
                              image: FileImage(File(product.imagePath!)),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, imageChunk) =>
                                  const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: ProgressRing()),
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
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
                      ),
                    ),
                  )),
              ////////////// * Name + Numeric * /////////////
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                // spacing: 7,
                // runSpacing: 9,
                children: [
                  ////////////// * Name * /////////////
                  Text("${'name'.tr()}: ${product.name ?? ''}",
                      textAlign: TextAlign.start,
                      style: FluentTheme.of(context)
                          .typography
                          .bodyLarge!
                          .copyWith(
                              fontWeight: FontWeight.bold,
                              color: FluentTheme.of(context).accentColor)),
                  const SizedBox(
                    height: 7,
                  ),
                  ////////////// * Packages QTY * /////////////
                  Text(
                      "${'qty_packages'.tr()}:  ${product.packagesQty.toString()}",
                      textAlign: TextAlign.start,
                      style: FluentTheme.of(context).typography.body!),
                  const SizedBox(
                    height: 7,
                  ),
                  ////////////// * Pieces QTY * /////////////
                  Text(
                      "${'order_sorter_qtyPieces'.tr()}:  ${(product.piecesQty).toString()}",
                      textAlign: TextAlign.start,
                      style: FluentTheme.of(context).typography.body!),
                  const SizedBox(
                    height: 7,
                  ),
                  ////////////// * Piece Price * /////////////
                  Text(
                      '${'unit_price'.tr()}:  ${(product.piecePrice ?? 0).toString()} \$',
                      textAlign: TextAlign.start,
                      style: FluentTheme.of(context).typography.body!),
                  const SizedBox(
                    height: 7,
                  ),
                  ////////////// * Total Price * /////////////
                  Text(
                      '${'order_sorter_totalPrice'.tr()}  ${(product.piecesQty! * product.piecePrice!).toString()} \$',
                      textAlign: TextAlign.start,
                      style: FluentTheme.of(context).typography.body!),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

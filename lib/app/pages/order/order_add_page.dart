import 'dart:io';

import 'package:business_light/app/bloc/bloc_state_builder.dart';
import 'package:business_light/utils/app_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/order.dart';
import '../../../domain/entity/user.dart';
import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../viewmodels/order_view_model.dart';
import '../../widgets/image_dialog.dart';

// ignore: must_be_immutable
class OrderAddPage extends StatefulWidget {
  OrderAddPage({
    super.key,
    required this.isEdit,
    required this.pageNum,
    Order? editOrder,
  }) {
    viewModel = getItClient.get<OrderViewModel>();
    viewModel.editOrder = editOrder;
    viewModel.pageNum = pageNum;
    viewModel.initEditOrder(isEdit);
  }

  late OrderViewModel viewModel;
  String isEdit = "false";
  String pageNum;

  @override
  State<StatefulWidget> createState() => _OrderAddPageState();
}

class _OrderAddPageState extends State<OrderAddPage> {
  @override
  void initState() {
    widget.viewModel.addListeners();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
        future: Future.wait([
          widget.viewModel.getAllProductsStorage(),
          widget.viewModel.getAllCustomersStorage()
        ]),
        initialData: const [false],
        builder: (context, snapshot) {
          if (snapshot.data!.first == false) {
            return const Center(child: ProgressRing());
          } else if (widget.viewModel.productsList.isEmpty ||
              widget.viewModel.customersList.isEmpty) {
            return Center(
              child: Text(
                "✨ ${'order_add_no_product_customers'.tr()} ✨",
                style: FluentTheme.of(context).typography.title,
              ),
            );
          } else {
            return ScaffoldPage.scrollable(
              ////////////// * Header * /////////////
              header: header(context),
              children: [
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Code * /////////////
                code(context),
                const SizedBox(
                  height: 15,
                ),
                generateCodeButton(context),
                ////////////// * Description * /////////////
                const SizedBox(
                  height: 32,
                ),
                description(context),
                ////////////// * Date * /////////////
                const SizedBox(
                  height: 32,
                ),
                dateOrder(context),
                ////////////// * Order Type * /////////////
                const SizedBox(
                  height: 32,
                ),
                orderType(context),
                ////////////// * Customer * /////////////
                ...customerOrder(context),
                ////////////// * Products * /////////////
                ...productsOrder(context),
                ////////////// * total Qty * /////////////
                const SizedBox(
                  height: 20,
                ),
                totalQty(context),
                ////////////// * Qty Pieces * /////////////
                const SizedBox(
                  height: 20,
                ),
                qtyPieces(context),
                ////////////// * total Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                totalPrice(context),
                ////////////// * Charge Cost * /////////////
                const SizedBox(
                  height: 20,
                ),
                chargeCost(context),
                ////////////// * Other Cost * /////////////
                const SizedBox(
                  height: 20,
                ),
                otherCost(context),
                ////////////// * Balancer * /////////////
                const SizedBox(
                  height: 20,
                ),
                balancer(context),
                ////////////// * Discount * /////////////
                const SizedBox(
                  height: 20,
                ),
                discount(context),
                ////////////// * Final Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                finalPrice(context),
              ],
            );
          }
        });
  }

  Widget orderCardItem(int index) {
    BlocStateBuilderCubit stater = BlocStateBuilderCubit();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        // width: 400,
        child: Card(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocStateBuilder(
                cubit: stater,
                builder: (context, state) {
                  // ProductOrder productOrder =
                  //     widget.viewModel.selectedProductsList[index];
                  return Wrap(
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
                                          urlImage: widget
                                              .viewModel
                                              .selectedProductsList[index]
                                              .imagePath!,
                                        ));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(250),
                                child: SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: OctoImage(
                                      image: FileImage(File(widget
                                          .viewModel
                                          .selectedProductsList[index]
                                          .imagePath!)),
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, imageChunk) =>
                                              const SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: ProgressRing()),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                  child: Card(
                                        borderRadius:
                                            BorderRadius.circular(250),
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
                          Text(
                              "${'name'.tr()}: ${widget.viewModel.selectedProductsList[index].name ?? ''}",
                              textAlign: TextAlign.start,
                              style: FluentTheme.of(context)
                                  .typography
                                  .bodyLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          FluentTheme.of(context).accentColor)),
                          const SizedBox(
                            height: 7,
                          ),
                          ////////////// * Packages QTY * /////////////
                          Text(
                              "${'qty_packages'.tr()}:  ${widget.viewModel.selectedProductsList[index].packagesQty.toString()}",
                              textAlign: TextAlign.start,
                              style: FluentTheme.of(context).typography.body!),
                          const SizedBox(
                            height: 7,
                          ),
                          ////////////// * Pieces QTY * /////////////
                          Text(
                              "${'order_sorter_qtyPieces'.tr()}:  ${(widget.viewModel.selectedProductsList[index].piecesQty).toString()}",
                              textAlign: TextAlign.start,
                              style: FluentTheme.of(context).typography.body!),
                          const SizedBox(
                            height: 7,
                          ),
                          ////////////// * Piece Price * /////////////
                          Text(
                              '${'unit_price'.tr()}:  ${(widget.viewModel.selectedProductsList[index].piecePrice ?? 0).toString()} \$',
                              textAlign: TextAlign.start,
                              style: FluentTheme.of(context).typography.body!),
                          const SizedBox(
                            height: 7,
                          ),
                          ////////////// * Total Price * /////////////
                          Text(
                              '${'order_sorter_totalPrice'.tr()}  ${(widget.viewModel.selectedProductsList[index].piecesQty! * widget.viewModel.selectedProductsList[index].piecePrice!).toString()} \$',
                              textAlign: TextAlign.start,
                              style: FluentTheme.of(context).typography.body!),
                          const SizedBox(
                            height: 10,
                          ),
                          ////////////// * Numeric * /////////////
                          Wrap(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 10, vertical: 6),
                              //   color: DataHelper.getCurrentColor(),
                              //   child: GestureDetector(
                              //     onTap: () async {
                              //       await widget.viewModel.decreaseOrderProduct(
                              //           productOrder, index);
                              //       stater.update();
                              //     },
                              //     child: const MouseRegion(
                              //       cursor: SystemMouseCursors.click,
                              //       child: Center(
                              //         child: Icon(
                              //           FluentIcons.skype_minus,
                              //           size: 12,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              FilledButton(
                                child: const Icon(
                                  FluentIcons.skype_minus,
                                  size: 12,
                                ),
                                onPressed: () async {
                                  await widget.viewModel.decreaseOrderProduct(
                                      widget.viewModel
                                          .selectedProductsList[index],
                                      index);
                                  stater.update();
                                },
                              ),
                              Text(
                                  '${widget.viewModel.selectedProductsList[index].packagesQty} / ${widget.viewModel.selectedProductsList[index].packagesQtyStore}',
                                  textAlign: TextAlign.center,
                                  style:
                                      FluentTheme.of(context).typography.body),
                              FilledButton(
                                child: const Icon(
                                  FluentIcons.add,
                                  size: 12,
                                ),
                                onPressed: () async {
                                  await widget.viewModel.increaseOrderProduct(
                                      widget.viewModel
                                          .selectedProductsList[index],
                                      index);
                                  stater.update();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                      ////////////// * Delete * /////////////
                      const SizedBox(
                        width: 20,
                      ),
                      IconButton(
                          icon: Icon(
                            FluentIcons.delete,
                            color: DataHelper.isDark()
                                ? FluentColors.red.toAccentColor().lighter
                                : FluentColors.red.toAccentColor().darker,
                            size: 30,
                          ),
                          onPressed: () async {
                            await widget.viewModel.deleteProductCart(
                                widget.viewModel.selectedProductsList[index],
                                index);
                            widget.viewModel.selectedProductsCubit.update();
                          })
                    ],
                  );
                }),
          ),
        ),
      ),
    );
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
              ? 'order_edit_header'.tr()
              : 'order_add_header'.tr()),
        ],
      ),
      commandBar: Wrap(alignment: WrapAlignment.end, children: [
        ////////////// * Save/Edit Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: widget.isEdit == 'true'
                ? 'order_tooltip_editButton'.tr()
                : 'order_tooltip_saveButton'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: () async {
                  //! Edit
                  if (widget.isEdit == 'true') {
                    // await widget.viewModel.editStoreStorage();
                    // // ignore: use_build_context_synchronously
                    // CustomInfoBar.showDefault(
                    //     context: context,
                    //     title: 'edited_successfully'.tr(),
                    //     severity: InfoBarSeverity.success);
                    // Future.delayed(const Duration(milliseconds: 1000));
                    // // ignore: use_build_context_synchronously
                    // if (context.canPop()) {
                    //   // ignore: use_build_context_synchronously
                    //   context.pop<int>(int.parse(widget.viewModel.pageNum));
                    // }
                  }
                  //! Save
                  else {
                    await widget.viewModel.addOrderStorage();
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

  Widget code(BuildContext context) {
    return InfoLabel(
      label: 'order_add_infoBar_code'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          enabled: false,
          controller: widget.viewModel.codeNewEditController,
          placeholder: 'code'.tr(),
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

  Widget description(BuildContext context) {
    return InfoLabel(
      label: 'order_add_infoBar_description'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          maxLines: 3,
          controller: widget.viewModel.descriptionNewEditController,
          placeholder: 'description'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget dateOrder(BuildContext context) {
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

  Widget orderType(BuildContext context) {
    return InfoLabel(
      label: 'order_add_infoBar_comboBox'.tr(),
      child: StatefulBuilder(builder: (context, state) {
        return ComboBox<String>(
            placeholder: Text('order'.tr()),
            value: widget.viewModel.newEditComboOrderType.isEmpty
                ? null
                : widget.viewModel.newEditComboOrderType,
            items: [
              TypeOrder.negotiation.name.tr(),
              TypeOrder.deal.name.tr(),
              TypeOrder.sell.name.tr(),
              TypeOrder.complete.name.tr(),
            ].map<ComboBoxItem<String>>((String type) {
              return ComboBoxItem<String>(value: type, child: Text(type));
            }).toList(),
            iconEnabledColor: FluentTheme.of(context).accentColor,
            onChanged: (String? type) {
              widget.viewModel.newEditComboOrderType = type ?? '';
              state(() {});
            });
      }),
    );
  }

  List<Widget> customerOrder(BuildContext context) {
    if (widget.isEdit != 'true' && widget.viewModel.customersList.isNotEmpty) {
      return [
        const SizedBox(
          height: 32,
        ),
        InfoLabel(
          label: 'order_add_infoBar_comboBox_customer'.tr(),
          child: StatefulBuilder(builder: (context, state) {
            return ComboBox<User>(
                placeholder: Text('customer'.tr()),
                value: widget.viewModel.customerOrder,
                items: widget.viewModel.customersList
                    .map<ComboBoxItem<User>>((User customer) {
                  return ComboBoxItem<User>(
                      value: customer,
                      child: Text(customer.fullName!.toString()));
                }).toList(),
                iconEnabledColor: FluentTheme.of(context).accentColor,
                onChanged: (User? customer) {
                  widget.viewModel.customerOrder = customer;
                  state(() {});
                });
          }),
        ),
      ];
    } else {
      return [];
    }
  }

  List<Widget> productsOrder(BuildContext context) {
    if (widget.isEdit != 'true' && widget.viewModel.productsList.isNotEmpty) {
      return [
        const SizedBox(
          height: 40,
        ),
        Text(
          'product_header'.tr(),
          style: FluentTheme.of(context)
              .typography
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          direction: Axis.horizontal,
          runSpacing: 10,
          children: [
            ////////////// * Name Search * /////////////
            searchNameProduct(context),
            ////////////// * Code Search * /////////////
            searchCodeProduct(context),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        listSelectedProducts(context),
      ];
    } else {
      return [];
    }
  }

  Widget searchNameProduct(BuildContext context) {
    return SizedBox(
      width: 260,
      child: AutoSuggestBox(
        leadingIcon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(FluentIcons.product),
        ),
        controller: widget.viewModel.searchProductNameNewEditController,
        unfocusedColor: Colors.transparent,
        items: widget.viewModel.productsList.map((product) {
          final productName = product.name;
          return AutoSuggestBoxItem(
            label: productName ?? '',
            value: productName,
            onSelected: () async {
              await widget.viewModel.addProductCart(product);
              widget.viewModel.searchProductNameNewEditController.clear();
              widget.viewModel.selectedProductsCubit.update();
            },
          );
        }).toList(),
        trailingIcon: IgnorePointer(
          child: IconButton(
            onPressed: () {},
            icon: const Icon(FluentIcons.search),
          ),
        ),
        placeholder: 'order_add_autoSearch_name'.tr(),
      ),
    );
  }

  Widget searchCodeProduct(BuildContext context) {
    return SizedBox(
      width: 260,
      child: AutoSuggestBox(
        leadingIcon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(FluentIcons.code),
        ),
        controller: widget.viewModel.searchProductCodeNewEditController,
        unfocusedColor: Colors.transparent,
        items: widget.viewModel.productsList.map((product) {
          final productCode = product.code;
          return AutoSuggestBoxItem(
            label: productCode ?? '',
            value: productCode,
            onSelected: () async {
              await widget.viewModel.addProductCart(product);
              widget.viewModel.searchProductCodeNewEditController.clear();
              widget.viewModel.selectedProductsCubit.update();
            },
          );
        }).toList(),
        trailingIcon: IgnorePointer(
          child: IconButton(
            onPressed: () {},
            icon: const Icon(FluentIcons.search),
          ),
        ),
        placeholder: 'order_add_autoSearch_name'.tr(),
      ),
    );
  }

  Widget listSelectedProducts(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: BlocStateBuilder(
          cubit: widget.viewModel.selectedProductsCubit,
          builder: (context, state) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 230,
              child: ListView.builder(
                // itemExtent: 250,
                addRepaintBoundaries: true,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                scrollDirection: Axis.horizontal,
                itemCount: widget.viewModel.selectedProductsList.length,
                itemBuilder: (context, index) {
                  return orderCardItem(index);
                },
              ),
            );
          }),
    );
  }

  Widget totalQty(BuildContext context) {
    return InfoLabel(
      label: 'order_sorter_totalQty'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.totalQtyNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'total_qty'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget qtyPieces(BuildContext context) {
    return InfoLabel(
      label: 'order_sorter_qtyPieces'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.qtyPiecesNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'qty_units'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget totalPrice(BuildContext context) {
    return InfoLabel(
      label: 'order_sorter_totalPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.totalPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'total_price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget chargeCost(BuildContext context) {
    return InfoLabel(
      label: 'order_chargeCost'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.chargeCostNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: '0.0',
          expands: false,
        ),
      ),
    );
  }

  Widget otherCost(BuildContext context) {
    return InfoLabel(
      label: 'order_otherCost'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.otherCostNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: '0.0',
          expands: false,
        ),
      ),
    );
  }

  Widget balancer(BuildContext context) {
    return InfoLabel(
      label: 'order_add_balancer'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.balancerNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: '0.0',
          expands: false,
        ),
      ),
    );
  }

  Widget discount(BuildContext context) {
    return InfoLabel(
      label: 'order_discount'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.discountNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: '0.0',
          expands: false,
        ),
      ),
    );
  }

  Widget finalPrice(BuildContext context) {
    return InfoLabel(
      label: 'order_sorter_finalPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.finalPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: '0.0',
          expands: false,
        ),
      ),
    );
  }
}

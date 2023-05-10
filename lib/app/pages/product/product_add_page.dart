import 'dart:io';

import 'package:business_light/app/bloc/bloc_state_builder.dart';
import 'package:business_light/app/viewmodels/product_view_model.dart';
import 'package:business_light/domain/entity/product.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/brand.dart';
import '../../../domain/entity/status.dart';
import '../../../domain/entity/store.dart';
import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';

// ignore: must_be_immutable
class ProductAddPage extends StatefulWidget {
  ProductAddPage({
    super.key,
    required this.isEdit,
    required this.pageNum,
    Product? editProduct,
  }) {
    viewModel = getItClient.get<ProductViewModel>();
    viewModel.editProduct = editProduct;
    viewModel.pageNum = pageNum;
  }

  late ProductViewModel viewModel;
  String isEdit = "false";
  String pageNum;

  @override
  State<StatefulWidget> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  @override
  void initState() {
    widget.viewModel.addListeners();
    super.initState();
  }

  @override
  void dispose() {
    // widget.viewModel.removeListeners();
    // widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<bool>>(
        future: Future.wait(
            [widget.viewModel.getAllBrands(), widget.viewModel.getAllStores()]),
        initialData: const [false],
        builder: (context, snapshot) {
          if (snapshot.data!.first == false) {
            return const Center(child: ProgressRing());
          }
          widget.viewModel.initEditProduct(widget.isEdit);
          return DynMouseScroll(
            builder: (context, scrollController, physics) =>
                ScaffoldPage.scrollable(
              scrollController: scrollController,
              ////////////// * Header * /////////////
              header: header(context),
              children: [
                const SizedBox(
                  height: 20,
                ),
                ////////////// * Image * /////////////
                image(context),
                ////////////// * Name * /////////////
                const SizedBox(
                  height: 20,
                ),
                name(context),
                ////////////// * Code * /////////////
                const SizedBox(
                  height: 20,
                ),
                code(context),
                const SizedBox(
                  height: 7,
                ),
                generateCodeButton(context),
                ////////////// * SKU * /////////////
                const SizedBox(
                  height: 25,
                ),
                sku(context),
                ////////////// * Description * /////////////
                const SizedBox(
                  height: 20,
                ),
                description(context),
                ////////////// * Weight * /////////////
                const SizedBox(
                  height: 20,
                ),
                weight(context),
                ////////////// * Original Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                originalPrice(context),
                ////////////// * Costs Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                costsPrice(context),
                ////////////// * Profit * /////////////
                const SizedBox(
                  height: 20,
                ),
                profit(context),
                ////////////// * Old Final Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                oldFinalPrice(context),
                ////////////// * New Final Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                newFinalPrice(context),
                ////////////// * QTY Package * /////////////
                const SizedBox(
                  height: 20,
                ),
                qtyPackages(context),
                ////////////// * Old Package Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                oldPackagePrice(context),
                ////////////// * New Package Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                newPackagePrice(context),
                ////////////// * Total Packages * /////////////
                const SizedBox(
                  height: 20,
                ),
                totalPackages(context),
                ////////////// * Total Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                totalPrice(context),
                ////////////// * Date * /////////////
                const SizedBox(
                  height: 20,
                ),
                dateProduct(context),
                ////////////// * Paid Total Packages Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                paidTotalPackages(context),
                ////////////// * Paid Total Units Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                paidTotalUnits(context),
                ////////////// * Paid Total Price * /////////////
                const SizedBox(
                  height: 20,
                ),
                paidTotalPrice(context),
                ////////////// * Status * /////////////
                const SizedBox(
                  height: 20,
                ),
                status(context),
                ////////////// * Brands * /////////////
                const SizedBox(
                  height: 20,
                ),
                brands(context),
                ////////////// * Stores * /////////////
                const SizedBox(
                  height: 20,
                ),
                stores(context),
              ],
            ),
          );
        });
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
              ? 'product_edit_header'.tr()
              : 'product_add_header'.tr()),
        ],
      ),
      commandBar: Wrap(alignment: WrapAlignment.end, children: [
        ////////////// * Save/Edit Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: widget.isEdit == 'true'
                ? 'product_tooltip_editButton'.tr()
                : 'product_tooltip_saveButton'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: () async {
                  //! Edit
                  if (widget.isEdit == 'true') {
                    if (widget.viewModel.newEditBrand == null ||
                        widget.viewModel.newEditStore == null) {
                      return;
                    }
                    await widget.viewModel.editProductStorage();
                    // ignore: use_build_context_synchronously
                    CustomInfoBar.showDefault(
                        context: context,
                        title: 'edited_successfully'.tr(),
                        severity: InfoBarSeverity.success);
                    await Future.delayed(const Duration(milliseconds: 1000));
                    // ignore: use_build_context_synchronously
                    if (context.canPop()) {
                      // ignore: use_build_context_synchronously
                      context.pop<int>(int.parse(widget.viewModel.pageNum));
                    }
                  }
                  //! Save
                  else {
                    if (widget.viewModel.newEditBrand == null ||
                        widget.viewModel.newEditStore == null) {
                      return;
                    }
                    await widget.viewModel.addProductStorage();
                    // ignore: use_build_context_synchronously
                    CustomInfoBar.showDefault(
                        context: context,
                        title: 'inserted_successfully'.tr(),
                        severity: InfoBarSeverity.success);
                    await Future.delayed(const Duration(milliseconds: 1000));

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

  Widget image(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: InfoLabel(
          label: 'product_add_infoBar_image'.tr(),
          child: BlocStateBuilder(
            cubit: widget.viewModel.imageUpdateCubit,
            builder: (context, state) {
              return widget.viewModel.imagePathNewEdit.isEmpty
                  ? SizedBox(
                      width: 200,
                      height: 200,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: Card(
                              child: Center(
                            child: Icon(
                              FluentIcons.product_release,
                              size: 40,
                              color: FluentTheme.of(context).accentColor,
                            ),
                          )),
                          onTap: () {
                            widget.viewModel.pickImage();
                          },
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 200,
                      height: 200,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: OctoImage(
                            image: FileImage(
                                File(widget.viewModel.imagePathNewEdit)),
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder: (context, imageChunk) =>
                                const SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: ProgressRing()),
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                    child: Card(
                              borderRadius: BorderRadius.circular(250),
                              child: const Center(
                                child: Icon(
                                  FluentIcons.error,
                                  size: 40,
                                ),
                              ),
                            )),
                          ),
                          onTap: () {
                            widget.viewModel.pickImage();
                          },
                        ),
                      ),
                    );
            },
          ),
        ));
  }

  Widget name(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_name'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.nameNewEditController,
          placeholder: 'name'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget code(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_code'.tr(),
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

  Widget sku(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_sku'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.skuNewEditController,
          placeholder: 'sku'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget description(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_description'.tr(),
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

  Widget weight(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_weight'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.weightNewEditController,
          placeholder: 'weight'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget originalPrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_originalPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.originalPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'original_price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget costsPrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_costsPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.costsPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'costs_price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget profit(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_profit'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.profitNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'profit'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget oldFinalPrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_oldFinalPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.oldFinalPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'old_final_price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget newFinalPrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_newFinalPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.newFinalPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'new_final_price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget qtyPackages(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_qtyPackage'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.qtyPackageNewEditController,
          // suffix: IgnorePointer(
          //     child: Icon(
          //   FluentIcons.circle_dollar,
          //   color: FluentTheme.of(context).accentColor,
          // )),
          placeholder: 'qty_package'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget oldPackagePrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_oldFinalPricePackage'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.oldFinalPricePackageNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'old_final_price_package'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget newPackagePrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_newFinalPricePackage'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.newFinalPricePackageNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'new_final_price_package'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget totalPackages(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_totalPackages'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.totalPackagesNewEditController,
          // suffix: IgnorePointer(
          //     child: Icon(
          //   FluentIcons.circle_dollar,
          //   color: FluentTheme.of(context).accentColor,
          // )),
          // placeholder: 'qty_packages'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget totalPrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_totalPrice'.tr(),
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

  Widget dateProduct(BuildContext context) {
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

  Widget paidTotalPackages(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_paidTotalPackages'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.paidTotalPackagesNewEditController,
          // suffix: IgnorePointer(
          //     child: Icon(
          //   FluentIcons.circle_dollar,
          //   color: FluentTheme.of(context).accentColor,
          // )),
          placeholder: 'amount'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget paidTotalUnits(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_paidTotalUnits'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.paidTotalUnitsNewEditController,
          // suffix: IgnorePointer(
          //     child: Icon(
          //   FluentIcons.circle_dollar,
          //   color: FluentTheme.of(context).accentColor,
          // )),
          placeholder: 'amount'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget paidTotalPrice(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_paidTotalPrice'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.paidTotalPriceNewEditController,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          placeholder: 'price'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget status(BuildContext context) {
    return InfoLabel(
      label: 'store_add_infoBar_comboBox'.tr(),
      child: StatefulBuilder(builder: (context, state) {
        return ComboBox<String>(
            placeholder: Text('status'.tr()),
            value: widget.viewModel.newEditComboStatus.isEmpty
                ? null
                : widget.viewModel.newEditComboStatus,
            items: [Status.active.name.tr(), Status.inactive.name.tr()]
                .map<ComboBoxItem<String>>((String status) {
              return ComboBoxItem<String>(value: status, child: Text(status));
            }).toList(),
            iconEnabledColor: FluentTheme.of(context).accentColor,
            onChanged: (String? status) {
              widget.viewModel.newEditComboStatus = status ?? '';
              state(() {});
            });
      }),
    );
  }

  Widget brands(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_brands'.tr(),
      child: StatefulBuilder(builder: (context, state) {
        return ComboBox<Brand>(
            placeholder: Text('brand'.tr()),
            value: widget.viewModel.newEditBrand,
            items: widget.viewModel.brandsList
                .map<ComboBoxItem<Brand>>((Brand brand) {
              return ComboBoxItem<Brand>(
                  value: brand, child: Text(brand.name ?? ''));
            }).toList(),
            iconEnabledColor: FluentTheme.of(context).accentColor,
            onChanged: (Brand? brand) {
              widget.viewModel.newEditBrand = brand;
              state(() {});
            });
      }),
    );
  }

  Widget stores(BuildContext context) {
    return InfoLabel(
      label: 'product_add_infoBar_stores'.tr(),
      child: StatefulBuilder(builder: (context, state) {
        return ComboBox<Store>(
            placeholder: Text('store'.tr()),
            value: widget.viewModel.newEditStore,
            items: widget.viewModel.storesList
                .map<ComboBoxItem<Store>>((Store store) {
              return ComboBoxItem<Store>(
                  value: store, child: Text(store.name ?? ''));
            }).toList(),
            iconEnabledColor: FluentTheme.of(context).accentColor,
            onChanged: (Store? store) {
              widget.viewModel.newEditStore = store;
              state(() {});
            });
      }),
    );
  }
}

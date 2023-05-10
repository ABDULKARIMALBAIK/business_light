import 'dart:io';

import 'package:business_light/app/viewmodels/product_view_model.dart';
import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/entity/product.dart';
import 'package:business_light/domain/entity/store.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/status.dart';
import '../../../services/di/injection.dart';
import '../../../utils/app_color.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_list.dart';
import '../../bloc/bloc_pagination_datatable.dart';
import 'package:flutter/material.dart' as material;
import '../../bloc/bloc_state_builder.dart';
import '../../widgets/code_dialog.dart';
import '../../widgets/description_dialog.dart';
import '../../widgets/image_dialog.dart';

// ignore: must_be_immutable
class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late final ProductViewModel viewModel;

  // Sort item list
  List<String> sortComboBox = [
    'id'.tr(),
    'name'.tr(),
    'code'.tr(),
    'sku'.tr(),
    'unit_price'.tr(),
    'package_price'.tr(),
    'qty_units'.tr(),
    'qty_packages'.tr(),
    'paid_qty_packages'.tr(),
    'total_packages_price'.tr(),
    'paid_units_qty'.tr(),
    'paid_total_packages_price'.tr(),
    'date'.tr(),
    'status'.tr(),
  ];

  // status types list
  List<String> statusComboBox = [
    Status.active.name.tr(),
    Status.inactive.name.tr()
  ];

  List<bool> showColumns = [for (int i = 0; i < 25; i++) true]; //24

  @override
  void initState() {
    viewModel = getItClient.get<ProductViewModel>();
    viewModel.getAllProductsStorage(false);
    viewModel.getAllBrands();
    viewModel.getAllStores();
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
                  ////////////// * Expander Filters * /////////////
                  expanderFiltersSorting(context),
                  ////////////// * Expander Show Columns * /////////////
                  const SizedBox(
                    height: 7,
                  ),
                  showColumnsDataTable(context),
                  ////////////// * DataTable * /////////////
                  const SizedBox(
                    height: 20,
                  ),
                  dataTableWidget(context),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ));
  }

  //! Products DataTable Widgets
  BlocPaginationDataTable<Product> dataTable(BuildContext context) {
    final BlocPaginationDataTable<Product> dataTable =
        BlocPaginationDataTable<Product>(
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
      'product_title'.tr(),
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
              viewModel.getAllProductsStorage(true);
              viewModel.resetFilters();
            },
          ),
        ),
      ),
    ];
  }

  List<DataColumnsSorter<Product, dynamic>> _columnData() {
    return [
      if (showColumns[0]) ...[
        DataColumnsSorter<Product, num>(
            columnName: 'id'.tr(), isNumeric: true, type: 0),
      ],
      if (showColumns[18]) ...[
        DataColumnsSorter<Product, dynamic>(
            columnName: 'image_path'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[1]) ...[
        DataColumnsSorter<Product, String>(
            columnName: 'name'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[2]) ...[
        DataColumnsSorter<Product, String>(
            columnName: 'code'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[3]) ...[
        DataColumnsSorter<Product, String>(
            columnName: 'sku'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[4]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'weight'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[5]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'original_price'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[6]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'costs_price'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[7]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'profit'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[8]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'old_final_price'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[9]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'new_final_price'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[10]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'qty_units'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[11]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'old_final_price_package'.tr(),
            isNumeric: true,
            type: ''),
      ],
      if (showColumns[12]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'new_final_price_package'.tr(),
            isNumeric: true,
            type: ''),
      ],
      if (showColumns[13]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'qty_packages'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[14]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'paid_qty_packages'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[15]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'paid_units_qty'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[16]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'total_packages_price'.tr(), isNumeric: true, type: ''),
      ],
      if (showColumns[17]) ...[
        DataColumnsSorter<Product, double>(
            columnName: 'paid_total_packages_price'.tr(),
            isNumeric: true,
            type: ''),
      ],

      if (showColumns[19]) ...[
        DataColumnsSorter<Product, dynamic>(
            columnName: 'description'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[20]) ...[
        DataColumnsSorter<Product, String>(
            columnName: 'date'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[21]) ...[
        DataColumnsSorter<Product, String>(
            columnName: 'brand'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[22]) ...[
        DataColumnsSorter<Product, String>(
            columnName: 'store'.tr(), isNumeric: false, type: ''),
      ],
      if (showColumns[23]) ...[
        DataColumnsSorter<Product, dynamic>(
            columnName: 'status'.tr(),
            isNumeric: false,
            onSort: null,
            type: Status.inactive),
      ],

      // ignore: prefer_inlined_adds
    ]..add(DataColumnsSorter<Product, dynamic>(
        columnName: 'actions'.tr(), isNumeric: false, onSort: null, type: 0));
  }

  List<material.DataCell> _cellsPerRow(BuildContext context, dynamic obj) {
    Product? product = obj as Product?;
    return [
      if (showColumns[0]) ...[
        material.DataCell(
          Center(child: SelectableText(product!.id.toString())),
        ),
      ],
      if (showColumns[18]) ...[
        material.DataCell(
            product!.imagePath!.isEmpty
                ? Center(
                    child: Card(
                        borderRadius: BorderRadius.circular(250),
                        child: const Center(
                          child: Icon(
                            FluentIcons.product_release,
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
                          image: FileImage(File(product.imagePath!)),
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
            onTap: product.imagePath!.isEmpty
                ? null
                : () async {
                    await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) => ImageDialog(
                              urlImage: product.imagePath!,
                            ));
                  }),
      ],
      if (showColumns[1]) ...[
        material.DataCell(
          Center(child: SelectableText(product!.name ?? '')),
        ),
      ],
      if (showColumns[2]) ...[
        material.DataCell(
          Center(child: SelectableText(product!.code ?? '')),
          onTap: () async {
            String? result = await showDialog<String>(
                context: context,
                barrierDismissible: true,
                builder: (_) => CodeDialog(
                      name: product.name ?? '',
                      code: product.code ?? '',
                    ));

            if (result != null) {
              if (result == 'save') {
                await viewModel.saveCode(
                    codeText: product.code ?? '', nameFile: product.name ?? '');

                // ignore: use_build_context_synchronously
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'code_created_successfully'.tr(),
                    severity: InfoBarSeverity.success);
              } else if (result == 'print') {
                await viewModel.printCode(product);

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
      if (showColumns[3]) ...[
        material.DataCell(
          Center(child: SelectableText(product!.sku ?? '')),
        ),
      ],
      if (showColumns[4]) ...[
        material.DataCell(
          Center(child: SelectableText('${product!.weight}')),
        ),
      ],
      if (showColumns[5]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.originalPrice} \$',
              style: FluentTheme.of(context).typography.body!.copyWith(
                  color: DataHelper.isDark()
                      ? FluentColors.purple.toAccentColor().lighter
                      : FluentColors.purple.toAccentColor().darker),
            ),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[6]) ...[
        material.DataCell(
          Center(
            child: SelectableText('${product!.costsPrice} \$'),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[7]) ...[
        material.DataCell(
          Center(
            child: SelectableText('${product!.profit} \$'),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[8]) ...[
        material.DataCell(
          Center(
            child: SelectableText('${product!.oldFinalPrice} \$'),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[9]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.newFinalPrice} \$',
              style: FluentTheme.of(context).typography.body!.copyWith(
                  color: (product.newFinalPrice! >= product.oldFinalPrice!)
                      ? DataHelper.isDark()
                          ? FluentColors.green.toAccentColor().lighter
                          : FluentColors.green.toAccentColor().darker
                      : DataHelper.isDark()
                          ? FluentColors.red.toAccentColor().lighter
                          : FluentColors.red.toAccentColor().darker),
            ),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[10]) ...[
        material.DataCell(
          Center(child: SelectableText('${product!.qtyPackage}')),
        ),
      ],
      if (showColumns[11]) ...[
        material.DataCell(
          Center(
            child: SelectableText('${product!.oldFinalPricePackage} \$'),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[12]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.newFinalPricePackage} \$',
              style: FluentTheme.of(context).typography.body!.copyWith(
                  color: (product.newFinalPricePackage! >=
                          product.oldFinalPricePackage!)
                      ? DataHelper.isDark()
                          ? FluentColors.green.toAccentColor().lighter
                          : FluentColors.green.toAccentColor().darker
                      : DataHelper.isDark()
                          ? FluentColors.red.toAccentColor().lighter
                          : FluentColors.red.toAccentColor().darker),
            ),
          ), //! change to usd or other currencies !!!
        ),
      ],
      if (showColumns[13]) ...[
        material.DataCell(
          Center(child: SelectableText('${product!.totalPackages}')),
        ),
      ],
      if (showColumns[14]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.paidTotalPackages}',
              style: FluentTheme.of(context).typography.body!.copyWith(
                  color: DataHelper.isDark()
                      ? FluentColors.blue.toAccentColor().lighter
                      : FluentColors.blue.toAccentColor().darker),
            ),
          ),
        ),
      ],
      if (showColumns[15]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.paidTotalUnits}',
              style: FluentTheme.of(context).typography.body!.copyWith(
                  color: DataHelper.isDark()
                      ? FluentColors.blue.toAccentColor().lighter
                      : FluentColors.blue.toAccentColor().darker),
            ),
          ),
        ),
      ],
      if (showColumns[16]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.totalPrice} \$',
            ),
          ),
        ), //! change to usd or other currencies !!!
      ],
      if (showColumns[17]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
              '${product!.paidTotalPrice} \$',
              style: FluentTheme.of(context).typography.body!.copyWith(
                  color: DataHelper.isDark()
                      ? FluentColors.orange.toAccentColor().lighter
                      : FluentColors.orange.toAccentColor().darker),
            ),
          ),
        ), //! change to usd or other currencies !!!
      ],
      if (showColumns[19]) ...[
        material.DataCell(
          Center(
            child: Text(
                '${product!.description!.length <= 15 ? product.description! : '${product.description!.substring(0, 15)}...'} '),
          ),
          onTap: () async {
            await showDialog<String>(
                context: context,
                barrierDismissible: true,
                builder: (_) => DescriptionDialog(
                      name: product.name ?? '',
                      description: product.description ?? '',
                    ));
          },
        ),
      ],
      if (showColumns[20]) ...[
        material.DataCell(
          Center(
            child: SelectableText(DateFormat(('yyyy-MM-dd hh:mm'))
                .format(product!.date!)
                .toString()),
          ),
        ),
      ],
      if (showColumns[21]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
                '${product!.brand.value != null ? product.brand.value!.name : 'unKnown'}'),
          ),
        ),
      ],
      if (showColumns[22]) ...[
        material.DataCell(
          Center(
            child: SelectableText(
                '${product!.store.value != null ? product.store.value!.name : 'unKnown'}'),
          ),
        ),
      ],
      if (showColumns[23]) ...[
        material.DataCell(
          Center(
            child: SelectableText(product!.status.name,
                style: FluentTheme.of(context).typography.body!.copyWith(
                    color: (product.status.name.tr() == Status.active.name.tr())
                        ? DataHelper.isDark()
                            ? FluentColors.green.toAccentColor().lighter
                            : FluentColors.green.toAccentColor().darker
                        : DataHelper.isDark()
                            ? FluentColors.red.toAccentColor().lightest
                            : FluentColors.red.toAccentColor().darker)),
          ),
        ),
      ],

      // ignore: prefer_inlined_adds
    ]..add(material.DataCell(Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 0,
        children: [
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
                  viewModel.navigateEditProduct(product!);
                },
              ),
            ),
          ),
          const SizedBox(
            width: 4,
          ),
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
                  await viewModel.deleteProductStorage(product!.id);

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
                  await viewModel.printCode(product!);

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
      title: Text('product_header'.tr()),
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
            message: 'product_tooltip_add_store'.tr(),
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
                  viewModel.navigateAddProduct();
                },
              ),
            ),
          ),
        )
      ]),
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
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            direction: Axis.vertical,
            runSpacing: 7,
            children: [
              ////////////// * Filters One Control * /////////////
              filtersSectionOne(context),

              ////////////// * Filters Two Controls * /////////////
              filtersSectionTwo(context),
            ],
          ),
        ),
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
              size: 17,
              color: DataHelper.getCurrentColor(),
            ),
          ),
          onPressed: () {
            viewModel.getAllProductsStorage(false);
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

  Widget filtersSectionOne(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: BlocStateBuilder(
          cubit: viewModel.groupFilterOneControllerCubit,
          builder: (context, state) {
            return Wrap(
              direction: Axis.vertical,
              spacing: 15,
              runSpacing: 15,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                ////////////// * Filter Name , Code , SKU * /////////////
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    ////////////// * Filter Name * /////////////
                    name(context),
                    ////////////// * Filter Code * /////////////
                    code(context),
                    ////////////// * Filter SKU * /////////////
                    sku(context),
                  ],
                ),
                ////////////// * Filter Description , Pieces Quantity , Package Quantity * /////////////
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    ////////////// * Filter Description * /////////////
                    description(context),
                    ////////////// * Filter Pieces Quantity * /////////////
                    piecesQty(context),
                    ////////////// * Filter Package Quantity * /////////////
                    packagesQty(context),
                  ],
                ),
                ////////////// * Filter Paid Package Quantity , Units Quantity * /////////////
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    ////////////// * Filter Paid Package Quantity * /////////////
                    paidPackagesQty(context),
                    ////////////// * Filter Units Quantity * /////////////
                    unitsQty(context),
                  ],
                ),
                ////////////// * Filter Status , Brands , Stores * /////////////
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ////////////// * Filter Status * /////////////
                    status(context),
                    ////////////// * Filter Brands * /////////////
                    brands(context),
                    ////////////// * Filter Stores * /////////////
                    stores(context),
                  ],
                ),
                ////////////// * Sorters + Checkbox Desc * /////////////
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ////////////// * Sorters * /////////////
                    sorter(context),
                    ////////////// * Checkbox Desc * /////////////
                    checkDesc(context),
                  ],
                )
              ],
            );
          }),
    );
  }

  Widget filtersSectionTwo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: BlocStateBuilder(
        cubit: viewModel.groupFilterTwoControllerCubit,
        builder: (context, state) {
          return Wrap(
            direction: Axis.vertical,
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              ////////////// * Filter New Final Price * /////////////
              Wrap(
                direction: Axis.horizontal,
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ////////////// * Greater * /////////////
                  greaterFinalPrice(context),
                  ////////////// * Less * /////////////
                  lessFinalPrice(context),
                ],
              ),
              ////////////// * Filter New Final Package Price Package * /////////////
              Wrap(
                direction: Axis.horizontal,
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ////////////// * Greater * /////////////
                  greaterFinalPackagePrice(context),
                  ////////////// * Less * /////////////
                  lessFinalPackagePrice(context),
                ],
              ),
              ////////////// * Filter Date * /////////////
              Wrap(
                direction: Axis.horizontal,
                spacing: 15,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ////////////// * Start * /////////////
                  startDate(context),
                  ////////////// * End * /////////////
                  endDate(context),
                ],
              ),
            ],
          );
        },
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
        placeholder: 'product_textBox_name_placeHolder'.tr(),
        expands: false,
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
        placeholder: 'product_textBox_code_placeHolder'.tr(),
        expands: false,
      ),
    );
  }

  Widget sku(BuildContext context) {
    return SizedBox(
      width: 170,
      child: TextBox(
        autocorrect: true,
        enableIMEPersonalizedLearning: true,
        enableInteractiveSelection: true,
        enableSuggestions: true,
        controller: viewModel.skuFilterController,
        placeholder: 'product_textBox_sku_placeHolder'.tr(),
        expands: false,
      ),
    );
  }

  Widget description(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Tooltip(
        displayHorizontally: false,
        message: 'product_tooltip_description_placeHolder'.tr(),
        enableFeedback: true,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: viewModel.descriptionFilterController,
          placeholder: 'product_textBox_description_placeHolder'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget piecesQty(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Tooltip(
        displayHorizontally: false,
        message: 'product_tooltip_qtyPackage_placeHolder'.tr(),
        enableFeedback: true,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          controller: viewModel.qtyPackageFilterController,
          placeholder: 'product_textBox_qtyPackage_placeHolder'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget packagesQty(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Tooltip(
        displayHorizontally: false,
        message: 'product_tooltip_totalPackages_placeHolder'.tr(),
        enableFeedback: true,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          controller: viewModel.totalPackagesFilterController,
          placeholder: 'product_textBox_totalPackages_placeHolder'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget paidPackagesQty(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Tooltip(
        displayHorizontally: false,
        message: 'product_tooltip_paidTotalPackages_placeHolder'.tr(),
        enableFeedback: true,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          controller: viewModel.paidTotalPackagesFilterController,
          placeholder: 'product_textBox_paidTotalPackages_placeHolder'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget unitsQty(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Tooltip(
        displayHorizontally: false,
        message: 'product_tooltip_unitsQuantity_placeHolder'.tr(),
        enableFeedback: true,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          controller: viewModel.qtyUnitsFilterController,
          placeholder: 'product_textBox_unitsQuantity_placeHolder'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget status(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<String>(
          placeholder: Text('status'.tr()),
          value: viewModel.statusFilter.isEmpty ? null : viewModel.statusFilter,
          items: statusComboBox.map<ComboBoxItem<String>>((String status) {
            return ComboBoxItem<String>(
              value: status,
              child: Text(status),
            );
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (String? status) {
            if (status != null) {
              viewModel.statusFilter = status;
              state(() {});
            }
          });
    });
  }

  Widget brands(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<Brand>(
          placeholder: Text('brand_header'.tr()),
          value: viewModel.filterBrands,
          items: viewModel.brandsList.map<ComboBoxItem<Brand>>((Brand brand) {
            return ComboBoxItem<Brand>(
                value: brand, child: Text(brand.name!.toString()));
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (Brand? brand) {
            viewModel.filterBrands = brand;
            state(() {});
          });
    });
  }

  Widget stores(BuildContext context) {
    return StatefulBuilder(builder: (context, state) {
      return ComboBox<Store>(
          placeholder: Text('store_header'.tr()),
          value: viewModel.filterStores,
          items: viewModel.storesList.map<ComboBoxItem<Store>>((Store store) {
            return ComboBoxItem<Store>(
                value: store, child: Text(store.name!.toString()));
          }).toList(),
          iconEnabledColor: FluentTheme.of(context).accentColor,
          onChanged: (Store? store) {
            viewModel.filterStores = store;
            state(() {});
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
            } else if (sort == 'code'.tr()) {
              viewModel.sortContent = 'code'.tr();
              viewModel.sortIndex = 2;
            } else if (sort == 'sku'.tr()) {
              viewModel.sortContent = 'sku'.tr();
              viewModel.sortIndex = 3;
            } else if (sort == 'unit_price'.tr()) {
              viewModel.sortContent = 'unit_price'.tr();
              viewModel.sortIndex = 4;
            } else if (sort == 'package_price'.tr()) {
              viewModel.sortContent = 'package_price'.tr();
              viewModel.sortIndex = 5;
            } else if (sort == 'qty_units'.tr()) {
              viewModel.sortContent = 'qty_units'.tr();
              viewModel.sortIndex = 6;
            } else if (sort == 'qty_packages'.tr()) {
              viewModel.sortContent = 'qty_packages'.tr();
              viewModel.sortIndex = 7;
            } else if (sort == 'paid_qty_packages'.tr()) {
              viewModel.sortContent = 'paid_qty_packages'.tr();
              viewModel.sortIndex = 8;
            } else if (sort == 'total_packages_price'.tr()) {
              viewModel.sortContent = 'total_packages_price'.tr();
              viewModel.sortIndex = 9;
            } else if (sort == 'paid_units_qty'.tr()) {
              viewModel.sortContent = 'paid_units_qty'.tr();
              viewModel.sortIndex = 10;
            } else if (sort == 'paid_total_packages_price'.tr()) {
              viewModel.sortContent = 'paid_total_packages_price'.tr();
              viewModel.sortIndex = 11;
            } else if (sort == 'date'.tr()) {
              viewModel.sortContent = 'date'.tr();
              viewModel.sortIndex = 12;
            } else {
              viewModel.sortContent = 'status'.tr();
              viewModel.sortIndex = 13;
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

  Widget greaterFinalPrice(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InfoLabel(
        label: 'product_infoLabel_newFinalPrice'.tr(),
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          controller: viewModel.greaterNewFinalPriceStartController,
          expands: false,
          placeholder: 'grater_than'.tr(),
        ),
      ),
    );
  }

  Widget lessFinalPrice(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InfoLabel(
        label: '',
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          controller: viewModel.lessNewFinalPriceEndController,
          expands: false,
          placeholder: 'less_than'.tr(),
        ),
      ),
    );
  }

  Widget greaterFinalPackagePrice(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InfoLabel(
        label: 'product_infoLabel_newFinalPackage'.tr(),
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          controller: viewModel.greaterNewFinalPackageStartController,
          expands: false,
          placeholder: 'grater_than'.tr(),
        ),
      ),
    );
  }

  Widget lessFinalPackagePrice(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InfoLabel(
        label: '',
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          keyboardType: TextInputType.number,
          suffix: IgnorePointer(
              child: Icon(
            FluentIcons.circle_dollar,
            color: FluentTheme.of(context).accentColor,
          )),
          controller: viewModel.lessNewFinalPackageEndController,
          expands: false,
          placeholder: 'less_than'.tr(),
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

  Widget showColumnsDataTable(BuildContext context) {
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
          ////////////// * Show Columns Content * /////////////
          content: Padding(
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
                      content: Text('name'.tr()),
                      checked: showColumns[1],
                      onChanged: (checked) {
                        showColumns[1] = !showColumns[1];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('code'.tr()),
                      checked: showColumns[2],
                      onChanged: (checked) {
                        showColumns[2] = !showColumns[2];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('sku'.tr()),
                      checked: showColumns[3],
                      onChanged: (checked) {
                        showColumns[3] = !showColumns[3];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('weight'.tr()),
                      checked: showColumns[4],
                      onChanged: (checked) {
                        showColumns[4] = !showColumns[4];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('original_price'.tr()),
                      checked: showColumns[5],
                      onChanged: (checked) {
                        showColumns[5] = !showColumns[5];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('costs_price'.tr()),
                      checked: showColumns[6],
                      onChanged: (checked) {
                        showColumns[6] = !showColumns[6];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('profit'.tr()),
                      checked: showColumns[7],
                      onChanged: (checked) {
                        showColumns[7] = !showColumns[7];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('old_final_price'.tr()),
                      checked: showColumns[8],
                      onChanged: (checked) {
                        showColumns[8] = !showColumns[8];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('new_final_price'.tr()),
                      checked: showColumns[9],
                      onChanged: (checked) {
                        showColumns[9] = !showColumns[9];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('qty_units'.tr()),
                      checked: showColumns[10],
                      onChanged: (checked) {
                        showColumns[10] = !showColumns[10];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('old_final_price_package'.tr()),
                      checked: showColumns[11],
                      onChanged: (checked) {
                        showColumns[11] = !showColumns[11];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('new_final_price_package'.tr()),
                      checked: showColumns[12],
                      onChanged: (checked) {
                        showColumns[12] = !showColumns[12];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('qty_packages'.tr()),
                      checked: showColumns[13],
                      onChanged: (checked) {
                        showColumns[13] = !showColumns[13];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('paid_qty_packages'.tr()),
                      checked: showColumns[14],
                      onChanged: (checked) {
                        showColumns[14] = !showColumns[14];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('paid_units_qty'.tr()),
                      checked: showColumns[15],
                      onChanged: (checked) {
                        showColumns[15] = !showColumns[15];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('total_packages_price'.tr()),
                      checked: showColumns[16],
                      onChanged: (checked) {
                        showColumns[16] = !showColumns[16];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('paid_total_packages_price'.tr()),
                      checked: showColumns[17],
                      onChanged: (checked) {
                        showColumns[17] = !showColumns[17];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('image_path'.tr()),
                      checked: showColumns[18],
                      onChanged: (checked) {
                        showColumns[18] = !showColumns[18];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('description'.tr()),
                      checked: showColumns[19],
                      onChanged: (checked) {
                        showColumns[19] = !showColumns[19];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('date'.tr()),
                      checked: showColumns[20],
                      onChanged: (checked) {
                        showColumns[20] = !showColumns[20];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('brand'.tr()),
                      checked: showColumns[21],
                      onChanged: (checked) {
                        showColumns[21] = !showColumns[21];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('store'.tr()),
                      checked: showColumns[22],
                      onChanged: (checked) {
                        showColumns[22] = !showColumns[22];
                        state(() {});
                      });
                }),
                StatefulBuilder(builder: (context, state) {
                  return Checkbox(
                      content: Text('status'.tr()),
                      checked: showColumns[23],
                      onChanged: (checked) {
                        showColumns[23] = !showColumns[23];
                        state(() {});
                      });
                }),
              ],
            ),
          )),
    );
  }

  Widget dataTableWidget(BuildContext context) {
    return Center(
      child: BlocStateBuilder(
          cubit: viewModel.showColumnsCubit,
          builder: (context, state) {
            return BlocList<Product>(
                id: viewModel.dataTableId,
                isPagination: false,
                isRemoteData: false,
                cubit: viewModel.stater,
                loadMoreCubit: viewModel.loadMore,
                onRetryFunction: () {
                  viewModel.getAllProductsStorage(false);
                },
                showDebug: false,
                builder: (BlocListType widgetState,
                    ScrollController scrollController) {
                  return dataTable(context);
                });
          }),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';

import '../../../domain/entity/brand.dart';
import '../../../domain/entity/status.dart';
import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../viewmodels/brand_view_model.dart';

// ignore: must_be_immutable
class BrandAddPage extends StatelessWidget {
  BrandAddPage({
    super.key,
    required this.isEdit,
    required this.pageNum,
    Brand? editBrand,
  }) {
    viewModel = getItClient.get<BrandViewModel>();
    viewModel.editBrand = editBrand;
    viewModel.pageNum = pageNum;
    viewModel.initEditBrand(isEdit);
  }

  late BrandViewModel viewModel;
  String isEdit = "false";
  String pageNum;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      ////////////// * Header * /////////////
      header: header(context),
      children: [
        const SizedBox(
          height: 20,
        ),
        ////////////// * Name * /////////////
        name(context),
        const SizedBox(
          height: 25,
        ),
        ////////////// * Status * /////////////
        status(context),
        const SizedBox(
          height: 25,
        )
      ],
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
                      context.pop<int>(int.parse(viewModel.pageNum));
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(isEdit == 'true'
              ? 'brand_edit_header'.tr()
              : 'brand_add_header'.tr()),
        ],
      ),
      commandBar: Wrap(alignment: WrapAlignment.end, children: [
        ////////////// * Save/Edit Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: isEdit == 'true'
                ? 'brand_tooltip_editButton'.tr()
                : 'brand_tooltip_saveButton'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: () async {
                  //Edit
                  if (isEdit == 'true') {
                    await viewModel.editBrandStorage();
                    // ignore: use_build_context_synchronously
                    CustomInfoBar.showDefault(
                        context: context,
                        title: 'brand_add_edited_successfully'.tr(),
                        severity: InfoBarSeverity.success);
                    Future.delayed(const Duration(milliseconds: 1000));
                    // ignore: use_build_context_synchronously
                    if (context.canPop()) {
                      // ignore: use_build_context_synchronously
                      context.pop<int>(int.parse(viewModel.pageNum));
                    }
                  }
                  //Save
                  else {
                    await viewModel.addBrandStorage();
                    // ignore: use_build_context_synchronously
                    CustomInfoBar.showDefault(
                        context: context,
                        title: 'brand_add_inserted_successfully'.tr(),
                        severity: InfoBarSeverity.success);
                    Future.delayed(const Duration(milliseconds: 1000));

                    // ignore: use_build_context_synchronously
                    if (context.canPop()) {
                      // ignore: use_build_context_synchronously
                      context.pop<int>(int.parse(viewModel.pageNum));
                    }
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(isEdit == 'true' ? 'edit'.tr() : 'save'.tr(),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget name(BuildContext context) {
    return InfoLabel(
      label: 'brand_add_infoBar_text'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: viewModel.nameNewEditController,
          placeholder: 'name'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget status(BuildContext context) {
    return InfoLabel(
      label: 'brand_add_infoBar_comboBox'.tr(),
      child: StatefulBuilder(builder: (context, state) {
        return ComboBox<String>(
            placeholder: Text('status'.tr()),
            value: viewModel.newEditComboStatus.isEmpty
                ? null
                : viewModel.newEditComboStatus,
            items: [Status.active.name.tr(), Status.inactive.name.tr()]
                .map<ComboBoxItem<String>>((String status) {
              return ComboBoxItem<String>(value: status, child: Text(status));
            }).toList(),
            iconEnabledColor: FluentTheme.of(context).accentColor,
            onChanged: (String? status) {
              viewModel.newEditComboStatus = status ?? '';
              state(() {});
            });
      }),
    );
  }
}

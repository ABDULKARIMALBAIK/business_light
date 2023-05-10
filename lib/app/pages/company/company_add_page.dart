import 'dart:io';

import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:octo_image/octo_image.dart';

import '../../../domain/entity/company.dart';
import '../../../services/di/injection.dart';
import '../../../utils/constants.dart';
import '../../../utils/toast.dart';
import '../../bloc/bloc_state_builder.dart';
import '../../viewmodels/company_view_model.dart';

// ignore: must_be_immutable
class CompanyAddPage extends StatefulWidget {
  CompanyAddPage({
    super.key,
    required this.isEdit,
    required this.pageNum,
    Company? editCompany,
  }) {
    viewModel = getItClient.get<CompanyViewModel>();
    viewModel.editCompany = editCompany;
    viewModel.pageNum = pageNum;
    viewModel.initEditCompany(isEdit);
  }

  late CompanyViewModel viewModel;
  String isEdit = "false";
  String pageNum;

  @override
  State<StatefulWidget> createState() => _CompanyAddPageState();
}

class _CompanyAddPageState extends State<CompanyAddPage> {
  @override
  Widget build(BuildContext context) {
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
                ////////////// * Email * /////////////
                const SizedBox(
                  height: 20,
                ),
                email(context),
                ////////////// * Phone * /////////////
                const SizedBox(
                  height: 20,
                ),
                phone(context),
                ////////////// * Address * /////////////
                const SizedBox(
                  height: 20,
                ),
                address(context),
                ////////////// * Bio * /////////////
                const SizedBox(
                  height: 20,
                ),
                dio(context),
                ////////////// * County * /////////////
                const SizedBox(
                  height: 20,
                ),
                country(context),
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
              ? 'company_edit_header'.tr()
              : 'company_add_header'.tr()),
        ],
      ),
      commandBar: Wrap(alignment: WrapAlignment.end, children: [
        ////////////// * Save/Edit Button * /////////////
        Card(
          padding: const EdgeInsets.all(4.0),
          child: Tooltip(
            displayHorizontally: false,
            message: widget.isEdit == 'true'
                ? 'company_tooltip_editButton'.tr()
                : 'company_tooltip_saveButton'.tr(),
            enableFeedback: true,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: FilledButton(
                onPressed: () async {
                  //! Edit
                  if (widget.isEdit == 'true') {
                    await widget.viewModel.editCompanyStorage();
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
                    await widget.viewModel.addCompanyStorage();
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

  Widget image(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: InfoLabel(
          label: 'product_add_infoBar_image'.tr(),
          child: BlocStateBuilder(
            cubit: widget.viewModel.imageUpdateCubit,
            builder: (context, state) {
              return widget.viewModel.newEditImage.isEmpty
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
                            image:
                                FileImage(File(widget.viewModel.newEditImage)),
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder: (context, imageChunk) =>
                                const Center(
                              child: SizedBox(
                                  width: 30, height: 30, child: ProgressRing()),
                            ),
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
      label: 'company_add_infoBar_name'.tr(),
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

  Widget email(BuildContext context) {
    return InfoLabel(
      label: 'company_add_infoBar_email'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.emailNewEditController,
          placeholder: 'email'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget phone(BuildContext context) {
    return InfoLabel(
      label: 'company_add_infoBar_phone'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.phoneNewEditController,
          placeholder: 'phone'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget address(BuildContext context) {
    return InfoLabel(
      label: 'company_add_infoBar_address'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.addressNewEditController,
          placeholder: 'address'.tr(),
          expands: false,
        ),
      ),
    );
  }

  Widget dio(BuildContext context) {
    return InfoLabel(
      label: 'company_add_infoBar_bio'.tr(),
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

  Widget country(BuildContext context) {
    return InfoLabel(
      label: 'company_add_infoBar_country'.tr(),
      child: SizedBox(
        width: 250,
        child: TextBox(
          autocorrect: true,
          enableIMEPersonalizedLearning: true,
          enableInteractiveSelection: true,
          enableSuggestions: true,
          controller: widget.viewModel.countryNewEditController,
          placeholder: 'country'.tr(),
          expands: false,
        ),
      ),
    );
  }
}

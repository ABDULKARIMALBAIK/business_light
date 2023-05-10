import 'package:business_light/utils/app_color.dart';
import 'package:business_light/utils/constants.dart';
import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../domain/entity/settings_color.dart';
import '../../../services/di/injection.dart';
import '../../../utils/toast.dart';
import '../../viewmodels/settings_view_model.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  // Languages list
  List<String> languages = ['english'.tr(), 'arabic'.tr()];
  // Themes list
  List<String> themes = ['light'.tr(), 'dark'.tr()];

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsViewModel viewModel;

  @override
  void initState() {
    viewModel = getItClient.get<SettingsViewModel>();
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
                header: PageHeader(
                  title: Text('settings_header'.tr()),
                ),
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  ////////////// * Themes * /////////////
                  ...themesSection(context),
                  ////////////// * Colors * /////////////
                  ...colorsSection(context),
                  ////////////// * Languages * /////////////
                  ...languagesSection(context),
                  ////////////// * Clear Database * /////////////
                  ...clearDatabaseSection(context),
                ],
              ),
            ));
  }

  List<Widget> themesSection(BuildContext context) {
    return [
      Text('settings_theme_title'.tr(),
          style: FluentTheme.of(context).typography.bodyLarge),
      const SizedBox(
        height: 5,
      ),
      ...List.generate(widget.themes.length, (index) {
        final String mode = widget.themes[index];
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8.0),
          child: RadioButton(
              checked: viewModel.getCurrentTheme() == mode,
              onChanged: (value) async {
                if (value) {
                  await viewModel.selectTheme(context, mode);
                  setState(() {});
                }
              },
              content: Text(mode)),
        );
      }),
      const SizedBox(
        height: 33,
      ),
    ];
  }

  List<Widget> colorsSection(BuildContext context) {
    return [
      Text('settings_color_title'.tr(),
          style: FluentTheme.of(context).typography.bodyLarge),
      const SizedBox(
        height: 5,
      ),
      Wrap(
        direction: Axis.horizontal,
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: viewModel.colors.map<Widget>((SettingsColor settingsColor) {
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Button(
              onPressed: () async {
                await viewModel.selectColor(context, settingsColor);
                setState(() {});
              },
              style: ButtonStyle(
                padding: ButtonState.all(EdgeInsets.zero),
                backgroundColor: ButtonState.resolveWith((states) {
                  if (states.isPressing) {
                    return settingsColor.color.toAccentColor().light;
                  } else if (states.isHovering) {
                    return settingsColor.color.toAccentColor().lighter;
                  }
                  return settingsColor.color;
                }),
              ),
              child: Container(
                height: 40,
                width: 40,
                alignment: AlignmentDirectional.center,
                child: viewModel.color == settingsColor.name
                    ? Icon(
                        FluentIcons.check_mark,
                        color: settingsColor.color.basedOnLuminance(),
                        size: 22.0,
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
      const SizedBox(
        height: 33,
      ),
    ];
  }

  List<Widget> languagesSection(BuildContext context) {
    return [
      Text('settings_language_title'.tr(),
          style: FluentTheme.of(context).typography.bodyLarge),
      const SizedBox(
        height: 5,
      ),
      Wrap(
        spacing: 15.0,
        runSpacing: 10.0,
        children: List.generate(
          widget.languages.length,
          (index) {
            final language = widget.languages[index];
            return Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: RadioButton(
                checked: viewModel.getCurrentLanguage() == language,
                onChanged: (value) async {
                  if (value) {
                    await viewModel.selectLanguage(context, language);
                    setState(() {});
                  }
                },
                content: Text(language),
              ),
            );
          },
        ),
      ),
      const SizedBox(
        height: 12,
      ),
    ];
  }

  List<Widget> clearDatabaseSection(BuildContext context) {
    return [
      const SizedBox(
        height: 20,
      ),
      Text('settings_clear_database_title'.tr(),
          style: FluentTheme.of(context).typography.bodyLarge),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          SizedBox(
            width: 150,
            child: Button(
              onPressed: () => showClearDataDialog(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('settings_button_clear'.tr(),
                    style: FluentTheme.of(context).typography.body!.copyWith(
                        color: DataHelper.isDark()
                            ? FluentColors.red.toAccentColor().lighter
                            : FluentColors.red.toAccentColor().darker)),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 12,
      ),
    ];
  }

  showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return ContentDialog(
          title: Text('settings_dialog_clear_title'.tr()),
          content: Text('settings_dialog_clear_content'.tr()),
          actions: [
            FilledButton(
              child: Text('close_contentDialog_yes'.tr()),
              onPressed: () async {
                Navigator.pop(dialogContext);
                await viewModel.clearDatabase();
                CustomInfoBar.showDefault(
                    context: context,
                    title: 'brand_add_clear_successfully'.tr(),
                    severity: InfoBarSeverity.success);
                await Future.delayed(const Duration(milliseconds: 1000));
              },
            ),
            Button(
              child: Text('close_contentDialog_no'.tr()),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_light/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entity/settings_color.dart';
import '../../domain/usecase/settings_use_case.dart';
import '../../utils/app_color.dart';

/// View Model to save and using data on screen
// @LazySingleton()
@Injectable()
class SettingsViewModel extends SettingsViewModelBase {
  SettingsViewModel(@Named('SettingsUseCase') this.useCase);

  //! Variables
  String color = DataHelper.appColor;
  String themeMode = DataHelper.appTheme;
  String language = DataHelper.appLanguage;

  //! UseCase
  final SettingsUseCase useCase;

  //! Lists
  List<SettingsColor> colors = [
    SettingsColor(color: FluentColors.yellow, name: 'yellow'),
    SettingsColor(color: FluentColors.orange, name: 'orange'),
    SettingsColor(color: FluentColors.red, name: 'red'),
    SettingsColor(color: FluentColors.magenta, name: 'magenta'),
    SettingsColor(color: FluentColors.purple, name: 'purple'),
    SettingsColor(color: FluentColors.blue, name: 'blue'),
    SettingsColor(color: FluentColors.teal, name: 'teal'),
    SettingsColor(color: FluentColors.green, name: 'green')
  ];

  //! Methods
  /// Update language of app and save changes on storage
  @override
  Future<void> selectLanguage(
      BuildContext context, String selectedLanguage) async {
    VoidCallback changeLanguage = () {};
    if (selectedLanguage == 'english'.tr()) {
      changeLanguage = () {
        EasyLocalization.of(context)!.setLocale(const Locale('en'));
      };
      selectedLanguage = 'english';
    } else if (selectedLanguage == 'arabic'.tr()) {
      changeLanguage = () {
        EasyLocalization.of(context)!.setLocale(const Locale('ar'));
      };
      selectedLanguage = 'arabic';
    } else {
      changeLanguage = () {
        EasyLocalization.of(context)!.setLocale(const Locale('en'));
      };
      selectedLanguage = 'english';
    }

    language = selectedLanguage;
    DataHelper.appLanguage = selectedLanguage;
    useCase.selectLanguage(selectedLanguage);

    changeLanguage.call();
  }

  /// Update theme of app and save changes on storage
  @override
  Future<void> selectTheme(BuildContext context, String selectedTheme) async {
    VoidCallback changeTheme = () {};
    if (selectedTheme == 'light'.tr()) {
      changeTheme = () {
        AdaptiveTheme.of(context).setLight();
      };
      selectedTheme = 'light';
    } else if (selectedTheme == 'dark'.tr()) {
      changeTheme = () {
        AdaptiveTheme.of(context).setDark();
      };
      selectedTheme = 'dark';
    } else {
      changeTheme = () {
        AdaptiveTheme.of(context).setLight();
      };
      selectedTheme = 'light';
    }

    themeMode = selectedTheme;
    DataHelper.appTheme = selectedTheme;
    useCase.selectTheme(selectedTheme);

    changeTheme.call();
  }

  /// Update color of app and save changes on storage
  @override
  Future<void> selectColor(
      BuildContext context, SettingsColor selectedColor) async {
    color = selectedColor.name;
    DataHelper.appColor = selectedColor.name;
    useCase.selectColor(selectedColor.name);

    if (themeMode == 'light'.tr()) {
      AdaptiveTheme.of(context).setLight();
    } else if (themeMode == 'dark'.tr()) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
  }

  /// Get translated language from string language
  @override
  String getCurrentLanguage() {
    if (language == 'english') {
      return 'english'.tr();
    } else if (language == 'arabic') {
      return 'arabic'.tr();
    } else {
      return 'english'.tr();
    }
  }

  /// Get translated theme from string theme
  @override
  String getCurrentTheme() {
    if (themeMode == 'light') {
      return 'light'.tr();
    } else if (themeMode == 'dark') {
      return 'dark'.tr();
    } else {
      return 'light'.tr();
    }
  }

  /// Clear all data from database
  @override
  Future<void> clearDatabase() => useCase.clearDatabase();
}

abstract class SettingsViewModelBase {
  selectLanguage(BuildContext context, String selectedLanguage);
  selectTheme(BuildContext context, String selectedTheme);
  selectColor(BuildContext context, SettingsColor selectedColor);
  getCurrentLanguage();
  getCurrentTheme();
  Future<void> clearDatabase();
}

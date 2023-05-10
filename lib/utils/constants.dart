import 'package:business_light/app/bloc/bloc_state_builder.dart';
import 'package:fluent_ui/fluent_ui.dart'
    show Color, Locale, PaneDisplayMode, Colors;

import '../services/di/injection.dart';

/// Save and using all necessary data in entire code
class DataHelper {
  /// Name of the app
  static String appName = 'Business Light';

  /// Type of the app (production,Test,Dev)
  static Env appInjectionType = Env.prod;

  /// Base Url to get data from the server is used in dio operations (POST, PUT, DELETE, PATH)
  static String baseUrl = '';

  /// Theme Type (Dark,Light)
  static String appTheme = 'light';

  /// Language type (English, Arabic, German, France, Spain, Chinese, India, Russia, Turkish)
  static String appLanguage = 'english';

  /// Color of App
  static String appColor = 'yellow';

  /// Display mode of Navigation Drawer
  static const fluentDisplayMode = PaneDisplayMode.compact;

  /// List of Colors
  static List<String> appColors = [
    'yellow',
    'orange',
    'red',
    'magenta',
    'purple',
    'blue',
    'teal',
    'green'
  ];

  /// List of Themes
  List<String> appThemes = ['light', 'dark'];

  /// List of Languages
  List<String> appLanguages = ['english', 'arabic'];

  /// Bloc to change the text of header panel
  static BlocStateBuilderCubit messageCubit =
      BlocStateBuilderCubit(value: 'Welcome Sir');

  /// Get current color
  static Color getCurrentColor() {
    if (DataHelper.appColor == appColors[0]) {
      return isDark()
          ? Colors.accentColors[0].lighter
          : Colors.accentColors[0].darker;
    } else if (DataHelper.appColor == appColors[1]) {
      return isDark()
          ? Colors.accentColors[1].lighter
          : Colors.accentColors[1].darker;
    } else if (DataHelper.appColor == appColors[2]) {
      return isDark()
          ? Colors.accentColors[2].lighter
          : Colors.accentColors[2].darker;
    } else if (DataHelper.appColor == appColors[3]) {
      return isDark()
          ? Colors.accentColors[3].lighter
          : Colors.accentColors[3].darker;
    } else if (DataHelper.appColor == appColors[4]) {
      return isDark()
          ? Colors.accentColors[4].lighter
          : Colors.accentColors[4].darker;
    } else if (DataHelper.appColor == appColors[5]) {
      return isDark()
          ? Colors.accentColors[5].lighter
          : Colors.accentColors[5].darker;
    } else if (DataHelper.appColor == appColors[6]) {
      return isDark()
          ? Colors.accentColors[6].lighter
          : Colors.accentColors[6].darker;
    } else if (DataHelper.appColor == appColors[7]) {
      return isDark()
          ? Colors.accentColors[7].lighter
          : Colors.accentColors[7].darker;
    } else {
      return isDark()
          ? Colors.accentColors[0].lighter
          : Colors.accentColors[0].darker;
    }
  }

  /// Check Theme of App
  static bool isDark() => appTheme == 'dark';

  /// Get current language by country code
  static Locale getCurrentLanguage() {
    switch (appLanguage) {
      case 'english':
        {
          return const Locale('en');
        }
      case 'arabic':
        {
          return const Locale('ar');
        }
      default:
        {
          return const Locale('en');
        }
    }
  }

  /// Rotating angel according to country code
  static int rotateBackButton() {
    switch (appLanguage) {
      case 'english':
        return 0;
      case 'arabic':
        return 2;
      default:
        return 0;
    }
  }

  /// check type of sorting to data table {is canceled right now}
  static bool isNumeric(String s) {
    // ignore: unnecessary_null_comparison
    if (s == null) {
      return false;
    } else if (s.isEmpty) {
      return false;
    }
    // ignore: todo
    // TODO according to DartDoc num.parse() includes both (double.parse and int.parse)
    return double.tryParse(s) != null ||
        // ignore: unnecessary_null_comparison
        int.parse(s) != null;
  }
}

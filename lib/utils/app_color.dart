import 'package:fluent_ui/fluent_ui.dart';

/// Colors of the app
class AppColor {
  Color primaryColorLight() => Colors.blue;
  Color primaryColorDark() => Colors.blue;

  Color accentColorLight() => Colors.blue;
  Color accentColorDark() => Colors.blue;

  Color backgroundColorLight() => const Color(0xFFE7ECEF);
  Color backgroundColorDark() => const Color(0xFF2E3239);

  Color cardColorLight() => const Color(0xFFF8F8F8);
  Color cardColorDark() => const Color(0xFF0E0E0E);

  Color textTitleColorLight() => Colors.black;
  Color textTitleColorDark() => Colors.white;

  Color textBodyColorLight() => Colors.black;
  Color textBodyColorDark() => Colors.black;
}

/// [FluentColors] class give all standards colors of fluent ui
class FluentColors {
  static Color yellow = Colors.accentColors[0];
  static Color orange = Colors.accentColors[1];
  static Color red = Colors.accentColors[2];
  static Color magenta = Colors.accentColors[3];
  static Color purple = Colors.accentColors[4];
  static Color blue = Colors.accentColors[5];
  static Color teal = Colors.accentColors[6];
  static Color green = Colors.accentColors[7];
  static Color white = Colors.white;
  static Color black = Colors.black;
}

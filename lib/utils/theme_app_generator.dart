import 'package:business_light/utils/constants.dart';
import 'package:business_light/utils/platform_detector.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';
// ignore: library_prefixes
import 'package:fluent_ui/fluent_ui.dart' as Fluent;

/// Menage and using all supported themes in business light app
class ThemeAppGenerator {
  /// Using light theme to the app
  static ThemeData lightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColor().primaryColorLight(),
        // ignore: deprecated_member_use
        primaryColorBrightness: Brightness.light,
        primaryColorLight: AppColor().primaryColorLight(),
        primaryColorDark: AppColor().primaryColorDark(),
        // ignore: deprecated_member_use
        accentColor: AppColor().accentColorLight(),
        // ignore: deprecated_member_use
        accentColorBrightness: Brightness.light,
        scaffoldBackgroundColor: AppColor().backgroundColorLight(),
        // backgroundColor: AppColor().cardColorLight(),
        // bottomAppBarColor: AppColor().cardColorLight(),
        cardColor: AppColor().cardColorLight(),
        dialogBackgroundColor: AppColor().cardColorLight(),
        indicatorColor: AppColor().primaryColorLight(),
        hintColor: AppColor().textBodyColorLight(),
        dividerColor: AppColor().textBodyColorLight(),
        scrollbarTheme: ScrollbarThemeData(
          // thumbVisibility: false,
          thickness: MaterialStateProperty.all(12),
          interactive: true,
          thumbColor: MaterialStateProperty.all(
              AppColor().primaryColorLight().withOpacity(0.3)),
          radius: const Radius.circular(10),
          minThumbLength: 100,
        ),
        textTheme: const TextTheme(
            // headline1: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 96.0),
            // headline2: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 60.0),
            // headline3: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 48.0),
            // headline4: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 34.0),
            // headline5: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 24.0),
            // headline6: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 20.0),
            // bodyText1: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 16.0),
            // bodyText2: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 14.0),
            // subtitle1: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 16.0),
            // subtitle2: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 14.0),
            // button: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 14.0),
            // caption: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 12.0),
            // overline: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorLight(), fontSize: 10.0)
            ),
        tabBarTheme: TabBarTheme(
            labelColor: AppColor().cardColorLight(),
            unselectedLabelColor: AppColor().primaryColorLight()),
        iconTheme: IconThemeData(color: AppColor().textTitleColorLight()),
        primaryIconTheme: IconThemeData(color: AppColor().primaryColorLight()),
        // ignore: deprecated_member_use
        accentIconTheme: IconThemeData(color: AppColor().accentColorLight()),
        chipTheme: ChipThemeData(
            brightness: Brightness.light,
            backgroundColor: AppColor().cardColorLight(),
            disabledColor: AppColor().backgroundColorLight(),
            selectedColor: AppColor().primaryColorLight(),
            checkmarkColor: AppColor().textTitleColorDark(),
            deleteIconColor: AppColor().textTitleColorDark(),
            shadowColor: AppColor().primaryColorLight(),
            labelStyle: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            secondaryLabelStyle: const TextStyle(),
            padding: const EdgeInsets.all(8),
            secondarySelectedColor: AppColor().primaryColorLight()),
        appBarTheme: AppBarTheme(
            backgroundColor: AppColor().cardColorLight(),
            elevation: 6,
            // ignore: deprecated_member_use
            brightness: Brightness.light,
            actionsIconTheme:
                IconThemeData(color: AppColor().textTitleColorLight()),
            centerTitle: PlatformDetector().isIOS() ? true : false,
            shadowColor: AppColor().textTitleColorLight(),
            titleTextStyle:
                GoogleFonts.montserrat(color: AppColor().textTitleColorLight()),
            toolbarTextStyle: GoogleFonts.montserrat(
                color: AppColor().textTitleColorLight())),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: AppColor().backgroundColorLight(),
            elevation: 8,
            modalBackgroundColor: AppColor().backgroundColorLight(),
            modalElevation: 9),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(AppColor().cardColorLight()),
            splashRadius: 8,
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            fillColor:
                MaterialStateProperty.all(AppColor().primaryColorLight()),
            overlayColor: MaterialStateProperty.all(Colors.green[100])),
        radioTheme: RadioThemeData(
            splashRadius: 8,
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            fillColor:
                MaterialStateProperty.all(AppColor().primaryColorLight()),
            overlayColor: MaterialStateProperty.all(Colors.green[100])),
        switchTheme: SwitchThemeData(
            thumbColor:
                MaterialStateProperty.all(AppColor().primaryColorLight()),
            trackColor: MaterialStateProperty.all(Colors.green[100]),
            splashRadius: 8,
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            overlayColor: MaterialStateProperty.all(Colors.green[100])));
  }

  /// Using dark theme to the app
  static ThemeData darkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColor().primaryColorDark(),
        // ignore: deprecated_member_use
        primaryColorBrightness: Brightness.dark,
        primaryColorLight: AppColor().primaryColorLight(),
        primaryColorDark: AppColor().primaryColorDark(),
        // ignore: deprecated_member_use
        accentColor: AppColor().accentColorDark(),
        // ignore: deprecated_member_use
        accentColorBrightness: Brightness.dark,
        // backgroundColor: AppColor().cardColorDark(),
        scaffoldBackgroundColor: AppColor().backgroundColorDark(),
        // bottomAppBarColor: AppColor().cardColorDark(),
        cardColor: AppColor().cardColorDark(),
        dialogBackgroundColor: AppColor().cardColorDark(),
        indicatorColor: AppColor().primaryColorDark(),
        hintColor: AppColor().textBodyColorDark(),
        scrollbarTheme: ScrollbarThemeData(
          // thumbVisibility: false,
          interactive: true,
          thickness: MaterialStateProperty.all(12),
          thumbColor: MaterialStateProperty.all(
              AppColor().primaryColorDark().withOpacity(0.3)),
          radius: const Radius.circular(12),
          minThumbLength: 100,
        ),
        textTheme: const TextTheme(
            // headline1: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 96.0),
            // headline2: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 60.0),
            // headline3: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 48.0),
            // headline4: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 34.0),
            // headline5: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 24.0),
            // headline6: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 20.0),
            // bodyText1: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 16.0),
            // bodyText2: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 14.0),
            // subtitle1: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 16.0),
            // subtitle2: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 14.0),
            // button: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 14.0),
            // caption: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 12.0),
            // overline: GoogleFonts.montserrat(
            //     color: AppColor().textTitleColorDark(), fontSize: 10.0)

            ),
        tabBarTheme: TabBarTheme(
            labelColor: AppColor().cardColorDark(),
            unselectedLabelColor: AppColor().primaryColorDark()),
        iconTheme: IconThemeData(color: AppColor().textTitleColorDark()),
        primaryIconTheme: IconThemeData(color: AppColor().primaryColorDark()),
        // ignore: deprecated_member_use
        accentIconTheme: IconThemeData(color: AppColor().accentColorDark()),
        chipTheme: ChipThemeData(
            brightness: Brightness.light,
            backgroundColor: AppColor().cardColorDark(),
            disabledColor: AppColor().backgroundColorDark(),
            selectedColor: AppColor().primaryColorDark(),
            checkmarkColor: AppColor().textTitleColorDark(),
            deleteIconColor: AppColor().textTitleColorDark(),
            shadowColor: AppColor().primaryColorLight(),
            labelStyle: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            secondaryLabelStyle: const TextStyle(),
            padding: const EdgeInsets.all(8),
            secondarySelectedColor: AppColor().primaryColorLight()),
        appBarTheme: AppBarTheme(
            backgroundColor: AppColor().cardColorDark(),
            elevation: 6,
            // ignore: deprecated_member_use
            brightness: Brightness.dark,
            actionsIconTheme:
                IconThemeData(color: AppColor().textTitleColorDark()),
            centerTitle: PlatformDetector().isIOS() ? true : false,
            shadowColor: AppColor().textTitleColorLight(),
            titleTextStyle:
                GoogleFonts.montserrat(color: AppColor().textTitleColorDark()),
            toolbarTextStyle:
                GoogleFonts.montserrat(color: AppColor().textTitleColorDark())),
        bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: AppColor().backgroundColorDark(),
            elevation: 8,
            modalBackgroundColor: AppColor().backgroundColorDark(),
            modalElevation: 8),
        checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(AppColor().cardColorLight()),
            splashRadius: 8,
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            fillColor: MaterialStateProperty.all(AppColor().primaryColorDark()),
            overlayColor: MaterialStateProperty.all(Colors.green[100])),
        radioTheme: RadioThemeData(
            splashRadius: 8,
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            fillColor: MaterialStateProperty.all(AppColor().primaryColorDark()),
            overlayColor: MaterialStateProperty.all(Colors.green[100])),
        switchTheme: SwitchThemeData(
            thumbColor:
                MaterialStateProperty.all(AppColor().primaryColorDark()),
            trackColor: MaterialStateProperty.all(Colors.green[100]),
            splashRadius: 8,
            mouseCursor: MaterialStateProperty.all(MouseCursor.defer),
            overlayColor: MaterialStateProperty.all(Colors.green[100])));
  }

  /// Using light theme to the app (Fluent App)
  static Fluent.FluentThemeData fluentLightTheme() {
    Fluent.Color currentColor = DataHelper.getCurrentColor();

    return Fluent.FluentThemeData(
      brightness: Fluent.Brightness.light,
      accentColor: currentColor.toAccentColor(), //Fluent.Colors.accentColors[0]
      scaffoldBackgroundColor: AppColor().backgroundColorLight(),
      // cardColor: AppColor().cardColorLight(),
      typography: Fluent.Typography.raw(
        display: GoogleFonts.montserrat(
          fontSize: 68,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 40,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        title: GoogleFonts.montserrat(
          fontSize: 28,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        subtitle: GoogleFonts.montserrat(
          fontSize: 20,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 18,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.normal,
        ),
        bodyStrong: GoogleFonts.montserrat(
          fontSize: 14,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        body: GoogleFonts.montserrat(
          fontSize: 14,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.normal,
        ),
        caption: GoogleFonts.montserrat(
          fontSize: 12,
          color: AppColor().textTitleColorLight(),
          fontWeight: Fluent.FontWeight.normal,
        ),
      ),
    );
  }

  /// Using dark theme to the app (Fluent App)
  static Fluent.FluentThemeData fluentDarkTheme() {
    Fluent.Color currentColor = DataHelper.getCurrentColor();

    return Fluent.FluentThemeData(
      brightness: Fluent.Brightness.dark,
      accentColor: currentColor.toAccentColor(), //Fluent.Colors.accentColors[0]
      scaffoldBackgroundColor: AppColor().backgroundColorDark(),
      // cardColor: AppColor().cardColorDark(),
      typography: Fluent.Typography.raw(
        display: GoogleFonts.montserrat(
          fontSize: 68,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        titleLarge: GoogleFonts.montserrat(
          fontSize: 40,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        title: GoogleFonts.montserrat(
          fontSize: 28,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        subtitle: GoogleFonts.montserrat(
          fontSize: 20,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.montserrat(
          fontSize: 18,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.normal,
        ),
        bodyStrong: GoogleFonts.montserrat(
          fontSize: 14,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.w600,
        ),
        body: GoogleFonts.montserrat(
          fontSize: 14,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.normal,
        ),
        caption: GoogleFonts.montserrat(
          fontSize: 12,
          color: AppColor().textTitleColorDark(),
          fontWeight: Fluent.FontWeight.normal,
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_light/services/di/injection.dart';
import 'package:business_light/services/router/routers.dart';
import 'package:business_light/utils/app_color.dart';
import 'package:business_light/services/router/router_generator.dart';
import 'package:easy_localization/easy_localization.dart';
// ignore: library_prefixes
import 'package:fluent_ui/fluent_ui.dart' as Fluent;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:business_light/utils/constants.dart';
import 'package:business_light/services/localization.dart';
import 'package:business_light/utils/resources_path.dart';
import 'package:business_light/utils/theme_app_generator.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'data/datasource/storage/storage_service.dart';
import 'package:lottie/lottie.dart';

part 'app_initialize.dart';

///Main Method to run the app
Future<void> main() async {
  ///Initial data before running the app
  await _preInitializations();

  ///Create [App] Widget
  runApp(const App());
}

/// App Widget initial [EasyLocalization] and [AdaptiveTheme] and [GoRouter]
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ////////////// * initial Localization * /////////////
    return EasyLocalization(
        supportedLocales: Localization.supportedLocals,
        path: ResourcesPath.translations,
        startLocale: DataHelper.getCurrentLanguage(),
        fallbackLocale: Localization.fallbackLocale,
        //////////////// * initial Theme * //////////////
        child: AdaptiveTheme(
            light: ThemeAppGenerator.lightTheme(),
            dark: ThemeAppGenerator.darkTheme(),
            initial: DataHelper.appTheme == 'dark'
                ? AdaptiveThemeMode.dark
                : AdaptiveThemeMode.light,
            builder: (theme, darkTheme) =>
                StartFluentApp(lightTheme: theme, darkTheme: darkTheme)));
  }
}

/// [StartFluentApp] create [FluentApp] widget to wrap widget tree
// ignore: must_be_immutable
class StartFluentApp extends StatelessWidget {
  StartFluentApp(
      {super.key, required this.lightTheme, required this.darkTheme});

  ThemeData? lightTheme;
  ThemeData? darkTheme;

  @override
  Widget build(BuildContext context) {
    return Fluent.FluentApp.router(
      title: DataHelper.appName,
      color: DataHelper.appTheme == 'dark'
          ? AppColor().primaryColorDark()
          : AppColor().primaryColorLight(),
      debugShowCheckedModeBanner: false,
      themeMode:
          DataHelper.appTheme == 'dark' ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeAppGenerator.fluentLightTheme(),
      darkTheme: ThemeAppGenerator.fluentDarkTheme(),
      // localeListResolutionCallback: ,
      // localeResolutionCallback: ,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: Localization.supportedLocals,
      locale: context.locale,
      routeInformationParser:
          RouteGenerator.routerClient.routeInformationParser,
      routerDelegate: RouteGenerator.routerClient.routerDelegate,
      routeInformationProvider:
          RouteGenerator.routerClient.routeInformationProvider,
      builder: (context, child) => child!,
    );
  }
}

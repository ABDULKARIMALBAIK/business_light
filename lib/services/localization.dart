import 'package:flutter/material.dart' show Locale;

/// Get and use all locales that are supported in business light app
class Localization {
  /// Get all supported Locals
  static List<Locale> supportedLocals = const [Locale('en'), Locale('ar')];

  /// If it isn't found any locale , so use default own
  static Locale fallbackLocale = const Locale('en', 'US');
}

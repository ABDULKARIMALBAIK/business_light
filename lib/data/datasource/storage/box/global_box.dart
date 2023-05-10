import 'package:business_light/domain/entity/global.dart';
import 'package:isar/isar.dart';

// Storage Box to make save and get for color , theme and language
class GlobalBox extends GlobalBoxOperations {
  GlobalBox(this._store);

  final Isar _store;

  /// Update theme of app and save changes on storage
  @override
  Future<String> setupTheme() async {
    final globals = await _store.globals.where().findAll();
    if (globals.isEmpty) {
      int index = await _store.writeTxn<int>(() async {
        return (await _store.globals.put(Global()));
      });

      final Global? globalData = await _store.globals.get(index);
      String theme = globalData == null ? 'light' : globalData.theme;
      return theme;
    } else {
      final Global globalData = globals[0];
      //String theme = globalData == null ? 'light' : globalData.theme;
      String theme = globalData.theme;
      return theme;
    }
  }

  /// Update language of app and save changes on storage
  @override
  Future<String> setupLanguage() async {
    final globals = await _store.globals.where().findAll();
    if (globals.isEmpty) {
      int index = await _store.writeTxn<int>(() async {
        return (await _store.globals.put(Global()));
      });

      final Global? globalData = await _store.globals.get(index);
      String language = globalData == null ? 'english' : globalData.language;
      return language;
    } else {
      final Global globalData = globals[0];
      //String language = globalData == null ? 'english' : globalData.language;
      String language = globalData.language;
      return language;
    }
  }

  /// Update color of app and save changes on storage
  @override
  Future<String> setupColor() async {
    final globals = await _store.globals.where().findAll();
    if (globals.isEmpty) {
      int index = await _store.writeTxn<int>(() async {
        return (await _store.globals.put(Global()));
      });

      final Global? globalData = await _store.globals.get(index);
      String color = globalData == null ? 'yellow' : globalData.color;
      return color;
    } else {
      final Global globalData = globals[0];
      //String color = globalData == null ? 'yellow' : globalData.color;
      String color = globalData.color;
      return color;
    }
  }

  @override
  Future<void> selectLanguage(String selectedLanguage) async {
    final globalsData = await _store.globals.where().findAll();

    if (globalsData.isNotEmpty) {
      final globals = globalsData[0];
      await _store.writeTxn(() async {
        globals.language = selectedLanguage;
        await _store.globals.put(globals);
      });
    }
  }

  @override
  Future<void> selectTheme(String selectedTheme) async {
    final globalsData = await _store.globals.where().findAll();

    if (globalsData.isNotEmpty) {
      final globals = globalsData[0];
      await _store.writeTxn(() async {
        globals.theme = selectedTheme;
        await _store.globals.put(globals);
      });
    }
  }

  @override
  Future<void> selectColor(String selectedColor) async {
    final globalsData = await _store.globals.where().findAll();

    if (globalsData.isNotEmpty) {
      final globals = globalsData[0];
      await _store.writeTxn(() async {
        globals.color = selectedColor;
        await _store.globals.put(globals);
      });
    }
  }

  // Future<void> delete() async {
  //   await _store.writeTxn(() async {
  //     await _store.globals.delete(1);
  //   });
  // }

  @override
  Future<String> getTheme() => setupTheme();
  @override
  Future<String> getLanguage() => setupLanguage();
  @override
  Future<String> getColor() => setupColor();
}

abstract class GlobalBoxOperations {
  Future<String> setupTheme();
  Future<String> setupLanguage();
  Future<String> setupColor();
  Future<void> selectLanguage(String selectedLanguage);
  Future<void> selectTheme(String selectedTheme);
  Future<void> selectColor(String selectedColor);
  Future<String> getTheme();
  Future<String> getLanguage();
  Future<String> getColor();
}

import 'package:injectable/injectable.dart';

import '../datasource/storage/storage_service.dart';

/// Repository to make all operations on storage and remote server
@Named('SettingsRepository')
@Injectable()
class SettingsRepository implements SettingsRepositoryOperations {
  SettingsRepository(@Named('StorageService') this.storageService);

  final StorageService storageService;

  //! Storage Functions
  /// Update color of app and save changes on storage
  @override
  Future<void> selectColor(String selectedColor) =>
      storageService.globalBox.selectColor(selectedColor);

  /// Update language of app and save changes on storage
  @override
  Future<void> selectLanguage(String selectedLanguage) =>
      storageService.globalBox.selectLanguage(selectedLanguage);

  /// Update theme of app and save changes on storage
  @override
  Future<void> selectTheme(String selectedTheme) =>
      storageService.globalBox.selectTheme(selectedTheme);

  /// Get Theme from storage
  @override
  Future<String> getTheme() => storageService.globalBox.getTheme();

  /// Get Language from storage
  @override
  Future<String> getLanguage() => storageService.globalBox.getLanguage();

  /// Get Color from storage
  @override
  Future<String> getColor() => storageService.globalBox.getColor();

  /// Clear all data from database
  @override
  clearDatabase() => storageService.clearDB();
}

abstract class SettingsRepositoryOperations {
  Future<void> selectLanguage(String selectedLanguage);
  Future<void> selectTheme(String selectedTheme);
  Future<void> selectColor(String selectedColor);
  Future<String> getTheme();
  Future<String> getLanguage();
  Future<String> getColor();
  Future<void> clearDatabase();
}

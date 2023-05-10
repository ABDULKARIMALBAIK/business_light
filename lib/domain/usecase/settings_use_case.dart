import 'package:business_light/domain/repository/settings_operations.dart';
import 'package:injectable/injectable.dart';

import '../../data/repository/settings_repository.dart';

/// Usecase to make all operations in view model of settings
@Named('SettingsUseCase')
@Injectable()
class SettingsUseCase extends SettingsOperations {
  SettingsUseCase(@Named('SettingsRepository') this.repository);

  final SettingsRepository repository;

  //! Storage Functions
  /// Update color of app and save changes on storage
  @override
  Future<void> selectColor(String selectedColor) =>
      repository.selectColor(selectedColor);

  /// Update language of app and save changes on storage
  @override
  Future<void> selectLanguage(String selectedLanguage) =>
      repository.selectLanguage(selectedLanguage);

  /// Update theme of app and save changes on storage
  @override
  Future<void> selectTheme(String selectedTheme) =>
      repository.selectTheme(selectedTheme);

  /// Get Theme from storage
  @override
  Future<String> getTheme() => repository.getTheme();

  /// Get Language from storage
  @override
  Future<String> getLanguage() => repository.getLanguage();

  /// Get Color from storage
  @override
  Future<String> getColor() => repository.getColor();

  /// Clear all data from database
  @override
  clearDatabase() => repository.clearDatabase();
}

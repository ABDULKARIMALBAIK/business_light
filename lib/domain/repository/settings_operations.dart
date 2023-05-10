///Declare all operations to Settings screen
abstract class SettingsOperations {
  Future<void> selectLanguage(String selectedLanguage);

  Future<void> selectTheme(String selectedTheme);

  Future<void> selectColor(String selectedColor);

  Future<String> getTheme();
  Future<String> getLanguage();
  Future<String> getColor();
  Future<void> clearDatabase();
}

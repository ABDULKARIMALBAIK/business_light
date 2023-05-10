import 'package:isar/isar.dart';

part 'global.g.dart';

//Important Note: don't use class have same name with dart classes like (Type) throw error
//Important Note: don't use allies names on class like (import.... as ctx) throw error

@collection
@Name("Global")
class Global {
  Global(
      {this.theme = 'light', this.language = 'english', this.color = 'yellow'});
  Id id = Isar.autoIncrement;
  String theme;
  String language;
  String color;
}

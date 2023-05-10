import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'page.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Page extends Equatable {
  Id? id = Isar.autoIncrement;
  String? name;
  String? description;

  @ignore
  @override
  List<Object?> get props => [id, name, description];
}

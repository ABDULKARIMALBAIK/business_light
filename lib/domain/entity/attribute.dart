import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'attribute.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Attribute extends Equatable {
  Id? id = Isar.autoIncrement;
  String? name;

  final details = IsarLinks<AttributeDetails>();

  @ignore
  @override
  List<Object?> get props => [id, name, details];
}

@Collection(inheritance: false)
// ignore: must_be_immutable
class AttributeDetails extends Equatable {
  Id? id = Isar.autoIncrement;
  String? name;

  @ignore
  @override
  List<Object?> get props => [id, name];
}

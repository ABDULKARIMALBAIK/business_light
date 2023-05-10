import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'currency.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Currency extends Equatable {
  Id? id = Isar.autoIncrement;
  String? name;
  String? flagCode;
  String? symbol;
  double? price;

  @ignore
  @override
  List<Object?> get props => [id, name, flagCode, symbol, price];
}

import 'package:business_light/domain/entity/company.dart';
import 'package:business_light/domain/entity/status.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'pack.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Pack extends Equatable {
  Id? id = Isar.autoIncrement;
  String? code;
  String? name;
  int? totalPackages;
  int? remainPackages;
  double? totalPrice;
  int? totalQty;
  int? remainQty;
  DateTime? date;

  @enumerated
  Status status = Status.active;

  final company = IsarLink<Company>();

  @ignore
  @override
  List<Object?> get props => [
        id,
        code,
        name,
        totalPackages,
        totalPrice,
        totalQty,
        date,
        status,
        company
      ];
}

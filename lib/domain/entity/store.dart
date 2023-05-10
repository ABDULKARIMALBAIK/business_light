import 'package:business_light/domain/entity/status.dart';
import 'package:business_light/utils/support/pagination_id.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'store.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Store extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? name;
  String? code;

  @enumerated
  Status status = Status.active;

  @ignore
  @override
  List<Object?> get props => [id, name, code, status];

  @override
  bool? get stringify => true;
}

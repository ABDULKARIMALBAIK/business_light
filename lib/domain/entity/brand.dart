import 'package:business_light/domain/entity/status.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../utils/support/pagination_id.dart';

part 'brand.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Brand extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? name;

  @enumerated
  Status status = Status.active;

  @ignore
  @override
  List<Object?> get props => [id, name, status];

  @ignore
  @override
  bool? get stringify => true;
}

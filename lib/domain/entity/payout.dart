import 'package:business_light/domain/entity/user.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../utils/support/pagination_id.dart';

part 'payout.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Payout extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? code;
  double? price;
  String? description;
  DateTime? date;

  // final page = IsarLink<Page>();
  final employeeSalary = IsarLink<User>();

  @enumerated
  PayoutType payoutType = PayoutType.other;

  @ignore
  @override
  List<Object?> get props => [id, code, price, description, payoutType, date];

  @override
  bool? get stringify => true;
}

/*
  PayoutTypes:
  1- Debt
  2- Tax
  3- Salary
  4- Other
 */
enum PayoutType { debt, tax, salary, other }

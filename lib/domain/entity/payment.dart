import 'package:business_light/utils/support/pagination_id.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'payment.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Payment extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? code;
  double? price;
  String? description;
  DateTime? date;

  // final page = IsarLink<Page>();

  @enumerated
  PaymentType paymentType = PaymentType.other;

  @ignore
  @override
  List<Object?> get props =>
      [id, code, price, description, date, paymentType, date];

  @override
  bool? get stringify => true;
}

/*
  PaymentTypes:
  1- order
  2- other
 */
enum PaymentType { order, other }

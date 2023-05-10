import 'package:business_light/domain/entity/payment.dart';
import 'package:business_light/domain/entity/product_order.dart';
import 'package:business_light/domain/entity/user.dart';
import 'package:business_light/utils/support/pagination_id.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'order.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Order extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? code;
  int? totalQty;
  int? qtyPieces;
  double? totalPrice;
  // double? pricePieces;
  double? chargeCost;
  double? otherCost;
  double? balancer;
  double? discount;
  DateTime? date;
  double? finalPrice;
  String? description;
  // bool isPaid = false;

  final user = IsarLink<User>();
  final payments = IsarLinks<Payment>();
  final products = IsarLinks<ProductOrder>();
  // final currency = IsarLink<Currency>();

  @enumerated
  TypeOrder type = TypeOrder.negotiation;

  @ignore
  @override
  List<Object?> get props => [
        id,
        code,
        totalQty,
        qtyPieces,
        totalPrice,
        // pricePieces,
        chargeCost,
        otherCost,
        otherCost,
        balancer,
        discount,
        date,
        finalPrice,
        description,
        // isPaid,
        user,
        payments,
        // currency,
        products,
        type
      ];

  @override
  bool? get stringify => true;
}

/*
  Types:
  1- negotiation (تفاوض)
  2- deal
  3- sell
  4- complete
 */
enum TypeOrder { negotiation, deal, sell, complete }

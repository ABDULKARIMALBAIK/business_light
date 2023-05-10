import 'package:business_light/domain/entity/company.dart';
import 'package:business_light/domain/entity/product.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import 'currency.dart';
import 'payout.dart';

part 'debt.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Debt extends Equatable {
  //الدين
  Id? id = Isar.autoIncrement;
  String? code;
  String? description;
  int? totalQty;
  int? qtyPieces;
  DateTime? date;
  double? costTaxes;
  double? costTransit;
  double? otherCosts;
  double? finalPrice;
  double? finalPricePerPiece;
  double? balancer;
  bool isPaid = false;

  final company = IsarLink<Company>();
  final currency = IsarLink<Currency>();
  final payouts = IsarLinks<Payout>();
  final products = IsarLinks<Product>();

  @enumerated
  TypeDebt type = TypeDebt.negotiation;

  @ignore
  @override
  List<Object?> get props => [
        id,
        code,
        description,
        totalQty,
        qtyPieces,
        date,
        costTaxes,
        costTransit,
        otherCosts,
        finalPrice,
        finalPricePerPiece,
        balancer,
        isPaid,
        company,
        payouts,
        currency,
        products
      ];
}

/*
  Types:
  1- negotiation (تفاوض)
  2- deal
  3- sell
  4- complete
 */
enum TypeDebt { negotiation, deal, sell, complete }

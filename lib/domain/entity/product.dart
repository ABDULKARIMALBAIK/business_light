import 'package:business_light/domain/entity/brand.dart';
import 'package:business_light/domain/entity/status.dart';
import 'package:business_light/domain/entity/store.dart';
import 'package:business_light/utils/support/pagination_id.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'product.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Product extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? name;
  String? code;
  String? sku;
  double? weight;
  double? originalPrice;
  double? costsPrice;
  double? profit;
  double? oldFinalPrice;
  double? newFinalPrice;
  int? qtyPackage;
  double? oldFinalPricePackage;
  double? newFinalPricePackage;
  int? totalPackages;
  int? paidTotalPackages;
  int? paidTotalUnits;
  double? totalPrice;
  double? paidTotalPrice;
  String? imagePath;
  String? description;
  DateTime? date;

  @enumerated
  Status status = Status.active;

  final store = IsarLink<Store>();
  final brand = IsarLink<Brand>();
  // final pack = IsarLink<Pack>();

  @ignore
  @override
  List<Object?> get props => [
        id,
        name,
        code,
        sku,
        weight,
        costsPrice,
        profit,
        imagePath,
        description,
        status,
        store,
        brand,
        originalPrice,
        oldFinalPrice,
        newFinalPrice,
        qtyPackage,
        oldFinalPricePackage,
        newFinalPricePackage,
        totalPackages,
        paidTotalPackages,
        paidTotalUnits,
        date
      ];

  @override
  bool? get stringify => true;
}

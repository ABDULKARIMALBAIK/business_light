import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

import '../../utils/support/pagination_id.dart';

part 'product_order.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class ProductOrder extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? name;
  String? code;
  double? piecePrice;
  int? piecesQty;
  int? piecesPerPackage;
  double? packagePrice;
  int? packagesQty;
  int? productId;
  int? packagesQtyStore;
  String? imagePath;
  DateTime? date;

  @ignore
  @override
  List<Object?> get props => [
        id,
        name,
        code,
        piecePrice,
        piecesQty,
        piecesPerPackage,
        packagesQty,
        imagePath,
        date,
        productId,
        packagesQtyStore
      ];

  @override
  bool? get stringify => true;
}

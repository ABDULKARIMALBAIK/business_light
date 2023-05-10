import 'package:business_light/utils/support/pagination_id.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'company.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Company extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? name;
  String? phone;
  String? email;
  String? imagePath;
  String? address;
  String? bio;
  String? country;

  @ignore
  @override
  List<Object?> get props =>
      [id, name, phone, imagePath, address, bio, country, email];

  @override
  bool? get stringify => true;
}

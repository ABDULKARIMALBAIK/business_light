import 'package:business_light/utils/support/pagination_id.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class User extends PaginationId implements Equatable {
  Id? id = Isar.autoIncrement;
  String? fullName;
  String? password;
  String? email;
  String? phone;
  double? salary;
  String? jobDescription;
  String? imagePath;

  @enumerated
  UserLevel level = UserLevel.other;

  @ignore
  @override
  List<Object?> get props => [
        id,
        fullName,
        password,
        email,
        phone,
        jobDescription,
        level,
        imagePath,
        salary
      ];

  @override
  bool? get stringify => true;
}

/*
  UserLevels:
  1- Boss
  2- Manager
  3- Worker
  4- Customer
  5- other
 */
enum UserLevel { boss, manager, worker, customer, other }

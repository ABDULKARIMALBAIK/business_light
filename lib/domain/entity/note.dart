import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'note.g.dart';

@Collection(inheritance: false)
// ignore: must_be_immutable
class Note extends Equatable {
  Id? id = Isar.autoIncrement;
  String? title;
  String? description;

  @enumerated
  NoteLevel level = NoteLevel.low;

  @ignore
  @override
  List<Object?> get props => [id, title, description, level];
}

/*
  Status : 
  1- Low
  2- Medium
  3- High
  4- Very High
 */
enum NoteLevel { low, medium, high, veryHigh }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  final String userID;

  final String content;

  @JsonKey(fromJson: Note._parseDate)
  final DateTime createdAt;

  @JsonKey(fromJson: Note._parseDate)
  final DateTime updatedAt;

  Note({this.userID, this.content, this.createdAt, this.updatedAt});

  static DateTime _parseDate(Timestamp val) => val?.toDate();

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

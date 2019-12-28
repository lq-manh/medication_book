import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'note.g.dart';

@JsonSerializable()
class Note {
  String id;

  final String userID;

  String content;

  @JsonKey(fromJson: Note._parseDate, toJson: Note._parseTimestamp)
  DateTime reminder;

  int reminderNotiID;

  @JsonKey(fromJson: Note._parseDate, toJson: Note._parseTimestamp)
  DateTime createdAt;

  @JsonKey(fromJson: Note._parseDate, toJson: Note._autoTimestamp)
  final DateTime updatedAt;

  Note({
    this.id,
    this.userID,
    this.content,
    this.reminder,
    this.reminderNotiID,
    this.createdAt,
    this.updatedAt,
  });

  static DateTime _parseDate(Timestamp val) => val?.toDate();

  static DateTime _autoTimestamp(DateTime _) => DateTime.now();

  static DateTime _parseTimestamp(DateTime val) => val;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);
}

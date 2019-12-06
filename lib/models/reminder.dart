import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/session.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  String id;
  String prescID;
  String userID;
  bool isActive;
  int hour;
  int minute;
  String content;
  Session session;
  List<Drug> listDrug;

  Reminder(
      {this.id,
      this.prescID,
      this.userID,
      this.isActive,
      this.hour,
      this.minute,
      this.content,
      this.listDrug,
      this.session});

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}

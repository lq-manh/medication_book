import 'package:json_annotation/json_annotation.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  bool isActive;
  int hour;
  int minute;
  String content;

  Reminder({this.isActive, this.hour, this.minute, this.content});

  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);
  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}

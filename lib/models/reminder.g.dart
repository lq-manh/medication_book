// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return Reminder(
    isActive: json['isActive'] as bool,
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'isActive': instance.isActive,
      'hour': instance.hour,
      'minute': instance.minute,
      'content': instance.content,
    };

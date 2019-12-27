// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
    id: json['id'] as String,
    userID: json['userID'] as String,
    content: json['content'] as String,
    reminder: Note._parseDate(json['reminder'] as Timestamp),
    reminderNotiID: json['reminderNotiID'] as int,
    createdAt: Note._parseDate(json['createdAt'] as Timestamp),
    updatedAt: Note._parseDate(json['updatedAt'] as Timestamp),
  );
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'content': instance.content,
      'reminder': Note._parseTimestamp(instance.reminder),
      'reminderNotiID': instance.reminderNotiID,
      'createdAt': Note._parseTimestamp(instance.createdAt),
      'updatedAt': Note._autoTimestamp(instance.updatedAt),
    };

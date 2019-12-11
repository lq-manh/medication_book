// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) {
  return Note(
    userID: json['userID'] as String,
    content: json['content'] as String,
    createdAt: Note._parseDate(json['createdAt'] as Timestamp),
    updatedAt: Note._parseDate(json['updatedAt'] as Timestamp),
  );
}

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'userID': instance.userID,
      'content': instance.content,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

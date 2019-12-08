// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reminder _$ReminderFromJson(Map<String, dynamic> json) {
  return Reminder(
    id: json['id'] as String,
    prescID: json['prescID'] as String,
    userID: json['userID'] as String,
    notiID: json['notiID'] as int,
    isActive: json['isActive'] as bool,
    hour: json['hour'] as int,
    minute: json['minute'] as int,
    content: json['content'] as String,
    listDrug: (json['listDrug'] as List)
        ?.map(
            (e) => e == null ? null : Drug.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    session: _$enumDecodeNullable(_$SessionEnumMap, json['session']),
  );
}

Map<String, dynamic> _$ReminderToJson(Reminder instance) => <String, dynamic>{
      'id': instance.id,
      'prescID': instance.prescID,
      'userID': instance.userID,
      'notiID': instance.notiID,
      'isActive': instance.isActive,
      'hour': instance.hour,
      'minute': instance.minute,
      'content': instance.content,
      'session': _$SessionEnumMap[instance.session],
      'listDrug': instance.listDrug,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$SessionEnumMap = {
  Session.MORNING: 'MORNING',
  Session.EVENING: 'EVENING',
};

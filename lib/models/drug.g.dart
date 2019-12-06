// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drug.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drug _$DrugFromJson(Map<String, dynamic> json) {
  return Drug(
    sessions: (json['sessions'] as List)
        ?.map((e) => _$enumDecodeNullable(_$SessionEnumMap, e))
        ?.toList(),
    presId: json['presId'] as String,
    unit: json['unit'] as String,
    totalAmount: (json['totalAmount'] as num)?.toDouble(),
    dosage: (json['dosage'] as num)?.toDouble(),
    note: json['note'] as String,
    listReminder: (json['listReminder'] as List)
        ?.map((e) =>
            e == null ? null : Reminder.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$DrugToJson(Drug instance) => <String, dynamic>{
      'presId': instance.presId,
      'name': instance.name,
      'unit': instance.unit,
      'totalAmount': instance.totalAmount,
      'dosage': instance.dosage,
      'note': instance.note,
      'listReminder': instance.listReminder,
      'sessions': instance.sessions?.map((e) => _$SessionEnumMap[e])?.toList(),
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

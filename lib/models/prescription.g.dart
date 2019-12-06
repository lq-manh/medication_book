// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prescription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) {
  return Prescription(
    id: json['id'] as String,
    name: json['name'] as String,
    duration: (json['duration'] as num)?.toDouble(),
    notice: json['notice'] as String,
    userId: json['userId'] as String,
    desc: json['desc'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    drugStore: json['drugStore'] == null
        ? null
        : DrugStore.fromJson(json['drugStore'] as Map<String, dynamic>),
    listDrug: (json['listDrug'] as List)
        ?.map(
            (e) => e == null ? null : Drug.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'desc': instance.desc,
      'date': instance.date?.toIso8601String(),
      'duration': instance.duration,
      'notice': instance.notice,
      'drugStore': instance.drugStore,
      'listDrug': instance.listDrug,
    };

DrugStore _$DrugStoreFromJson(Map<String, dynamic> json) {
  return DrugStore(
    name: json['name'] as String,
    address: json['address'] as String,
    phoneNumber: json['phoneNumber'] as String,
  );
}

Map<String, dynamic> _$DrugStoreToJson(DrugStore instance) => <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
    };

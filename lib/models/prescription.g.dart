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
    userID: json['userID'] as String,
    desc: json['desc'] as String,
    date: json['date'] as String,
    drugStore: json['drugStore'] == null
        ? null
        : DrugStore.fromJson(json['drugStore'] as Map<String, dynamic>),
    listDrugs: (json['listDrugs'] as List)
        ?.map(
            (e) => e == null ? null : Drug.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PrescriptionToJson(Prescription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userID': instance.userID,
      'name': instance.name,
      'desc': instance.desc,
      'date': instance.date,
      'duration': instance.duration,
      'notice': instance.notice,
      'drugStore': instance.drugStore,
      'listDrugs': instance.listDrugs,
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

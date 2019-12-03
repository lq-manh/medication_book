// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    uid: json['uid'] as String,
    avatar: json['avatar'] as String,
    name: json['name'] as String,
    gender: json['gender'] as String,
    dateOfBirth: json['dateOfBirth'] as String,
    height: (json['height'] as num)?.toDouble(),
    weight: (json['weight'] as num)?.toDouble(),
    bloodType: json['bloodType'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'avatar': instance.avatar,
      'name': instance.name,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'height': instance.height,
      'weight': instance.weight,
      'bloodType': instance.bloodType,
    };

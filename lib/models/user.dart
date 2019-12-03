import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String avatar;
  final String name;
  final String gender;
  final String dateOfBirth;
  final double height;
  final double weight;
  final String bloodType;

  User({
    this.uid,
    this.avatar,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.bloodType,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

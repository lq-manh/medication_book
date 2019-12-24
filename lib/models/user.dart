import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String uid;
  final String avatar;
  final String name;
  final String gender;
  @JsonKey(fromJson: User._parseDate)
  final DateTime dateOfBirth;
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

  static DateTime _parseDate(Timestamp val) => val?.toDate();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  Map<String, dynamic> toFormJson() {
    return {
      "name": this.name,
      "gender": this.gender,
      "dateOfBirth": this.dateOfBirth,
      "height": this.height != null ? this.height.toString() : '',
      "weight": this.weight != null ? this.weight.toString() : '',
      "bloodType": this.bloodType,
    };
  }
}

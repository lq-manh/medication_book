import 'package:json_annotation/json_annotation.dart';

import 'drug.dart';

part 'prescription.g.dart';

@JsonSerializable()
class Prescription {
  String id;
  String userID;
  String name;
  String desc;
  String date;
  int duration;
  String notice;

  DrugStore drugStore;
  List<Drug> listDrugs;

  Prescription(
      {this.id,
      this.name,
      this.duration,
      this.notice,
      this.userID,
      this.desc,
      this.date,
      this.drugStore,
      this.listDrugs});

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
  Map<String, dynamic> toJson() => _$PrescriptionToJson(this);
}

@JsonSerializable()
class DrugStore {
  String name;
  String address;
  String phoneNumber;

  DrugStore({this.name, this.address, this.phoneNumber});

  factory DrugStore.fromJson(Map<String, dynamic> json) =>
      _$DrugStoreFromJson(json);
  Map<String, dynamic> toJson() => _$DrugStoreToJson(this);
}

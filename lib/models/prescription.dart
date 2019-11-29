import 'dart:convert';

import 'package:medication_book/models/drug.dart';

Prescription prescriptionFromJson(String str) {
  final jsonData = json.decode(str);
  return Prescription.fromMap(jsonData);
}

String prescriptionToJson(Prescription data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Prescription {
  String userId;
  String desc;

  DrugStore drugStore;
  List<Drug> listDrug;
  

  Prescription({this.userId, this.desc});

  factory Prescription.fromMap(Map<String, dynamic> json) => new Prescription(
    userId: json["userId"],
    desc: json["desc"]
  );

  Map<String, dynamic> toMap() => {
    "userId": userId,
    "desc": desc,
  };
}

class DrugStore {
  String name;
  String address;
  String phoneNumber;

  DrugStore({this.name, this.address, this.phoneNumber});

  factory DrugStore.fromMap(Map<String, dynamic> json) => new DrugStore(
    name: json["name"],
    address: json["address"],
    phoneNumber: json["phoneNumber"]
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "address": address,
    "phoneNumber": phoneNumber
  };
}

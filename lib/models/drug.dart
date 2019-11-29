import 'dart:convert';

import 'package:medication_book/models/reminder.dart';

Drug prescriptionFromJson(String str) {
  final jsonData = json.decode(str);
  return Drug.fromMap(jsonData);
}

String prescriptionToJson(Drug data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Drug {
  String presId;
  String name;
  String unit;
  String amount;
  String note;
  List<Reminder> listReminder;
  

  Drug({this.presId, this.name, this.unit, this.amount, this.note});

  factory Drug.fromMap(Map<String, dynamic> json) => new Drug(
    presId: json["presId"],
    name: json["name"],
    unit: json["unit"],
    amount: json["amount"],
    note: json["note"],
  );

  Map<String, dynamic> toMap() => {
    "presId": presId,
    "name": name,
    "unit": unit,
    "amount": amount,
    "note": note,
  };
}

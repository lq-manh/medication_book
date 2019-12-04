import 'dart:convert';

import 'package:medication_book/models/prescription.dart';

void main(List<String> args) {
  String json = '{ "domain": "medicationbook.teneocto.io", "data": { "prescription" : { "drugStore": { "name": "ABC Pharma", "address": "192 Cau Giay str", "phoneNumber": "0123456789" }, "desc": "Flu, headache", "date": "02/12/2019", "duration": 5, "notice": "Take after the meal.", "listDrug": [ { "name": "Paracetamol 50ml", "amount": 10, "unit": "pills", "sessions": ["MORNING", "EVENING"], "note": "After the meal" } ] } } }';

  var pre = jsonDecode(json);

  Prescription pres = Prescription.fromJson(pre["data"]["prescription"]);
  print(pres.listDrug[0].sessions[0]);
  print(jsonEncode(pres.toJson()));
}

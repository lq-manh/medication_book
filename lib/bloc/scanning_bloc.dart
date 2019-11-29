import 'package:medication_book/models/prescription.dart';
import 'dart:async';
import 'dart:convert';

// login bloc
class ScanningBloc {
  StreamController _resultStream = new StreamController();

  Stream get resultStream => _resultStream.stream;

  /// login via Google
  Future<Prescription> detect(dynamic contentJson) async {
    var content;

    try {
      content = jsonDecode(contentJson);
    } catch (e) {
      return null;
    }

    if (content["domain"] == "medicationbook.teneocto.io") {
      var presJson = content["data"]["prescription"];

      DrugStore drugStore = DrugStore.fromMap(presJson["drugStore"]);
      Prescription prescription = Prescription.fromMap(presJson);
      prescription.drugStore = drugStore;

      return prescription;
    }
    else {
      return null;
    }
  }

  void dispose() {
    _resultStream.close();
  }
}

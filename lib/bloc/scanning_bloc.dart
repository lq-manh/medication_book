import 'package:medication_book/models/prescription.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// login bloc
class ScanningBloc {
  StreamController _resultStream = new StreamController();

  Stream get resultStream => _resultStream.stream;

  /// login via Google
  Future<Prescription> detect(dynamic url) async {

    var res = await http.get(url);
    var content;

    try {
      content = jsonDecode(res.body);
    } catch (e) {
      return null;
    }

    if (content["domain"] == "medicationbook.teneocto.io") {
      var presJson = content["data"]["prescription"];

      // DrugStore drugStore = DrugStore.fromMap(presJson["drugStore"]);
      // Prescription prescription = Prescription.fromMap(presJson);
      // prescription.drugStore = drugStore;
      Prescription prescription = Prescription.fromJson(presJson);
      
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

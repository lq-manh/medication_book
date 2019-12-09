import 'package:medication_book/models/prescription.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

// login bloc
class ScanningBloc {
  StreamController _resultStream = new StreamController();

  Stream get resultStream => _resultStream.stream;

  /// login via Google
  Future<Prescription> detect(String url) async {
    if (!url.contains("http://api-medical.teneocto.io/"))
      return null;

    var res = await http.get(url);
    Map data;

    try {
      data = jsonDecode(res.body);

      // pre-process data - hardcode
      data.remove("id");
      data["duration"] = 5;
      data["desc"] = "Flu headache";

    } catch (e) {
      return null;
    }

    Prescription prescription = Prescription.fromJson(data);

    return prescription;
  }

  void dispose() {
    _resultStream.close();
  }
}

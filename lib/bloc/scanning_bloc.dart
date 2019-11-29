import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/utils/secure_store.dart';
import 'dart:async';
import 'dart:convert';

// login status
enum Status { DETECTED, UNDETECTED, WAITING }

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
      _resultStream.sink.add(Status.UNDETECTED);
      return null;
    }

    if (content["domain"] == "medicationbook.teneocto.io") {
      var presJson = content["data"]["prescription"];

      DrugStore drugStore = DrugStore.fromMap(presJson["drugStore"]);
      Prescription prescription = Prescription.fromMap(presJson);
      prescription.drugStore = drugStore;

       _resultStream.sink.add(Status.DETECTED);
       return prescription;
    }
    else {
      _resultStream.sink.add(Status.UNDETECTED);
      return null;
    }
  }

  void dispose() {
    _resultStream.close();
  }
}

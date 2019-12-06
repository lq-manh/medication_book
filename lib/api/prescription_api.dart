import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/models/prescription.dart';

class PrescriptionApi {
  static const COLLECTION_NAME = "prescriptions";
  static const USER_ID = "yjtNXFZvANPRWPeEBjkG";

  final Firestore _db = Firestore.instance;

  CollectionReference ref;

  PrescriptionApi() {
    ref = _db.collection(COLLECTION_NAME);
  }

  Future<Prescription> getPrescByUserID(String userID) async {
    QuerySnapshot q = await ref.where("userID", isEqualTo: userID).getDocuments();
    
  }

  Future<DocumentReference> addPresc(Prescription prescription) async {
    prescription.userId = USER_ID;
    prescription.name = "Prescription 1";

    var jsonPresc = prescription.toJson();
    var data = jsonDecode(jsonEncode(jsonPresc));

    DocumentReference doc = await ref.add(data);
    prescription.id = doc.documentID;
  }
}
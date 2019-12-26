import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/utils/secure_store.dart';

class PrescriptionApi {
  static const COLLECTION_NAME = "prescriptions";
  // static const USER_ID = "yjtNXFZvANPRWPeEBjkG";
  
  final Firestore _db = Firestore.instance;

  CollectionReference ref;

  PrescriptionApi() {
    ref = _db.collection(COLLECTION_NAME);
  }

  Future<List<Prescription>> getAllPresc() async {
    String uid = await SecureStorage.instance.read(key: 'uid');

    QuerySnapshot q = await ref.where("userID", isEqualTo: uid).getDocuments();

    List<Prescription> listPresc = [];

    for (var doc in q.documents) {
      Prescription presc = Prescription.fromJson(jsonDecode(jsonEncode(doc.data)));
      presc.id = doc.documentID;

      listPresc.add(presc);
    }

    return listPresc;
  }

  Future<Prescription> getPrescByID(String id) async {
    DocumentSnapshot doc = await ref.document(id).get();
    if (doc.exists) {
      Prescription presc = Prescription.fromJson(jsonDecode(jsonEncode(doc.data)));
      presc.id = doc.documentID;

      return presc;
    }
    else return null;
  }

  Future<void> addPresc(Prescription prescription) async {
    String uid = await SecureStorage.instance.read(key: 'uid');

    prescription.userID = uid;

    var jsonPresc = prescription.toJson();
    var data = jsonDecode(jsonEncode(jsonPresc));

    DocumentReference doc = await ref.add(data);
    prescription.id = doc.documentID;
  }

  updatePresc(Prescription presc) async {
    var jsonPresc = presc.toJson();
    var data = jsonDecode(jsonEncode(jsonPresc));

    return await ref.document(presc.id).updateData(data);
  }

  deletePresc(Prescription presc) async {
    return await ref.document(presc.id).delete();
  }
}

PrescriptionApi prescAPI = PrescriptionApi();

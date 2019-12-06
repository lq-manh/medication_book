import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';

class ReminderAPI {
  static const COLLECTION_NAME = "reminders";
  static const USER_ID = "yjtNXFZvANPRWPeEBjkG";

  final Firestore _db = Firestore.instance;

  CollectionReference ref;

  ReminderAPI() {
    ref = _db.collection(COLLECTION_NAME);
  }

  // Future<> getPrescByUserID(String userID) async {
  //   QuerySnapshot q = await ref.where("userID", isEqualTo: userID).getDocuments();
    
  // }

  Future<DocumentReference> addReminder(Reminder reminder) async {
    reminder.userID = USER_ID;
    
    var jsonReminder = reminder.toJson();
    var data = jsonDecode(jsonEncode(jsonReminder));

    return await ref.add(data);
  }
}
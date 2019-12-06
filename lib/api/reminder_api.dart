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

  Future<List<Reminder>> getActiveReminder() async {
    QuerySnapshot q = await ref
        .where("userID", isEqualTo: USER_ID)
        .where("isActive", isEqualTo: true)
        .getDocuments();

    List<Reminder> listReminder = [];

    for (int i = 0; i < q.documents.length; i++) {
      Reminder re = Reminder.fromJson(jsonDecode(jsonEncode(q.documents[i].data)));

      listReminder.add(re);
    }

    return listReminder;
  }

  Future<DocumentReference> addReminder(Reminder reminder) async {
    reminder.userID = USER_ID;

    var jsonReminder = reminder.toJson();
    var data = jsonDecode(jsonEncode(jsonReminder));

    return await ref.add(data);
  }
}

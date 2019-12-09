import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/utils/secure_store.dart';

class ReminderAPI {
  static const COLLECTION_NAME = "reminders";
  // static const USER_ID = "yjtNXFZvANPRWPeEBjkG";
  // final Future<String> uid = SecureStorage.instance.read(key: 'uid');

  final Firestore _db = Firestore.instance;

  CollectionReference ref;

  ReminderAPI() {
    ref = _db.collection(COLLECTION_NAME);
  }

  Future<List<Reminder>> getActiveReminder() async {
    String uid = await SecureStorage.instance.read(key: 'uid');

    QuerySnapshot q = await ref
        .where("userID", isEqualTo: uid)
        .where("isActive", isEqualTo: true)
        .getDocuments();

    List<Reminder> listReminder = [];

    for (int i = 0; i < q.documents.length; i++) {
      Reminder re = Reminder.fromJson(jsonDecode(jsonEncode(q.documents[i].data)));

      listReminder.add(re);
    }

    return listReminder;
  }

  Future<List<Reminder>> getRemindersByPrescID(String prescID) async {
    QuerySnapshot q = await ref
        .where("prescID", isEqualTo: prescID)
        .getDocuments();

    List<Reminder> listReminder = [];

    for (int i = 0; i < q.documents.length; i++) {
      Reminder re = Reminder.fromJson(jsonDecode(jsonEncode(q.documents[i].data)));
      re.id = q.documents[i].documentID;
      listReminder.add(re);
    }

    return listReminder;
  }

  Future<DocumentReference> addReminder(Reminder reminder) async {
    String uid = await SecureStorage.instance.read(key: 'uid');
    reminder.userID = uid;

    var jsonReminder = reminder.toJson();
    var data = jsonDecode(jsonEncode(jsonReminder));

    return await ref.add(data);
  }

  updateReminder(Reminder reminder) async {
    var jsonReminder = reminder.toJson();
    var data = jsonDecode(jsonEncode(jsonReminder));

    return await ref.document(reminder.id).updateData(data);
  }

  deleteReminderByPrescID(String prescID) async {
    QuerySnapshot q = await ref
        .where("prescID", isEqualTo: prescID)
        .getDocuments();
    
    for (DocumentSnapshot doc in q.documents) {
      await ref.document(doc.documentID).delete();
    }

    return;
  }
}

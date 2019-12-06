import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

class ReminderSettingsBloc {
  List<Reminder> analyzePresc(Prescription presc) {
    List<Drug> listDrug = presc.listDrug;

    Reminder morningReminder = new Reminder(
      isActive: true,
      content: "It's time to take your medicine ${presc.name}",
      hour: 8,
      minute: 0,
      session: Session.MORNING,
      listDrug: []
    );

    Reminder eveningReminder = new Reminder(
      isActive: true,
      content: "It's time to take your medicine ${presc.name}",
      hour: 20,
      minute: 0,
      session: Session.EVENING,
      listDrug: []
    );
    
    for (int i = 0; i < listDrug.length; i++) {
      Drug drug = listDrug[i];

      if (drug.sessions.contains(Session.MORNING)) {
        morningReminder.listDrug.add(drug);
      }

      if (drug.sessions.contains(Session.EVENING)) {
        eveningReminder.listDrug.add(drug);
      }
    }

    return [morningReminder, eveningReminder];
  }

  savePrescReminders(List<Reminder> reminders, Prescription presc) async {
    PrescriptionApi prescAPI = new PrescriptionApi();
    await prescAPI.addPresc(presc);
    
    ReminderAPI reminderAPI = new ReminderAPI();
    
    for (Reminder re in reminders) {
      re.prescID = presc.id;
      await reminderAPI.addReminder(re);
    }
  }
}

import 'dart:math';

import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'dart:async';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

class ReminderAnalyzerBloc {
  List<Reminder> analyzePresc(Prescription presc) {
    List<Drug> listDrug = presc.listDrugs;
    Random ran = new Random();

    Reminder morningReminder = new Reminder(
      notiID: ran.nextInt(99999),
      isActive: false,
      hour: 8,
      minute: 0,
      session: Session.MORNING,
      listDrug: []
    );

    Reminder eveningReminder = new Reminder(
      notiID: ran.nextInt(99999) + 1,
      isActive: false,
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

    if (morningReminder.listDrug.length > 0) morningReminder.isActive = true;
    if (eveningReminder.listDrug.length > 0) eveningReminder.isActive = true;

    return [morningReminder, eveningReminder];
  }

  Future<List<Reminder>> getReminders(Prescription presc) async {
    return await reminderAPI.getRemindersByPrescID(presc.id);
  } 

  savePrescReminders(List<Reminder> reminders, Prescription presc) async {
    await prescAPI.addPresc(presc);

    for (Reminder re in reminders) {
      re.prescID = presc.id;
      re.content = "It's time to take medicine " + presc.name;
      if (re.listDrug.length > 0) await reminderAPI.addReminder(re);
      if (re.isActive)
        await ApplicationBloc().notiController.addDailyReminder(re);
    }

    List<Prescription> prescList = ApplicationBloc().prescList;
    prescList.add(presc);
    ApplicationBloc().updatePrescList(prescList);

    List<Reminder> reminderList = ApplicationBloc().reminderList;
    reminderList.addAll(reminders);
    ApplicationBloc().updateReminderList(reminderList);
  }
}

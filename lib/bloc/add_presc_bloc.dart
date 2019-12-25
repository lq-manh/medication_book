import 'dart:math';

import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

class AddPrescBloc extends BlocBase {
  AddPrescBloc() {}

  createPresc(Prescription presc, List<Drug> listDrug) async {
    presc.listDrugs = listDrug;
    presc.drugStore = new DrugStore(name: "Medication Book App");

    List<Reminder> listReminder = analyzePresc(presc);

    await prescAPI.addPresc(presc);

    for (Reminder re in listReminder) {
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
    reminderList.addAll(listReminder);
    ApplicationBloc().updateReminderList(reminderList);
  }

  List<Reminder> analyzePresc(Prescription presc) {
    List<Drug> listDrug = presc.listDrugs;
    Random ran = new Random();

    Reminder morningReminder = new Reminder(
        notiID: ran.nextInt(99999),
        isActive: false,
        hour: 8,
        minute: 0,
        session: Session.MORNING,
        listDrug: []);

    Reminder eveningReminder = new Reminder(
        notiID: ran.nextInt(99999) + 1,
        isActive: false,
        hour: 20,
        minute: 0,
        session: Session.EVENING,
        listDrug: []);

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

  @override
  void dispose() {}
}

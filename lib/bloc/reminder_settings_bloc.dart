import 'dart:convert';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

class ReminderSettingsBloc extends BlocBase {
  ReminderSettingsBloc(this.prescID) {
    presc = ApplicationBloc().prescList.firstWhere((p) => p.id == prescID);
    clonedPresc =
        new Prescription.fromJson(jsonDecode(jsonEncode((presc.toJson()))));

    try {
      dayReminder = ApplicationBloc().reminderList.firstWhere(
          (re) => re.prescID == presc.id && re.session == Session.MORNING);
      clonedDayReminder =
          new Reminder.fromJson(jsonDecode(jsonEncode((dayReminder.toJson()))));
    } catch (e) {
      dayReminder = null;
    }

    try {
      nightReminder = ApplicationBloc().reminderList.firstWhere(
          (re) => re.prescID == presc.id && re.session == Session.EVENING);
      clonedNightReminder = new Reminder.fromJson(
          jsonDecode(jsonEncode((nightReminder.toJson()))));
    } catch (e) {
      nightReminder = null;
    }
  }

  String prescID;
  Prescription presc;
  Reminder dayReminder;
  Reminder nightReminder;

  Prescription clonedPresc;
  Reminder clonedDayReminder;
  Reminder clonedNightReminder;

  update() async {
    presc = clonedPresc;
    dayReminder = clonedDayReminder;
    nightReminder = clonedNightReminder;

    await prescAPI.updatePresc(presc);

    if (dayReminder != null) {
      dayReminder.content = "It's time to take medicine " + presc.name;
      await reminderAPI.updateReminder(dayReminder);
    }

    if (nightReminder != null) {
      nightReminder?.content = "It's time to take medicine " + presc.name;
      await reminderAPI.updateReminder(nightReminder);
    }

    List<Prescription> listPresc = ApplicationBloc().prescList;
    for (int i = 0; i < listPresc.length; i++) {
      if (listPresc[i].id == presc.id) listPresc[i] = presc;
    }

    List<Reminder> listReminder = ApplicationBloc().reminderList;
    for (int i = 0; i < listReminder.length; i++) {
      if (listReminder[i].id == dayReminder?.id) {
        listReminder[i] = dayReminder;
      }

      if (listReminder[i].id == nightReminder?.id) {
        listReminder[i] = nightReminder;
      }
    }

    ApplicationBloc().updatePrescList(listPresc);
    ApplicationBloc().updateReminderList(listReminder);
  }

  @override
  void dispose() {}
}

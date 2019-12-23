import 'dart:async';

import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class DashBoardBloc implements BlocBase {
  DashBoardBloc() {
    _prescSub = prescListController.listen((list) {
      prescList = list;

      _reminderSub = reminderListController.listen((list) {
        reminderList = list;

        getData(DateTime.now());
      });
    });
  }

  BehaviorSubject<List<Prescription>> prescListController = ApplicationBloc().prescListStream;
  BehaviorSubject<List<Reminder>> reminderListController = ApplicationBloc().reminderListStream;

  StreamSubscription _prescSub;
  StreamSubscription _reminderSub;

  List<Prescription> prescList;
  List<Reminder> reminderList;

  BehaviorSubject<List<Reminder>> dayReminderController =
      BehaviorSubject<List<Reminder>>();
  BehaviorSubject<List<Reminder>> nightReminderController =
      BehaviorSubject<List<Reminder>>();

  List<Reminder> dayReminders;
  List<Reminder> nightReminders;

  getData(DateTime day) async {
    dayReminders = [];
    nightReminders = [];

    for (Reminder re in reminderList) {
      Prescription presc = prescList.firstWhere((p) => p.id == re.prescID);

      DateTime startDate = Utils.convertStringToDate(presc.date);
      startDate = new DateTime(startDate.year, startDate.month, startDate.day);

      DateTime endDate = startDate.add(Duration(days: presc.duration));
      endDate = new DateTime(endDate.year, endDate.month, endDate.day, 23, 59);

      if (day.isAfter(startDate) && day.isBefore(endDate)) {
        // reCtrl.addDailyReminder(re);
        if (re.session == Session.MORNING && re.isActive) dayReminders.add(re);
        if (re.session == Session.EVENING && re.isActive) nightReminders.add(re);
      } else {
        if (!day.isBefore(endDate)) {
          // reCtrl.cancelDailyReminder(re);
          // re.isActive = false;
          // await reminderAPI.updateReminder(re);
        }
      }
    }

    Utils.sortTimeReminder(dayReminders);
    Utils.sortTimeReminder(nightReminders);

    dayReminderController.sink.add(dayReminders);
    nightReminderController.sink.add(nightReminders);
  }

  @override
  void dispose() {
    _prescSub.cancel();
    _reminderSub.cancel();
    dayReminderController.close();
    nightReminderController.close();
    // prescListController.close();
    // reminderListController.close();
  }
}

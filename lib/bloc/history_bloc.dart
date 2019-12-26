import 'dart:async';

import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:rxdart/rxdart.dart';

class HistoryBloc extends BlocBase {
  HistoryBloc() {
    _prescSub = ApplicationBloc().prescListStream.listen((list) {
      prescList = list;

      _prescListController.sink.add(list);
    });
  }

  BehaviorSubject<List<Prescription>> _prescListController = BehaviorSubject<List<Prescription>>();
  Stream<List<Prescription>> get prescListStream => _prescListController.stream;
  
  StreamSubscription _prescSub;

  List<Prescription> prescList;

  deletePresc(Prescription presc) async {
    await reminderAPI.deleteReminderByPrescID(presc.id);

    await prescAPI.deletePresc(presc);

    prescList.remove(presc);

    List<Reminder> listReminder = ApplicationBloc().reminderList;
    for (Reminder re in listReminder) {
      await ApplicationBloc().notiController.cancelDailyReminder(re);
    }
    listReminder.removeWhere((re) => re.prescID == presc.id);

    ApplicationBloc().updateReminderList(listReminder);
    ApplicationBloc().updatePrescList(prescList);

    _prescListController.sink.add(prescList);
  }

  @override
  void dispose() {
    _prescSub.cancel();
    _prescListController.close();
  }
}
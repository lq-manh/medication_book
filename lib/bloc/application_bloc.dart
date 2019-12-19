import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  BehaviorSubject<List<Prescription>> _prescController = BehaviorSubject<List<Prescription>>();
  Stream<List<Prescription>> get listPresc => _prescController.stream;

  BehaviorSubject<List<Reminder>> _reminderController = BehaviorSubject<List<Reminder>>();
  Stream<List<Reminder>> get listReminder => _reminderController.stream;

  List<Prescription> prescList;
  List<Reminder> reminderList;

  ApplicationBloc() {
    init();
  }

  init() async {
    prescList = await prescAPI.getAllPresc();
    _prescController.sink.add(prescList);

    reminderList = await reminderAPI.getActiveReminder();
    _reminderController.sink.add(reminderList);
  }

  @override
  void dispose() {
    _prescController.close();
    _reminderController.close();
  }

}

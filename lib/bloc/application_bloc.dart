import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

class ApplicationBloc implements BlocBase {
  static final ApplicationBloc _singleton = new ApplicationBloc._internal();

  factory ApplicationBloc() {
    return _singleton;
  }

  ApplicationBloc._internal();

  BehaviorSubject<List<Prescription>> _prescController =
      BehaviorSubject<List<Prescription>>();
  Stream<List<Prescription>> get prescListStream => _prescController.stream;

  BehaviorSubject<List<Reminder>> _reminderController =
      BehaviorSubject<List<Reminder>>();
  Stream<List<Reminder>> get reminderListStream => _reminderController.stream;

  BehaviorSubject<bool> _blurredController = BehaviorSubject<bool>();
  Stream<bool> get blurredStream => _blurredController.stream;

  bool isBlurred;

  List<Prescription> prescList = [];
  List<Reminder> reminderList = [];

  ReminderController notiController;

  init() async {
    isBlurred = false;
    _blurredController.sink.add(isBlurred);

    prescList = await prescAPI.getAllPresc();
    _prescController.sink.add(prescList);

    reminderList = await reminderAPI.getAllReminders();
    _reminderController.sink.add(reminderList);

    notiController = new ReminderController();
    await notiController.init();
    await notiController.cancelAllDailyReminder();

    await disableOverduePresc();

    // for (Reminder re in reminderList) {
    //   if (re.isActive)
    //     await notiController.addDailyReminder(re);
    //   else
    //     await notiController.cancelDailyReminder(re);
    // }
  }

  disableOverduePresc() async {
    for (Prescription p in prescList) {
      if (Utils.checkActive(p) == false) {
        for (Reminder re in reminderList) {
          if (re.prescID == p.id) {
            re.isActive = false;
            await reminderAPI.updateReminder(re);
          } else {
            if (re.isActive)
              await notiController.addDailyReminder(re);
            else
              await notiController.cancelDailyReminder(re);
          }
        }
      }
    }
  }

  updatePrescList(List<Prescription> list) {
    prescList = list;
    _prescController.sink.add(list);
  }

  updateReminderList(List<Reminder> list) {
    reminderList = list;
    _reminderController.sink.add(list);
  }

  changeBlurredOverlay() {
    isBlurred = !isBlurred;
    _blurredController.sink.add(isBlurred);
  }

  @override
  void dispose() {
    _blurredController.close();
    _prescController.close();
    _reminderController.close();
  }
}

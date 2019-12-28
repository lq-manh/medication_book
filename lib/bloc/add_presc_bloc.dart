import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/configs/configs.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/utils/utils.dart';

class AddPrescBloc extends BlocBase {
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
    prescList.insert(0, presc);
    ApplicationBloc().updatePrescList(prescList);

    List<Reminder> reminderList = ApplicationBloc().reminderList;
    reminderList.addAll(listReminder);
    ApplicationBloc().updateReminderList(reminderList);
  }

  List<Reminder> analyzePresc(Prescription presc) {
    List<Drug> listDrug = presc.listDrugs;

    Reminder morningReminder = new Reminder(
      notiID: Utils.randomInRange(
        Configs.medicineNotiIDRange[0],
        Configs.medicineNotiIDRange[1],
      ),
      isActive: false,
      hour: 8,
      minute: 0,
      session: Session.MORNING,
      listDrug: [],
    );

    Reminder eveningReminder = new Reminder(
      notiID: Utils.randomInRange(
        Configs.medicineNotiIDRange[0],
        Configs.medicineNotiIDRange[1],
      ),
      isActive: false,
      hour: 20,
      minute: 0,
      session: Session.EVENING,
      listDrug: [],
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

    List<Reminder> reminderList = [];

    if (morningReminder.listDrug.length > 0) {
      morningReminder.isActive = true;
      reminderList.add(morningReminder);
    }
    if (eveningReminder.listDrug.length > 0) {
      eveningReminder.isActive = true;
      reminderList.add(eveningReminder);
    }

    return reminderList;
  }

  @override
  void dispose() {}
}

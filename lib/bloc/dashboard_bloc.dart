import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';

class DashBoardBloc implements BlocBase{
  Stream<Prescription> prescNameStream(Reminder re) async* {
    PrescriptionApi prescApi = new PrescriptionApi();

    Prescription p = await prescApi.getPrescByID(re.prescID);

    if (p != null) {
      yield p;
    }
  }

  @override
  void dispose() {
    
  }
}
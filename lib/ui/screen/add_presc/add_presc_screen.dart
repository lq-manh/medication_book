import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/add_presc/add_drug_screen.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/text_input.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';

class AddPrescScreen extends StatefulWidget {
  @override
  _AddPrescScreenState createState() => _AddPrescScreenState();
}

class _AddPrescScreenState extends State<AddPrescScreen> {
  Prescription presc;
  List<Drug> listDrug;

  PrescriptionApi prescAPI = new PrescriptionApi();
  ReminderAPI reminderAPI = new ReminderAPI();

  ReminderController reCtrl = new ReminderController();

  bool isSaving = false;

  TextEditingController prescNameCtrl;
  TextEditingController prescDescCtrl;
  TextEditingController prescDurationCtrl;
  TextEditingController prescStartDayCtrl;
  TextEditingController prescEndDayCtrl;

  TextEditingController drugNameCtrl;
  TextEditingController drugNoteCtrl;
  TextEditingController drugAmountCtrl;
  TextEditingController drugDosageCtrl;

  @override
  void initState() {
    super.initState();

    reCtrl.init();

    presc = new Prescription(
        name: "My Prescription",
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        desc: "Your illness",
        duration: 3,
        drugStore: null);

    listDrug = [];

    prescNameCtrl = new TextEditingController(text: presc.name);
    prescDescCtrl = new TextEditingController(text: presc.desc);

    prescDurationCtrl =
        new TextEditingController(text: presc.duration.toString());

    prescStartDayCtrl =
        new TextEditingController(text: Utils.convertDatetime(presc.date));

    prescEndDayCtrl = new TextEditingController(
        text: Utils.getNextDay(presc.date, presc.duration));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ContentLayout(
        topBar: TopBar(
          title: 'Add Prescription',
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        main: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                renderPrescEdit(),
                SizedBox(height: 20),
                renderDrugsEdit(),
                SizedBox(height: 20),
                renderAddPrescBtn(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderPrescEdit() {
    return Column(
      children: <Widget>[
        Heading(
          title: "Prescription",
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              TextInput(
                label: "Presc Name",
                ctrl: prescNameCtrl,
                suffix: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ), 
                onSubmitted: (text) {
                  presc.name = text;
                },
                onChanged: (text) {
                  presc.name = text;
                },
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Description",
                ctrl: prescDescCtrl,
                suffix: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
                onSubmitted: (text) {
                  presc.desc= text;
                },
                onChanged: (text) {
                  presc.desc = text;
                },
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Duration",
                ctrl: prescDurationCtrl,
                suffix: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
                textInputType: TextInputType.number,
                onSubmitted: (number) {
                  int duration = int.parse(number);
                  
                  presc.duration = duration;

                  prescEndDayCtrl.text =
                      Utils.getNextDay(presc.date, duration);
                },
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Start Day",
                ctrl: prescStartDayCtrl,
                enabled: false,
                inputFontSize: 16,
              ),
              TextInput(
                label: "End Day",
                ctrl: prescEndDayCtrl,
                enabled: false,
                inputFontSize: 16,
              ),
            ],
          ),
        )
      ],
    );
  }

  renderDrugsEdit() {
    return Column(
      children: <Widget>[
        Heading(
          title: "Drugs",
          action: IconButton(
            icon: Icon(FontAwesomeIcons.plusCircle),
            iconSize: 20,
            color: ColorPalette.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDrugScreen(listDrug: listDrug),
                ),
              );
            },
          ),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 0),
            itemCount: listDrug.length,
            itemBuilder: (context, index) {
              Drug drug = listDrug[index];
              return DrugItem(
                drug: drug,
                showSession: true,
              );
            },
          ),
        )
      ],
    );
  }

  renderAddPrescBtn() {
    if (isSaving)
      return LoadingCircle();

    return LargeButton(
      title: "Add Prescription",
      onPressed: createPresc,
    );
  }

  createPresc() async {
    setState(() {
      isSaving = true;
    });

    presc.listDrugs = listDrug;
    presc.drugStore = new DrugStore(
        name: "Medication Book App",
        address: "Some where",
        phoneNumber: "0123456789");

    List<Reminder> listReminder = analyzePresc(presc);

    await reCtrl.init();
    await prescAPI.addPresc(presc);

    for (Reminder re in listReminder) {
      re.prescID = presc.id;
      re.content = "It's time to take medicine " + presc.name;
      if (re.listDrug.length > 0) await reminderAPI.addReminder(re);

      if (re.isActive) await reCtrl.addDailyReminder(re);
    }

    Navigator.pop(context);
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
}

class Heading extends StatelessWidget {
  final String title;
  final Widget action;

  Heading({Key key, this.title, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: ColorPalette.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          action == null ? Container() : action,
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

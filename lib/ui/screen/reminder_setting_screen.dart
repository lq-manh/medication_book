import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/time_picker.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';

class ReminderSettingScreen extends StatefulWidget {
  final Prescription prescription;

  const ReminderSettingScreen({Key key, @required this.prescription})
      : super(key: key);

  @override
  _ReminderSettingScreenState createState() => _ReminderSettingScreenState();
}

class _ReminderSettingScreenState extends State<ReminderSettingScreen> {
  List<Reminder> listReminder;
  ReminderAPI reminderAPI = new ReminderAPI();
  PrescriptionApi prescriptionApi = new PrescriptionApi();
  Reminder morningReminder;
  Reminder eveningReminder;

  TextEditingController prescNameCtrl;

  bool loading = true;
  bool isSaving = false;

  ReminderController reCtrl = new ReminderController();

  @override
  void initState() {
    super.initState();
    prescNameCtrl = new TextEditingController(text: widget.prescription.name);

    reminderAPI
        .getRemindersByPrescID(widget.prescription.id)
        .then((list) async {
      listReminder = list;

      for (Reminder re in listReminder) {
        if (re.session == Session.MORNING) morningReminder = re;
        if (re.session == Session.EVENING) eveningReminder = re;
      }

      await Future.delayed(Duration(seconds: 1));

      loading = false;

      setState(() {});
    });

    reCtrl.init();
  }

  updatePrescReminder() async {
    await prescriptionApi.updatePresc(widget.prescription);

    for (Reminder re in listReminder) {
      re.content = "It's time to take medicine " + widget.prescription.name;
      await reminderAPI.updateReminder(re);

      if (re.isActive)
        await reCtrl.addDailyReminder(re);
      else
        await reCtrl.cancelDailyReminder(re);
    }

    Fluttertoast.showToast(msg: "Saved");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentLayout(
        topBar: TopBar(
          title: 'Reminder Setting',
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          action: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(right: 10),
            // color: Colors.blue,
            child: isSaving
                ? LoadingCircle(
                    color: ColorPalette.white,
                    size: 20,
                    strokeWidth: 2,
                  )
                : renderSaveAction(),
          ),
        ),
        main: Container(
          width: MediaQuery.of(context).size.width,
          child: loading
              ? LoadingCircle()
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      renderPrescInfo(),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      renderReminderItem(morningReminder),
                      // SizedBox(height: 20),
                      renderReminderItem(eveningReminder),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  renderSaveAction() {
    return InkWell(
      onTap: () async {
        setState(() {
          isSaving = true;
        });

        await updatePrescReminder();

        setState(() {
          isSaving = false;
        });
      },
      child: Center(
        child: Text(
          "Save",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
          // textAlign: TextAlign.center,
        ),
      ),
    );
  }

  renderPrescInfo() {
    TextStyle fieldStyle = TextStyle(
      color: ColorPalette.blue,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    TextStyle fieldStyle2 = TextStyle(
        color: ColorPalette.blacklight,
        fontSize: 16,
        fontWeight: FontWeight.w300);

    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "Presc Name",
                  style: fieldStyle,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: prescNameCtrl,
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorPalette.blue, width: 1),
                        ),
                        enabledBorder: InputBorder.none,
                        suffix: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.edit,
                            size: 14,
                            color: ColorPalette.blue,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: ColorPalette.blacklight,
                      ),
                      onSubmitted: (text) {
                        widget.prescription.name = text;
                      },
                      onChanged: (text) {
                        widget.prescription.name = text;
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text("Description", style: fieldStyle),
                Expanded(
                  child: Text(
                    widget.prescription.desc,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: fieldStyle2,
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text("Duration", style: fieldStyle),
                Expanded(
                  child: Text(
                    widget.prescription.duration.toString() + " days",
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: fieldStyle2,
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text("Start Date", style: fieldStyle),
                Expanded(
                  child: Text(
                    Utils.convertDatetime(widget.prescription.date),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: fieldStyle2,
                  ),
                )
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: <Widget>[
                Text("End Date", style: fieldStyle),
                Expanded(
                  child: Text(
                    Utils.getNextDay(widget.prescription.date,
                        widget.prescription.duration),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: fieldStyle2,
                  ),
                )
              ],
            ),
          ],
        ));
  }

  renderReminderItem(Reminder re) {
    if (re == null) return Container();

    if (re.listDrug.length > 0)
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Utils.getSessionIcon(re.session, 24),
                    SizedBox(width: 10),
                    Text(
                      Utils.convertSessionToString(re.session),
                      style: TextStyle(
                          color: ColorPalette.blacklight,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Text(
                        TimeOfDay(hour: re.hour, minute: re.minute)
                            .format(context),
                        style: TextStyle(
                            color: ColorPalette.green,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      Icon(
                        FontAwesomeIcons.caretDown,
                        color: ColorPalette.green,
                      )
                    ],
                  ),
                  onTap: () {
                    showTimePicker(re);
                  },
                ),
                Switch(
                  value: re.isActive,
                  activeColor: ColorPalette.blue,
                  onChanged: (value) async {
                    re.isActive = value;
                    setState(() {});

                    // if (value) {
                    //   await reCtrl.addDailyReminder(re);
                    //   Fluttertoast.showToast(msg: "Turned On");
                    // }
                    // else {
                    //   await reCtrl.cancelDailyReminder(re);
                    //   Fluttertoast.showToast(msg: "Turned Off");
                    // }
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Container(
            height: 150,
            // color: Colors.blue,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 0),
              itemCount: re.listDrug.length,
              itemBuilder: (context, index) {
                Drug drug = re.listDrug[index];
                return DrugItem(drug: drug);
              },
            ),
          )
        ],
      );
    else
      return Container();
  }

  showTimePicker(Reminder re) {
    TimeOfDay time = TimeOfDay(hour: re.hour, minute: re.minute);

    DatePicker.showPicker(context, showTitleActions: true, onConfirm: (date) {
      re.hour = date.hour;
      re.minute = date.minute;

      setState(() {});
    },
        pickerModel: TimePicker(session: re.session, time: time),
        locale: LocaleType.en);
  }
}

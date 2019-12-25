import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/bloc/reminder_analyzer_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/time_picker.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class ReminderAnalyzerScreen extends StatefulWidget {
  final Prescription prescription;

  const ReminderAnalyzerScreen({Key key, @required this.prescription})
      : super(key: key);

  @override
  _ReminderAnalyzerScreenState createState() => _ReminderAnalyzerScreenState();
}

class _ReminderAnalyzerScreenState extends State<ReminderAnalyzerScreen> {
  ReminderAnalyzerBloc reminderBloc = new ReminderAnalyzerBloc();
  List<Reminder> listReminder;

  TextEditingController prescNameCtrl;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    widget.prescription.name = "My Prescription";
    listReminder = reminderBloc.analyzePresc(widget.prescription);

    prescNameCtrl = new TextEditingController(text: widget.prescription.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentLayout(
        topBar: TopBar(
          title: 'Reminder Settings',
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          action: Container(),
        ),
        main: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                renderPrescInfo(),
                SizedBox(
                  height: 20,
                ),
                renderReminderItem(listReminder[0]),
                SizedBox(
                  height: 20,
                ),
                renderReminderItem(listReminder[1]),
                SizedBox(
                  height: 20,
                ),
                renderDoneBtn(),
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

  renderPrescInfo() {
    TextStyle fieldStyle = TextStyle(
      color: ColorPalette.blue,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

    TextStyle fieldStyle2 = TextStyle(
        color: ColorPalette.blacklight,
        fontSize: 18,
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
                          )),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: ColorPalette.blacklight,
                      ),
                      onSubmitted: (text) {
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
                    Utils.getNextDay(widget.prescription.date, widget.prescription.duration),
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
                          fontSize: 24,
                          fontWeight: FontWeight.w300),
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
                            fontSize: 30,
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
                CupertinoSwitch(
                  value: re.isActive,
                  activeColor: ColorPalette.blue,
                  onChanged: (value) {
                    re.isActive = value;
                    setState(() {});
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          Container(
            height: 150,
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

  renderDoneBtn() {
    if (isSaving)
      return LoadingCircle();
    else
      return LargeButton(
        title: "Done",
        onPressed: () async {
          setState(() {
            isSaving = true;
          });

          await reminderBloc.savePrescReminders(
              listReminder, widget.prescription);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
        },
      );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/reminder_settings_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/heading.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/time_picker.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';

class ReminderSettingScreen extends StatefulWidget {
  final String prescID;

  const ReminderSettingScreen({Key key, @required this.prescID})
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

  ReminderSettingsBloc _bloc;

  TextEditingController prescNameCtrl;

  bool loading = true;
  bool isSaving = false;
  bool expired = false;

  ReminderController reCtrl = new ReminderController();

  @override
  void initState() {
    super.initState();

    _bloc = ReminderSettingsBloc(widget.prescID);

    prescNameCtrl = new TextEditingController(text: _bloc.clonedPresc.name);
    expired = !Utils.checkActive(_bloc.clonedPresc);
  }

  updatePrescReminder() async {
    await _bloc.update();

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
            child: expired
                ? Container()
                : isSaving
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                renderExprired(),
                SizedBox(height: 10),
                Heading(
                  title: "Prescription",
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: RoundedCard(
                    child: renderPrescInfo(),
                  ),
                ),
                SizedBox(height: 30),
                Heading(
                  title: "Reminders",
                ),
                SizedBox(height: 20),
                renderReminderItem(_bloc.clonedDayReminder),
                SizedBox(height: 20),
                renderReminderItem(_bloc.clonedNightReminder),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderExprired() {
    if (expired) {
      return Container(
        color: ColorPalette.white,
        padding: EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.warning,
              color: ColorPalette.sunOrange,
            ),
            SizedBox(width: 5),
            Text(
              "This prescription is expired",
              style: TextStyle(
                  color: ColorPalette.sunOrange, fontWeight: FontWeight.w600),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      );
    }

    return Container();
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
            color: ColorPalette.white,
          ),
          // textAlign: TextAlign.center,
        ),
      ),
    );
  }

  renderPrescInfo() {
    TextStyle fieldStyle = TextStyle(
      color: ColorPalette.blue,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    );

    TextStyle fieldStyle2 = TextStyle(
      color: ColorPalette.darkerGrey,
      fontSize: 18,
      fontWeight: FontWeight.w500,
    );

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
                        fontWeight: FontWeight.w300,
                        color: ColorPalette.darkerGrey,
                      ),
                      onSubmitted: (text) {
                        _bloc.clonedPresc.name = text;
                      },
                      onChanged: (text) {
                        _bloc.clonedPresc.name = text;
                      },
                      enabled: !expired,
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
                    _bloc.clonedPresc.desc,
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
                    _bloc.clonedPresc.duration.toString() + " days",
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
                    Utils.convertDatetime(_bloc.clonedPresc.date),
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
                    Utils.getNextDay(
                        _bloc.clonedPresc.date, _bloc.clonedPresc.duration),
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
                    Utils.getSessionIcon(re.session, 30),
                    SizedBox(width: 10),
                    Text(
                      Utils.convertSessionToString(re.session),
                      style: TextStyle(
                        color: ColorPalette.darkerGrey,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
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
                    if (!expired) {
                      showTimePicker(re);
                    }
                  },
                ),
                CupertinoSwitch(
                  value: re.isActive,
                  activeColor: ColorPalette.blue,
                  onChanged: (value) async {
                    if (!expired) {
                      re.isActive = value;
                      setState(() {});
                    }
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
}

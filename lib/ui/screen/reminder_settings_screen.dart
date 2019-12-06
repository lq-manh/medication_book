import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/bloc/reminder_settings_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class ReminderSettingsScreen extends StatefulWidget {
  final Prescription prescription;

  const ReminderSettingsScreen({Key key, @required this.prescription})
      : super(key: key);

  @override
  _ReminderSettingsScreenState createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  ReminderSettingsBloc reminderBloc = new ReminderSettingsBloc();
  List<Reminder> listReminder;

  @override
  void initState() {
    super.initState();

    listReminder = reminderBloc.analyzePresc(widget.prescription);
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorPalette.blue.withOpacity(0.2),
                ColorPalette.green.withOpacity(0.2),
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                renderDuration(),
                renderPresName(),
                SizedBox(
                  height: 30,
                ),
                renderReminderItem(listReminder[0]),
                // SizedBox(height: 20),
                renderReminderItem(listReminder[1]),
                SizedBox(
                  height: 30,
                ),
                LargeButton(
                  title: "Done",
                  onPressed: () async {
                    await reminderBloc.savePrescReminders(
                        listReminder, widget.prescription);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (Route<dynamic> route) => false);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderDuration() {
    return Container(child: Text("5 days"));
  }

  renderPresName() {
    return Container(child: Text("Prescription 1"));
  }

  renderReminderItem(Reminder re) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Utils.getSessionIcon(re.session),
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
              Row(
                children: <Widget>[
                  Text(TimeOfDay(hour: re.hour, minute: re.minute)
                      .format(context)),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.pen),
                    onPressed: () {
                      DatePicker.showTimePicker(context, showTitleActions: true,
                          onChanged: (date) {
                        print('change $date in time zone ' +
                            date.timeZoneOffset.inHours.toString());
                      }, onConfirm: (date) {
                        print('confirm $date');
                      }, currentTime: DateTime.now());
                    },
                  )
                ],
              ),
              Switch(
                value: true,
                activeColor: ColorPalette.blue,
                onChanged: (value) {},
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
  }
}

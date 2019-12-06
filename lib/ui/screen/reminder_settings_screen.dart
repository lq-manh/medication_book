import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/bloc/reminder_settings_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

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
                    await reminderBloc.savePrescReminders(listReminder, widget.prescription);
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
              Text(re.session.toString()),
              Text(TimeOfDay(hour: re.hour, minute: re.minute).format(context)),
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
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10, right: 10, bottom: 20),
                  child: RoundedCard(
                      child: Container(
                    width: 250,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  drug.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ColorPalette.blue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  drug.note,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: ColorPalette.blacklight,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/image/medicineIcon.png",
                                height: 40,
                              ),
                              Text(
                                (drug.dosage > drug.dosage.floor()
                                        ? drug.dosage.toString()
                                        : drug.dosage.floor().toString()) +
                                    " " +
                                    drug.unit,
                                style: TextStyle(
                                  color: ColorPalette.blacklight,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                      ),
                    ),
                  )),
                );
            },
          ),
        )
      ],
    );
  }
}

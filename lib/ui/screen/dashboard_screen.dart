import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/dashboard_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/reminder_setting_screen.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashBoardBloc bloc = new DashBoardBloc();
  List<Reminder> listReminder;
  List<Reminder> morningReminders;
  List<Reminder> eveningReminders;
  ReminderController reCtrl = new ReminderController();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    loading = true;
    setState(() {});

    listReminder = [];
    morningReminders = [];
    eveningReminders = [];
    ReminderAPI reminderAPI = new ReminderAPI();
    await reCtrl.cancelAllDailyReminder();

    listReminder = await reminderAPI.getActiveReminder();
    for (Reminder re in listReminder) {
      if (re.isActive) reCtrl.addDailyReminder(re);
      if (re.session == Session.MORNING) morningReminders.add(re);
      if (re.session == Session.EVENING) eveningReminders.add(re);
    }

    Utils.sortTimeReminder(morningReminders);
    Utils.sortTimeReminder(eveningReminders);

    Future.delayed(Duration(seconds: 1)).then((v) {
      loading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentLayout(
      topBar: TopBar(
        title: 'Reminders',
        // bottom: Container(),
        leading: Container(),
        action: Container(),
      ),
      main: Container(
        child: loading
            ? LoadingCircle()
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    renderSessionReminder(Session.MORNING, morningReminders),
                    // SizedBox(height: 15),
                    renderSessionReminder(Session.EVENING, eveningReminders),
                    SizedBox(height: 30),
                  ],
                ),
              ),
      ),
    );
  }

  renderSessionReminder(Session session, List<Reminder> reminders) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: <Widget>[
              Utils.getSessionIcon(session, 24),
              SizedBox(width: 10),
              Text(
                Utils.convertSessionToString(session),
                style: TextStyle(
                    color: ColorPalette.blacklight,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        if (reminders.length > 0)
          Column(
            children: renderListReminder(session, reminders),
          )
        else
          renderEmpty()
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  renderListReminder(Session session, List<Reminder> reminders) {
    return reminders.map((re) {
      if (re.session == session && re.listDrug.length > 0) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder(
                stream: bloc.prescNameStream(re),
                builder: (context, snap) {
                  if (snap.hasData) {
                    Prescription presc = snap.data;
                    return rendertimeRow(re, presc);
                  } else
                    return Container();
                },
              ),
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: re.listDrug.length,
                itemBuilder: (context, index) {
                  Drug drug = re.listDrug[index];
                  return DrugItem(drug: drug);
                },
              ),
            ),
            SizedBox(height: 15)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        );
      } else
        return Container();
    }).toList();
  }

  rendertimeRow(Reminder re, Prescription presc) {
    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReminderSettingScreen(prescription: presc)));

        getData();
      },
      child: Row(
        children: <Widget>[
          Text(
            TimeOfDay(hour: re.hour, minute: re.minute).format(context),
            style: TextStyle(
              color: ColorPalette.green,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              presc.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorPalette.blacklight,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Icon(
            FontAwesomeIcons.longArrowAltRight,
            size: 20,
            color: ColorPalette.blue,
          ),
        ],
      ),
    );
  }

  renderEmpty() {
    return Center(
      child: Column(
        children: <Widget>[
          // ColorFiltered(
          //   colorFilter: ColorFilter.mode(Colors.white, BlendMode.modulate),
          //   child: Image.asset(
          //     "assets/image/schedule.png",
          //     width: 120,
          //   ),
          // ),
          Image.asset(
            "assets/image/schedule.png",
            width: 120,
          ),
          Text(
            "No Reminder",
            style: TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          )
        ],
      ),
    );
  }
}

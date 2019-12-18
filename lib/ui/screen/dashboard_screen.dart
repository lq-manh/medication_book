import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/dashboard_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/listDate.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/reminder_setting_screen.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/ui/widgets/date_slider.dart';
import 'package:medication_book/utils/global.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin<DashboardScreen> {
  DashBoardBloc bloc = new DashBoardBloc();

  List<Prescription> listAllPresc;
  List<Reminder> listAllActiveReminder;

  List<Reminder> morningReminders;
  List<Reminder> eveningReminders;

  ReminderController reCtrl = new ReminderController();

  ReminderAPI reminderAPI = new ReminderAPI();
  PrescriptionApi prescApi = new PrescriptionApi();

  bool loading = true;

  ListDate listDate = new ListDate();
  int sliderIndex;

  DateTime currentDay;

  @override
  bool get wantKeepAlive {
    bool alive = !Global.hasChangedData;
    Global.hasChangedData = false;
    return alive;
  }

  @override
  void initState() {
    super.initState();

    reCtrl.init();

    sliderIndex = listDate.list.length ~/ 2;

    currentDay = DateTime.now();

    initData();
  }

  initData() async {
    loading = true;
    setState(() {});

    listAllPresc = [];
    listAllPresc = await prescApi.getAllPresc();

    listAllActiveReminder = [];
    listAllActiveReminder = await reminderAPI.getActiveReminder();

    await getData(currentDay);

    Future.delayed(Duration(seconds: 1)).then((v) {
      loading = false;
      setState(() {});
    });
  }

  getData(DateTime day) async {
    // loading = true;
    // setState(() {});

    morningReminders = [];
    eveningReminders = [];

    // listReminder = await reminderAPI.getActiveReminder();
    for (Reminder re in listAllActiveReminder) {
      Prescription presc = listAllPresc.firstWhere((p) => p.id == re.prescID);

      DateTime startDate = Utils.convertStringToDate(presc.date);
      startDate = new DateTime(startDate.year, startDate.month, startDate.day);

      DateTime endDate = startDate.add(Duration(days: presc.duration));
      endDate = new DateTime(endDate.year, endDate.month, endDate.day, 23, 59);

      if (day.isAfter(startDate) && day.isBefore(endDate)) {
        reCtrl.addDailyReminder(re);
        if (re.session == Session.MORNING) morningReminders.add(re);
        if (re.session == Session.EVENING) eveningReminders.add(re);
      } else {
        if (!day.isBefore(endDate)) {
          reCtrl.cancelDailyReminder(re);
          re.isActive = false;
          await reminderAPI.updateReminder(re);
        }
      }
    }

    Utils.sortTimeReminder(morningReminders);
    Utils.sortTimeReminder(eveningReminders);
  }

  changeDay(DateTime day) async {
    // loading = true;
    // setState(() {});

    morningReminders = [];
    eveningReminders = [];

    // listReminder = await reminderAPI.getActiveReminder();
    for (Reminder re in listAllActiveReminder) {
      Prescription presc = listAllPresc.firstWhere((p) => p.id == re.prescID);

      DateTime startDate = Utils.convertStringToDate(presc.date);
      startDate = new DateTime(startDate.year, startDate.month, startDate.day);

      DateTime endDate = startDate.add(Duration(days: presc.duration));
      endDate = new DateTime(endDate.year, endDate.month, endDate.day, 23, 59);

      if (day.isAfter(startDate) && day.isBefore(endDate)) {
        if (re.session == Session.MORNING) morningReminders.add(re);
        if (re.session == Session.EVENING) eveningReminders.add(re);
      }
    }

    Utils.sortTimeReminder(morningReminders);
    Utils.sortTimeReminder(eveningReminders);

    // Future.delayed(Duration(seconds: 1)).then((v) {
    //   loading = false;
    //   setState(() {});
    // });
    setState(() {});
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
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16)),
                    boxShadow: [commonBoxShadow],
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        ColorPalette.blue,
                        ColorPalette.green,
                      ],
                    ),
                  ),
                  height: 180,
                  child: DateSlider(
                    listDate: listDate,
                    index: sliderIndex,
                    onChanged: (index) async {
                      sliderIndex = index;
                      await changeDay(listDate.list[index]);
                    },
                  ),
                ),
                SizedBox(height: 30),
                loading
                    ? LoadingCircle()
                    : Column(
                        children: <Widget>[
                          renderSessionReminder(
                              Session.MORNING, morningReminders),
                          // SizedBox(height: 15),
                          renderSessionReminder(
                              Session.EVENING, eveningReminders),
                        ],
                      ),
                SizedBox(height: 60),
              ],
            ),
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
              // child: StreamBuilder(
              //   stream: bloc.prescNameStream(re),
              //   builder: (context, snap) {
              //     if (snap.hasData) {
              //       Prescription presc = snap.data;
              //       return rendertimeRow(re, presc);
              //     } else
              //       return Container();
              //   },
              // ),
              child: rendertimeRow(re),
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

  rendertimeRow(Reminder re) {
    Prescription presc = listAllPresc.firstWhere((p) => p.id == re.prescID);

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ReminderSettingScreen(prescription: presc)));

        initData();
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
          Image.asset(
            "assets/image/reminder.png",
            width: 120,
            color: Colors.black26,
          ),
          SizedBox(height: 10),
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

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class PrescReminder {
  Prescription presc;
  List<Reminder> listReminder;

  PrescReminder(this.presc, this.listReminder);
}

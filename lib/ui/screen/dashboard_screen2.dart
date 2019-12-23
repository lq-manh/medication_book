import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/bloc/dashboard_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/reminder_setting_screen.dart';
import 'package:medication_book/ui/widgets/date_slider.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class DashboardScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: DashBoardBloc(
        BlocProvider.of<ApplicationBloc>(context).prescListStream,
        BlocProvider.of<ApplicationBloc>(context).reminderListStream,
      ),
      child: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  DashBoardBloc dashboardBloc;
  BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    dashboardBloc = BlocProvider.of<DashBoardBloc>(context);
    this.ctx = context;

    return ContentLayout(
      topBar: TopBar(
        leading: Container(),
        title: "Reminders",
      ),
      main: Container(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: renderBody(dashboardBloc),
        ),
      ),
    );
  }

  renderBody(DashBoardBloc bloc) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
              onDateChanged: (date) async {
                bloc.getData(date);
              },
            ),
          ),
          SizedBox(height: 30),
          Column(
            children: <Widget>[
              StreamBuilder(
                stream: bloc.dayReminderController,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return renderSessionReminder(
                        Session.MORNING, snapshot.data);
                  } else {
                    return LoadingCircle();
                  }
                },
              ),
              StreamBuilder(
                stream: bloc.nightReminderController,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return renderSessionReminder(
                        Session.EVENING, snapshot.data);
                  } else {
                    return LoadingCircle();
                  }
                },
              ),
            ],
          ),
          SizedBox(height: 60),
        ],
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
                    fontSize: 24,
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
    Prescription presc =
        dashboardBloc.prescList?.firstWhere((p) => p.id == re.prescID);

    if (presc == null) return Container();

    return GestureDetector(
      onTap: () async {
        await Navigator.of(ctx).push(MaterialPageRoute(
            builder: (context) => ReminderSettingScreen(prescription: presc)));
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              presc.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ColorPalette.blacklight,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Text(
            TimeOfDay(hour: re.hour, minute: re.minute).format(ctx),
            style: TextStyle(
              color: ColorPalette.green,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  renderEmpty() {
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
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
                fontSize: 20),
          )
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      ClampingScrollPhysics();

  @override
  Widget buildViewportChrome(
          BuildContext context, Widget child, AxisDirection axisDirection) =>
      child;
}

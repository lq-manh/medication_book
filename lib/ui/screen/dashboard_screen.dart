import 'package:flutter/material.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Reminder> listReminder;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    ReminderAPI reminderAPI = new ReminderAPI();
    reminderAPI.getActiveReminder().then((list) {
      listReminder = list;
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
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Color(0xFFA9DFF1)),
                  ),
                )
              : Column(
                  children: <Widget>[
                    renderSessionReminder(Session.MORNING),
                    renderSessionReminder(Session.EVENING)
                  ],
                ),
        ));
  }

  renderSessionReminder(Session session) {
    // List<Widget> reminderItem = ;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: <Widget>[
              Utils.getSessionIcon(session),
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
        Column(
          children: listReminder.map((re) {
            if (re.session == session) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Text(
                          TimeOfDay(hour: re.hour, minute: re.minute)
                              .format(context),
                          style: TextStyle(
                              color: ColorPalette.green,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Text(
                            "Đơn thuốc đau họng",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPalette.blacklight,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Text(
                          "${re.listDrug.length} Items",
                          style: TextStyle(
                            color: ColorPalette.blacklight,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            } else
              return Container();
          }).toList(),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

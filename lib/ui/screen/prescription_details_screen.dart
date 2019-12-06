import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/reminder_settings_screen.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final Prescription prescription;

  PrescriptionDetailsScreen(this.prescription);

  @override
  _PrescriptionDetailsScreenState createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[renderSliverAppBar()];
          },
          body: Container(
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
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  renderListDrug(widget.prescription.listDrug),
                  renderRemindBtn()
                ],
              ),
            ),
          )),
    );
  }

  renderSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      title: Text(
        widget.prescription.drugStore.name,
        style: TextStyle(color: Colors.white70, fontSize: 20),
      ),
      centerTitle: true,
      elevation: 5,
      backgroundColor: ColorPalette.blue,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: EdgeInsets.only(top: 80, bottom: 10, right: 10, left: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorPalette.blue, ColorPalette.green],
            ),
            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
          ),
          child: renderPresBasicInfor(),
        ),
      ),
    );
  }

  renderPresBasicInfor() {
    return Column(
      children: <Widget>[
        SizedBox(height: 5),
        Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.mapMarkerAlt,
                    size: 14, color: Colors.white60),
                SizedBox(width: 5),
                Text(widget.prescription.drugStore.address,
                    style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(FontAwesomeIcons.phoneAlt,
                    size: 14, color: Colors.white60),
                SizedBox(width: 5),
                Text(widget.prescription.drugStore.phoneNumber,
                    style: TextStyle(color: Colors.white60, fontSize: 14)),
              ],
            ),
            //Text("01242351214", style: TextStyle(color: Colors.white60, fontSize: 14)),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text("Date",
                      style: TextStyle(color: Colors.white60, fontSize: 18)),
                  Text(widget.prescription.date.toString(),
                      style: TextStyle(color: Colors.white60, fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text("Description",
                      style: TextStyle(color: Colors.white60, fontSize: 18)),
                  Text(
                    widget.prescription.desc,
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
        //SizedBox(height: 10),
      ],
    );
  }

  renderListDrug(List<Drug> listDrug) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Duration"),
              Text((widget.prescription.duration > widget.prescription.duration
                      ? widget.prescription.duration.toString()
                      : widget.prescription.duration.floor().toString()) +
                  " days"),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Text("Notice"),
              Text("Take after the meal"),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          SizedBox(
            height: 15,
          ),
          DataTable(
            columnSpacing: 15,
            columns: <DataColumn>[
              DataColumn(label: Text("Drug")),
              DataColumn(label: Text("Amount")),
              DataColumn(label: Text("Dosage")),
              DataColumn(label: Text("Session"))
            ],
            rows: listDrug
                .map((drug) => DataRow(cells: <DataCell>[
                      DataCell(Text(
                        drug.name,
                      )),
                      DataCell(Text((drug.totalAmount > drug.totalAmount.floor()
                              ? drug.totalAmount.toString()
                              : drug.totalAmount.floor().toString()) +
                          " " +
                          drug.unit)),
                      DataCell(Text((drug.dosage > drug.dosage.floor()
                              ? drug.dosage.toString()
                              : drug.dosage.floor().toString()) +
                          " " +
                          drug.unit)),
                      DataCell(Row(
                        children: drug.sessions.map((s) {
                          if (s == Session.MORNING)
                            return Icon(
                              FontAwesomeIcons.sun,
                              size: 14,
                            );
                          else
                            return Icon(
                              FontAwesomeIcons.moon,
                              size: 14,
                            );
                        }).toList(),
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      )),
                    ]))
                .toList(),
          )
        ],
      ),
    );
  }

  renderRemindBtn() {
    return LargeButton(
      title: "Save & Remind Me",
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ReminderSettingsScreen(prescription: widget.prescription)));
      },
    );
  }
}

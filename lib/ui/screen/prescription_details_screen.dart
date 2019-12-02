import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/ui/widgets/cards.dart';
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

    // return Scaffold(
    //   body: ContentLayout(
    //     topBar: TopBar(
    //       leading: IconButton(
    //         icon: Icon(Icons.arrow_back),
    //         onPressed: () {},
    //         color: ColorPalette.white,
    //       ),
    //       title: 'Prescription',
    //       bottom: Container(
    //         height: screenHeight * 0.3,
    //         child: Text("abc"),
    //       ),
    //     ),
    //     // main: SingleChildScrollView(
    //     //   // child: Padding(
    //     //   //   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
    //     //   //   // child: RoundedCard(child: _Profile()),
    //     //   //   // child:
    //     //   // ),
    //     // ),
    //   ),
    // );

    return Scaffold(
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
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
                    // centerTitle: true,
                    // title: Text("Collapsing Toolbar",
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 16.0,
                    //     )),
                    background: Container(
                  padding:
                      EdgeInsets.only(top: 80, bottom: 10, right: 10, left: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [ColorPalette.blue, ColorPalette.green],
                    ),
                    // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                  ),
                  child: Column(
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
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(FontAwesomeIcons.phoneAlt,
                                  size: 14, color: Colors.white60),
                              SizedBox(width: 5),
                              Text(widget.prescription.drugStore.phoneNumber,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14)),
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
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 18)),
                                Text(widget.prescription.date,
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 14)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text("Description",
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 18)),
                                Text(
                                  widget.prescription.desc,
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14),
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
                  ),
                )),
              ),
            ];
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
                  renderListDrug(),
                  // Container(
                  //   height: 1000,
                  //   color: Colors.cyan,
                  // )
                ],
              ),
            ),
          )),
    );
  }

  renderListDrug() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Duration"),
              Text("5 days"),
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
            columns: <DataColumn>[
              DataColumn(label: Text("Drug")),
              DataColumn(label: Text("Amount")),
              DataColumn(label: Text("Session"))
            ],
            rows: <DataRow>[
              DataRow(cells: <DataCell>[
                DataCell(Text(
                  "Paracetomol 50ml",
                )),
                DataCell(Text("10 Pills")),
                DataCell(Text("M, E")),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text(
                  "Paracetomol 50ml",
                )),
                DataCell(Text("10 Pills")),
                DataCell(Text("M, E")),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text(
                  "Paracetomol 50ml",
                )),
                DataCell(Text("10 Pills")),
                DataCell(Text("M, E")),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text(
                  "Paracetomol 50ml",
                )),
                DataCell(Text("10 Pills")),
                DataCell(Text("M, E")),
              ])
            ],
          )
        ],
      ),
    );
  }

  bool isOnreminder = true;

  renderReminderSettings() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Reminder Settings"),
              Switch(
                value: isOnreminder,
                onChanged: (value) {
                  setState(() {
                    isOnreminder = value;
                  });
                },
                activeTrackColor: ColorPalette.bluelight,
                activeColor: ColorPalette.blue,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorPalette.blue, width: 2)),
          )
        ],
      ),
    );
  }
}

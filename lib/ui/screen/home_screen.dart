import 'package:flutter/material.dart';
import 'package:medication_book/configs/colors.dart';
import 'package:medication_book/ui/screen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final dynamic cwData;
  HomeScreenState({this.cwData});
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Text(
                'DashBoard',
              ),
              Text(
                'Note',
              ),
              Text(
                'Alarm',
              ),
              ProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey, width: 0.25))),
          child: TabBar(
            labelColor: Color.fromRGBO(249, 66, 58, 1),
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.transparent,
            controller: _tabController,
            tabs: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    new Icon(Icons.home),
                    SizedBox(
                      height: 5,
                    ),
                    new Text("Dashboard",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400)),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    new Icon(Icons.event_note),
                    SizedBox(
                      height: 5,
                    ),
                    new Text(
                      "Note",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    new Icon(Icons.timer),
                    SizedBox(
                      height: 5,
                    ),
                    new Text("Alarm",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400)),
                  ]),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    new Icon(Icons.person_outline),
                    SizedBox(
                      height: 5,
                    ),
                    new Text("Profile",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400)),
                  ])
            ],
          ),
        ));
  }
}

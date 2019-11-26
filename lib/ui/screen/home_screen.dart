import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/ui/animation/quick_action_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final dynamic cwData;
  HomeScreenState({this.cwData});
  TabController _tabController;

  bool blur = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Image(
                        image: AssetImage('assets/image/splash_logo.png'),
                        width: 192,
                        height: 192,
                      ),
                    ),
                  ),
                  Text(
                    'Note',
                  ),
                  Text(
                    'Alarm',
                  ),
                  Text(
                    'Profile',
                  )
                ],
              ),
            ),
            blur
                ? ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200.withOpacity(0.5)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 50, horizontal: 40),
                              child: QuickActionMenu()
                            )
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: 80,
          height: 80,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: FloatingActionButton(
              backgroundColor: Color(0xFF42A3E3),
              elevation: 5,
              child: Icon(Icons.add),
              onPressed: () {
                blur = !blur;
                setState(() {});
              },
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            elevation: 0,
            color: Colors.white,
            child: Container(
              height: 60,
              child: Theme(
                data: ThemeData(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Color(0xFF42A3E3),
                  unselectedLabelColor: Colors.black26,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Icon(FontAwesomeIcons.home),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.stickyNote),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.clock),
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    Icon(FontAwesomeIcons.user),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

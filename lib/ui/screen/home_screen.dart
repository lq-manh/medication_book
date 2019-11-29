import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/colors.dart';
import 'package:medication_book/ui/screen/dashboard_screen.dart';
import 'package:medication_book/ui/screen/profile_screen.dart';
import 'package:medication_book/ui/animation/quick_action_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final dynamic cwData;
  TabController _tabController;
  bool _blurred = false;

  HomeScreenState({this.cwData});

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _FloatingActionButton(
        onPressed: () => this.setState(() {
          this._blurred = !this._blurred;
        }),
      ),
      body: _HomeScreenBody(
        tabController: this._tabController,
        blurred: this._blurred,
      ),
      bottomNavigationBar: _HomeScreenBottom(
        tabController: this._tabController,
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final Function() onPressed;

  _FloatingActionButton({@required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FloatingActionButton(
          backgroundColor: ColorPalette.blue,
          elevation: 5,
          child: Icon(Icons.add),
          onPressed: this.onPressed,
        ),
      ),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  final TabController tabController;
  final bool blurred;

  _HomeScreenBody({@required this.tabController, this.blurred = false});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: <Widget>[
          Container(
            child: TabBarView(
              controller: this.tabController,
              children: <Widget>[
                DashboardScreen(),
                Text('Note'),
                Text('Alarm'),
                ProfileScreen(),
              ],
            ),
          ),
          if (this.blurred)
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 50,
                          horizontal: 40,
                        ),
                        child: QuickActionMenu(),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HomeScreenBottom extends StatelessWidget {
  final TabController tabController;

  _HomeScreenBottom({@required this.tabController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        elevation: 0,
        color: ColorPalette.white,
        child: Container(
          height: 60,
          child: Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: TabBar(
              controller: this.tabController,
              labelColor: ColorPalette.blue,
              unselectedLabelColor: Colors.black26,
              indicatorColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Icon(FontAwesomeIcons.home),
                Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.calendar),
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
        ));
  }
}

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/ui/screen/dashboard_screen2.dart';
import 'package:medication_book/ui/screen/history_screen.dart';
import 'package:medication_book/ui/screen/notes_screen.dart';
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
    return BlocProvider(
      bloc: ApplicationBloc(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _FloatingActionButton(
          onPressed: () => this.setState(() {
            this._blurred = !this._blurred;
          }),
        ),
        body: _HomeScreenBody(
          tabController: this._tabController,
          blurred: this._blurred,
          onTapCancel: () {
            setState(() {
              this._blurred = !this._blurred;
            });
          },
        ),
        bottomNavigationBar: _HomeScreenBottom(
          tabController: this._tabController,
        ),
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
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
  final Function onTapCancel;

  _HomeScreenBody(
      {@required this.tabController, this.blurred = false, this.onTapCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: this.tabController,
              children: <Widget>[
                DashboardScreen2(),
                HistoryScreen(),
                NotesScreen(),
                ProfileScreen(),
              ],
            ),
          ),
          if (this.blurred)
            GestureDetector(
              onTap: onTapCancel,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500.withOpacity(0.5),
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
            )
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
                Icon(FontAwesomeIcons.solidListAlt),
                Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.bookMedical),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.solidClipboard),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                Icon(FontAwesomeIcons.solidUser),
              ],
            ),
          ),
        ));
  }
}

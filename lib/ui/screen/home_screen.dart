import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/ui/screen/dashboard_screen2.dart';
import 'package:medication_book/ui/screen/history_screen.dart';
import 'package:medication_book/ui/screen/notes_screen.dart';
import 'package:medication_book/ui/screen/profile_screen.dart';
import 'package:medication_book/ui/widgets/blurred_overlay.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(bloc: ApplicationBloc(), child: Temp());
  }
}

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> with SingleTickerProviderStateMixin {
  TabController _tabController;
  ApplicationBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this);

    _appBloc = BlocProvider.of<ApplicationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _FloatingActionButton(
        onPressed: () {
          _appBloc.changeBlurredOverlay();
        }
      ),
      body: _HomeScreenBody(
        tabController: this._tabController,
        bloc: _appBloc,
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
  final ApplicationBloc bloc;

  _HomeScreenBody(
      {@required this.tabController, this.bloc});

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
          StreamBuilder(
            stream: bloc.blurredStream,
            initialData: false,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return Container();
              }
              else {
                return BlurredOverlay(
                  onTapCancel: bloc.changeBlurredOverlay,
                );
              }
            },
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

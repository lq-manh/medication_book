import 'package:flutter/material.dart';
import 'package:medication_book/bloc/application_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/bloc/dashboard_bloc.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class DashboardScreen2 extends StatefulWidget {
  @override
  _DashboardScreen2State createState() => _DashboardScreen2State();
}

class _DashboardScreen2State extends State<DashboardScreen2> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: DashBoardBloc(),
      child: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<ApplicationBloc>(context);

    return ContentLayout(
      topBar: TopBar(
        leading: Container(),
        title: "Reminders",
      ),
      main: Container(
        child: Center(
          child: StreamBuilder(
            stream: appBloc.listPresc,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return LoadingCircle();
              } 
              else {
                return Text(snapshot.data.length.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}

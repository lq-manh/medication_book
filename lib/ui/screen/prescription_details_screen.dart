import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/prescription.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentLayout(
        topBar: TopBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
            color: ColorPalette.white,
          ),
          title: 'Prescription',
          bottom: Container(),
        ),
        main: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            // child: RoundedCard(child: _Profile()),
            child: RaisedButton(
              onPressed: () async {
                var time = new Time(18, 2, 0);
                var androidPlatformChannelSpecifics =
                    new AndroidNotificationDetails(
                        'repeatDailyAtTime channel id',
                        'repeatDailyAtTime channel name',
                        'repeatDailyAtTime description');
                var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
                var platformChannelSpecifics = new NotificationDetails(
                    androidPlatformChannelSpecifics,
                    iOSPlatformChannelSpecifics);
                await flutterLocalNotificationsPlugin.showDailyAtTime(
                    0,
                    'show daily title',
                    'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
                    time,
                    platformChannelSpecifics);
              },
              child: Text("Turn on reminder"),
            ),
          ),
        ),
      ),
    );
  }
}

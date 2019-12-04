import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class ReminderSettingsScreen extends StatefulWidget {
  final Prescription prescription;

  const ReminderSettingsScreen({Key key, @required this.prescription})
      : super(key: key);

  @override
  _ReminderSettingsScreenState createState() => _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState extends State<ReminderSettingsScreen> {
  @override
  void initState() {
    super.initState();

    widget.prescription.name = "Presc 1";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentLayout(
        topBar: TopBar(
          title: 'Reminder Settings',
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          action: Container(),
        ),
        main: Container(
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
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                renderDuration(),
                renderPresName(),
                SizedBox(
                  height: 30,
                ),
                renderReminderItem(),
                // SizedBox(height: 20),
                renderReminderItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderDuration() {
    return Container(child: Text("5 days"));
  }

  renderPresName() {
    return Container(child: Text("Prescription 1"));
  }

  renderReminderItem() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Text("Morning"),
              Text("8:00"),
              Switch(
                value: true,
                activeColor: ColorPalette.blue,
                onChanged: (value) {},
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(
          height: 200,
          // color: Colors.blue,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 0),
            itemCount: 2,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 20),
                child: RoundedCard(
                    child: Container(
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Row(children: <Widget>[
                            Column(children: <Widget>[

                            ],),
                            Expanded(child: Column(children: <Widget>[
                              Icon(FontAwesomeIcons.pills),
                              Text("1 pills")
                            ],),)
                          ],),
                        ),
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                          color: ColorPalette.blue,
                        ),
                      )
                    ],
                  ),
                )),
              );
            },
          ),
        )
      ],
    );
  }
}

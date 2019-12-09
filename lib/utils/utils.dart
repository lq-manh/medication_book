import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

class Utils {
  static String convertSessionToString(Session session) {
    switch (session) {
      case Session.MORNING:
        return "Day time";
      case Session.EVENING:
        return "Night time";
    }
  }

  static Icon getSessionIcon(Session session, double size) {
    switch (session) {
      case Session.MORNING:
        return Icon(
          FontAwesomeIcons.sun,
          color: ColorPalette.sunOrange,
          size: size,
        );
      case Session.EVENING:
        return Icon(
          FontAwesomeIcons.moon,
          color: ColorPalette.nightBlue,
          size: size,
        );
    }
  }

  static List<Reminder> sortTimeReminder(List<Reminder> reminders) {
    for (int i = 0; i < reminders.length; i++) {
      for (int j = i; j < reminders.length; j++) {
        int t1 = reminders[i].hour * 60 + reminders[i].minute;
        int t2 = reminders[j].hour * 60 + reminders[j].minute;

        if (t1 > t2) {
          var tmp = reminders[i];
          reminders[i] = reminders[j];
          reminders[j] = tmp;
        }
      }
    }

    return reminders;
  }

  static String convertDatetime(BuildContext context, String dateTimeStr) {
    var date = int.parse(dateTimeStr);

    String formatedDateTime =
        DateFormat.yMd(Localizations.localeOf(context).toString())
            .format(DateTime.fromMillisecondsSinceEpoch(date));
    return formatedDateTime;
  }

  static String convertDoubletoString(double number) {
    if (number > number.floor()) return number.toString();
    else return number.floor().toString();
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug_type.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

class Utils {
  static List<DrugType> listType = [
    DrugType("syrup", "assets/image/syrup.png", "ml"),
    DrugType("syringe", "assets/image/syringe.png", "ml"),
    DrugType("pill", "assets/image/pill.png", "pill"),
    DrugType("capsule", "assets/image/capsule.png", "capsule"),
    DrugType("drops", "assets/image/drops.png", "drops"),
  ];

  static String getImageType(String type) {
    if (type == null) return "assets/image/pill.png";

    return "assets/image/$type.png";
  }

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
          color: ColorPalette.blue,
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

  static String convertDatetime(String dateTimeStr) {
    var dateTimeInt = int.parse(dateTimeStr);

    String formatedDateTime = DateFormat.yMMMd()
        .format(DateTime.fromMillisecondsSinceEpoch(dateTimeInt));
    return formatedDateTime;
  }

  // startDay is milisecond format
  static String getNextDay(String startDay, int duration) {
    DateTime start = convertStringToDate(startDay);
    DateTime end = start.add(Duration(days: duration));

    return convertDatetime(end.millisecondsSinceEpoch.toString());
  }

  // numberString is milisecond format
  static DateTime convertStringToDate(String dateTimeStr) {
    var dateTimeInt = int.parse(dateTimeStr);

    return DateTime.fromMillisecondsSinceEpoch(dateTimeInt);
  }

  static String convertDoubletoString(double number) {
    if (number > number.floor())
      return number.toString();
    else
      return number.floor().toString();
  }

  static int stringToInt(String s) {
    final Uint8List ints = base64.decode(s);
    return int.parse(ints.join(''));
  }
}

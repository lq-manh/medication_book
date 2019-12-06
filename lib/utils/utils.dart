import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/session.dart';

class Utils {
  static String convertSessionToString(Session session) {
    switch (session) {
      case Session.MORNING:
        return "Morning";
      case Session.EVENING:
        return "Evening";
    }
  }

  static Icon getSessionIcon(Session session) {
    switch (session) {
      case Session.MORNING:
        return Icon(
          FontAwesomeIcons.sun,
          color: ColorPalette.sunOrange,
          size: 24,
        );
      case Session.EVENING:
        return Icon(
          FontAwesomeIcons.moon,
          color: ColorPalette.nightBlue,
          size: 24,
        );
    }
  }
}

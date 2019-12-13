import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:medication_book/models/session.dart';

class TimePicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  Session session;
  TimeOfDay time;

  TimePicker({LocaleType locale, Session session, TimeOfDay time})
      : super(locale: locale) {
    this.session = session;
    this.time = time;
    this.currentTime = new DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, time.hour, time.minute);

    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    int start;
    int end;
    switch (session) {
      case Session.MORNING:
        start = 5;
        end = 19;
        break;
      case Session.EVENING:
        start = 19;
        end = 24;
        break;
      default:
    }
    if (index >= start && index < end) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [100, 100, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

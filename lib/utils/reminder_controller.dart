import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medication_book/models/reminder.dart';

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReminderController {
  static const medicineNotiIDRange = [1000, 1100];
  static const noteNotiIDRange = [2000, 2100];

  ReminderController() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  init() async {
    final initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettingsIOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(
      initSettingsAndroid,
      initSettingsIOS,
    );
    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> addDailyReminder(Reminder reminder) async {
    final Time time = Time(reminder.hour, reminder.minute, 0);

    final androidNotificationDetails = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description',
    );
    final iosNotificationDetails = IOSNotificationDetails();
    final notificationDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );

    await _notificationsPlugin.showDailyAtTime(
      reminder.notiID,
      "Medication Book's medicine reminder",
      reminder.content,
      time,
      notificationDetails,
    );
  }

  void addNoteReminder(int id, DateTime time, String content) {
    final androidNotificationDetails = AndroidNotificationDetails(
      'medicationbook-notes',
      'medicationbook-notes',
      "Medication Book's Notes",
    );
    final iosNotificationDetails = IOSNotificationDetails();
    final notificationDetails = NotificationDetails(
      androidNotificationDetails,
      iosNotificationDetails,
    );
    _notificationsPlugin.schedule(
      id,
      "Medication Book's note",
      content,
      time,
      notificationDetails,
    );
  }

  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}

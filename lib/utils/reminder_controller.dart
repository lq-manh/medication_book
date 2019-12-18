import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medication_book/models/reminder.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class ReminderController {
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
    await notificationsPlugin.initialize(initSettings);
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

    await notificationsPlugin.showDailyAtTime(
      reminder.notiID,
      'Medicine Reminder',
      "${reminder.content}",
      time,
      notificationDetails,
    );
  }

  Future<void> cancelDailyReminder(Reminder re) async {
    await notificationsPlugin.cancel(re.notiID);
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
    notificationsPlugin.schedule(
      id,
      "Medication Book's Notes",
      content,
      time,
      notificationDetails,
    );
  }

  Future<void> cancelReminder(int id) async {
    notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllReminders() async {
    await notificationsPlugin.cancelAll();
  }
}

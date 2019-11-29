import 'dart:convert';

Reminder reminderFromJson(String str) {
  final jsonData = json.decode(str);
  return Reminder.fromMap(jsonData);
}

String prescriptionToJson(Reminder data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Reminder {
  bool isActive;
  int hour;
  int minute;

  Reminder({this.isActive, this.hour, this.minute});

  factory Reminder.fromMap(Map<String, dynamic> json) => new Reminder(
    isActive: json["isActive"],
    hour: json["hour"],
    minute: json["minute"]
  );

  Map<String, dynamic> toMap() => {
    "isActive": isActive,
    "hour": hour,
    "minute": minute
  };
}

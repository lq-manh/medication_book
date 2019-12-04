import 'package:json_annotation/json_annotation.dart';
import 'package:medication_book/models/reminder.dart';

part 'drug.g.dart';

enum SESSIONS { MORNING, EVENING }

@JsonSerializable()
class Drug {
  String presId;
  String name;
  String unit;
  double totalAmount;
  double dosage;
  String note;
  List<Reminder> listReminder;
  List<SESSIONS> sessions;

  Drug(
      {this.sessions,
      this.presId,
      this.unit,
      this.totalAmount,
      this.dosage,
      this.note,
      this.listReminder,
      this.name});
  factory Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);
  Map<String, dynamic> toJson() => _$DrugToJson(this);
}

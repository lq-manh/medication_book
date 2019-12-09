import 'package:json_annotation/json_annotation.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';

part 'drug.g.dart';

@JsonSerializable()
class Drug {
  String presId;
  String name;
  String unit;
  double totalAmount;
  double dosage;
  String note;
  List<Session> sessions;

  Drug(
      {this.sessions,
      this.presId,
      this.unit,
      this.totalAmount,
      this.dosage,
      this.note,
      this.name});
  factory Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);
  Map<String, dynamic> toJson() => _$DrugToJson(this);
}

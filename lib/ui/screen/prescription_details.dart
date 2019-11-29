import 'package:flutter/material.dart';
import 'package:medication_book/models/prescription.dart';

class PrescriptionDetails extends StatefulWidget {
  final Prescription prescription;

  PrescriptionDetails(this.prescription);

  @override
  _PrescriptionDetailsState createState() => _PrescriptionDetailsState();
}

class _PrescriptionDetailsState extends State<PrescriptionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("DEtails"),),
    );
  }
}
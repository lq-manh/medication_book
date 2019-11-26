import 'package:flutter/material.dart';
import 'package:medication_book/configs/colors.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;

  RoundedCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPalette.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: this.child,
    );
  }
}

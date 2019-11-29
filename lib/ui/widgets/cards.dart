import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;

  RoundedCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [commonBoxShadow],
      ),
      child: Card(
        color: ColorPalette.white,
        elevation: 0, // disabled to use custom box shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: this.child,
      ),
    );
  }
}

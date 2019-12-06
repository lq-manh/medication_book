import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool hasBorder;
  final bool hasShadow;

  RoundedCard({
    this.child,
    this.backgroundColor = ColorPalette.white,
    this.hasBorder = false,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [if (this.hasShadow) commonBoxShadow],
      ),
      child: Card(
        color: this.backgroundColor,
        elevation: 0, // disabled to use custom box shadow
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: this.hasBorder
              ? BorderSide(color: ColorPalette.blue, width: 1)
              : BorderSide.none,
        ),
        child: this.child,
      ),
    );
  }
}

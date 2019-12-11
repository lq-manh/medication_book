import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class RoundedCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final bool hasBorder;
  final bool hasShadow;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  RoundedCard({
    this.child,
    this.backgroundColor = ColorPalette.white,
    this.hasBorder = false,
    this.hasShadow = true,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorPalette.blue,
          width: this.hasBorder ? 1 : 0,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [if (this.hasShadow) commonBoxShadow],
        color: this.backgroundColor,
      ),
      margin: this.margin,
      padding: this.padding,
      child: this.child,
    );
  }
}

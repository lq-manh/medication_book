import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class CustomRaisedButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final Widget child;
  final Color color;
  final Color textColor;

  CustomRaisedButton({
    @required this.onPressed,
    this.text = '',
    this.child,
    this.color = ColorPalette.blue,
    this.textColor = ColorPalette.white,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: this.color,
      padding: EdgeInsets.symmetric(vertical: 15),
      onPressed: this.onPressed,
      textColor: this.textColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: this.child != null ? this.child : Text(this.text),
    );
  }
}

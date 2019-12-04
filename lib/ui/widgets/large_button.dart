import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class LargeButton extends StatelessWidget {
  final Function onPressed;
  final String title;

  LargeButton({this.onPressed, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 50,
      child: RaisedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: ColorPalette.white, fontSize: 18),
        ),
        color: ColorPalette.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

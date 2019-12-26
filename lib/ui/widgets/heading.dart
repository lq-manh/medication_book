import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class Heading extends StatelessWidget {
  final String title;
  final Widget action;

  Heading({Key key, this.title, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: ColorPalette.darkerGrey,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          action == null ? Container() : action,
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
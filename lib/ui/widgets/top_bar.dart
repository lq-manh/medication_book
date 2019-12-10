import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class TopBar extends StatefulWidget {
  final Widget leading;
  final String title;
  final Widget action;
  final Widget bottom;

  TopBar({this.leading, @required this.title, this.action, this.bottom});

  @override
  _TopBarState createState() {
    return _TopBarState();
  }
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius;
    if (widget.bottom != null) {
      borderRadius = BorderRadius.vertical(bottom: Radius.circular(16));
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [commonBoxShadow],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorPalette.blue, ColorPalette.green],
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 20),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    widget.leading,
                    if (widget.action != null) widget.action,
                  ],
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: ColorPalette.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (widget.bottom != null)
            widget.bottom
        ],
      ),
    );
  }
}

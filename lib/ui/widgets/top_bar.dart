import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class TopBar extends StatefulWidget {
  final Widget leading;
  final String title;
  final Widget action;
  final Widget bottom;
  final bool hasShadow;

  TopBar({this.leading, @required this.title, this.action, this.bottom, this.hasShadow});

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius;
    if (this.widget.bottom != null) {
      borderRadius = BorderRadius.vertical(bottom: Radius.circular(16));
    }
    final Widget leading = this.widget.leading ?? Container();

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: (this.widget.hasShadow != null && !this.widget.hasShadow) ? null : [commonBoxShadow],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ColorPalette.blue, ColorPalette.green],
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 10),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    leading,
                    if (this.widget.action != null) this.widget.action,
                  ],
                ),
                Text(
                  this.widget.title,
                  style: TextStyle(
                    color: ColorPalette.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (this.widget.bottom != null) this.widget.bottom,
        ],
      ),
    );
  }
}

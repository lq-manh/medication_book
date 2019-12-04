import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class TopBar extends StatefulWidget {
  final Widget leading;
  final String title;
  final Widget action;
  final Widget bottom;

  TopBar({this.leading, @required this.title, this.action, this.bottom});

  @override
  _TopBarState createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  // _TopBarState({widget.leading, @required this.title, this.action, this.bottom}) {
  //   if (this.leading == null)
  //     this.leading = IconButton(
  //       icon: Icon(Icons.arrow_back),
  //       onPressed: () {},
  //       color: ColorPalette.white,
  //     );
  //   if (this.action == null) this.action = Container();
  // }

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
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[widget.leading, widget.action],
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: ColorPalette.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // if (this.bottom != null)
          //   Padding(
          //     padding: EdgeInsets.only(bottom: 20),
          //     child: SizedBox(height: 128, child: this.bottom),
          //   ),
          if (widget.bottom != null) widget.bottom
        ],
      ),
    );
  }
}

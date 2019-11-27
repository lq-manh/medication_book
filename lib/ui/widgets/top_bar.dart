import 'package:flutter/material.dart';
import 'package:medication_book/configs/colors.dart';

class TopBar extends StatelessWidget {
  Widget leading;
  final String title;
  Widget action;
  final Widget bottom;

  TopBar({
    this.leading,
    @required this.title,
    this.action,
    this.bottom,
  }) {
    if (this.leading == null)
      this.leading = IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {},
        color: ColorPalette.white,
      );
    if (this.action == null) this.action = Container();
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry borderRadius;
    if (this.bottom != null) {
      borderRadius = BorderRadius.vertical(bottom: Radius.circular(16));
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
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
                  children: <Widget>[this.leading, this.action],
                ),
                Text(
                  this.title,
                  style: TextStyle(
                    color: ColorPalette.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (this.bottom != null)
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: SizedBox(height: 128, child: this.bottom),
            ),
        ],
      ),
    );
  }
}

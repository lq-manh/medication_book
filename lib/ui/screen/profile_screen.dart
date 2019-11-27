import 'package:flutter/material.dart';
import 'package:medication_book/configs/colors.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentLayout(
      topBar: TopBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
          color: ColorPalette.white,
        ),
        title: 'Profile',
        action: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {},
          color: ColorPalette.white,
        ),
        bottom: FittedBox(
          child: CircleAvatar(backgroundColor: ColorPalette.white),
        ),
      ),
      main: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: RoundedCard(
              child: Container(width: 300, height: 300),
            ),
          )
        ],
      ),
    );
  }
}

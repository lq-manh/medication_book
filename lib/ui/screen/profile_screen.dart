import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';
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
      main: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: _ProfileCard(),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      hasBorder: true,
      hasShadow: false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: <Widget>[
            _InfoRow(fieldName: 'Name', value: 'Luong Quang Manh'),
            _InfoRow(fieldName: 'Age', value: '21'),
            _InfoRow(fieldName: 'Gender', value: 'Male'),
            _InfoRow(fieldName: 'Height', value: '168', unit: 'cm'),
            _InfoRow(fieldName: 'Weight', value: '48', unit: 'kg'),
            _InfoRow(fieldName: 'Blood Type', value: 'B'),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String fieldName;
  final String value;
  final String unit;

  _InfoRow({@required this.fieldName, @required this.value, this.unit = ''});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              this.fieldName,
              style: TextStyle(color: ColorPalette.blue),
            ),
          ),
          Text(
            this.value,
            style: TextStyle(
              color: ColorPalette.textBody,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            this.unit,
            style: TextStyle(
              color: ColorPalette.textBody,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

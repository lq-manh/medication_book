import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/user.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/secure_store.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Future<String> _uid = SecureStorage.instance.read(key: 'uid');

  _ProfileScreenState();

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
        bottom: FutureBuilder(
          future: this._uid,
          builder: (BuildContext context, AsyncSnapshot<String> snap) {
            if (snap.connectionState != ConnectionState.done || !snap.hasData)
              return CircularProgressIndicator(
                backgroundColor: ColorPalette.blue,
              );

            return FittedBox(
              child: CircleAvatar(backgroundColor: ColorPalette.white),
            );
          },
        ),
      ),
      main: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: FutureBuilder(
            future: this._uid,
            builder: (BuildContext context, AsyncSnapshot<String> snap) {
              if (snap.connectionState != ConnectionState.done || !snap.hasData)
                return CircularProgressIndicator(
                  backgroundColor: ColorPalette.blue,
                );

              return _ProfileCard(uid: snap.data);
            },
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final CollectionReference _users = Firestore.instance.collection('users');
  final String uid;

  _ProfileCard({@required this.uid});

  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      hasBorder: true,
      hasShadow: false,
      child: StreamBuilder(
        stream: this._users.where('uid', isEqualTo: this.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          if (!snap.hasData)
            return CircularProgressIndicator(
              backgroundColor: ColorPalette.blue,
            );

          final DocumentSnapshot doc = snap.data.documents[0];
          final User user = User.fromJson(doc.data);

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: <Widget>[
                _InfoRow(fieldName: 'Name', value: user.name),
                _InfoRow(fieldName: 'Date of Birth', value: user.dateOfBirth),
                _InfoRow(fieldName: 'Gender', value: user.gender),
                _InfoRow(fieldName: 'Height', value: user.height, unit: 'cm'),
                _InfoRow(fieldName: 'Weight', value: user.weight, unit: 'kg'),
                _InfoRow(fieldName: 'Blood Type', value: user.bloodType),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String fieldName;
  final value;
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
            this.value != null ? this.value.toString() : '',
            style: TextStyle(
              color: ColorPalette.textBody,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            this.value != null ? this.unit : '',
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

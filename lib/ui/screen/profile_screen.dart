import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/user.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/secure_store.dart';

enum _MenuButtons { edit, logOut }
enum _Modes { viewing, editing }

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  _Modes _mode = _Modes.viewing;
  final Future<String> _uid = SecureStorage.instance.read(key: 'uid');

  _ProfileScreenState();

  @override
  Widget build(BuildContext context) {
    return ContentLayout(
      topBar: TopBar(
        title: 'Profile',
        action: _Menu(onSelected: (_MenuButtons button) {
          if (button == _MenuButtons.edit) this._mode = _Modes.editing;
          this.setState(() {});
        }),
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

              return _Profile(mode: this._mode, uid: snap.data);
            },
          ),
        ),
      ),
    );
  }
}

class _Menu extends StatelessWidget {
  final void Function(_MenuButtons) onSelected;

  _Menu({this.onSelected});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuButtons>(
      icon: Icon(Icons.menu, color: ColorPalette.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: this.onSelected,
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(value: _MenuButtons.edit, child: Text('Edit profile')),
        PopupMenuItem(
          value: _MenuButtons.logOut,
          child: Text(
            'Log out',
            style: TextStyle(color: ColorPalette.textBody.withOpacity(0.75)),
          ),
        ),
      ],
    );
  }
}

class _Profile extends StatefulWidget {
  final _Modes mode;
  final String uid;

  _Profile({@required this.mode, @required this.uid});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  final CollectionReference _users = Firestore.instance.collection('users');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _viewingWidget() {
    return RoundedCard(
      hasBorder: true,
      hasShadow: false,
      child: StreamBuilder(
        stream:
            this._users.where('uid', isEqualTo: this.widget.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
          if (snap.hasError || !snap.hasData)
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

  Widget _editingWidget() {
    return Column(
      children: <Widget>[
        RoundedCard(
          hasBorder: true,
          hasShadow: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(children: <Widget>[
              _InfoRow(fieldName: 'Name', value: 'Enter your name'),
              _InfoRow(fieldName: 'Date of Birth', value: 'DD/MM/YYYY'),
            ]),
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 20)),
        FractionallySizedBox(
          widthFactor: 1,
          child: RaisedButton(
            color: ColorPalette.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
            onPressed: () {},
            textColor: ColorPalette.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text('Save'),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.mode == _Modes.viewing)
      return this._viewingWidget();
    else
      return this._editingWidget();
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

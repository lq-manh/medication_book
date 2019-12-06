import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/user.dart';
import 'package:medication_book/ui/widgets/buttons.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/secure_store.dart';

enum _MenuButtons { edit, logOut }
enum _Modes { viewing, editing }

final _dateFormatter = DateFormat("MMMM dd, yyyy");

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
          padding: EdgeInsets.fromLTRB(40, 20, 40, 50),
          child: FutureBuilder(
            future: this._uid,
            builder: (BuildContext context, AsyncSnapshot<String> snap) {
              if (snap.connectionState != ConnectionState.done || !snap.hasData)
                return CircularProgressIndicator(
                  backgroundColor: ColorPalette.blue,
                );

              return _Profile(
                mode: this._mode,
                uid: snap.data,
                onModeChanged: (_Modes mode) {
                  this._mode = mode;
                  this.setState(() {});
                },
              );
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
            style: TextStyle(color: ColorPalette.textBody.withOpacity(0.85)),
          ),
        ),
      ],
    );
  }
}

class _Profile extends StatefulWidget {
  final _Modes mode;
  final String uid;
  final void Function(_Modes) onModeChanged;

  _Profile({@required this.mode, @required this.uid, this.onModeChanged});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  final CollectionReference _users = Firestore.instance.collection('users');
  FormBuilderState _formState;

  Widget _viewingWidget(User user) {
    return RoundedCard(
      hasBorder: true,
      hasShadow: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: <Widget>[
            _InfoRow(fieldName: 'Name', value: user.name),
            _InfoRow(
              fieldName: 'Date of Birth',
              value: _dateFormatter.format(user.dateOfBirth),
            ),
            _InfoRow(fieldName: 'Gender', value: user.gender),
            _InfoRow(fieldName: 'Height', value: user.height, unit: 'cm'),
            _InfoRow(fieldName: 'Weight', value: user.weight, unit: 'kg'),
            _InfoRow(fieldName: 'Blood Type', value: user.bloodType),
          ],
        ),
      ),
    );
  }

  Widget _editingWidget(DocumentReference docRef, User user) {
    return Column(
      children: <Widget>[
        RoundedCard(
          hasBorder: true,
          hasShadow: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _ProfileForm(
              initialState: user.toFormJson(),
              onChanged: (FormBuilderState state) {
                this._formState = state;
                this.setState(() {});
              },
            ),
          ),
        ),
        ButtonBar(
          children: <Widget>[
            CustomRaisedButton(
              onPressed: () => this.widget.onModeChanged(_Modes.viewing),
              text: 'Cancel',
              color: ColorPalette.white,
              textColor: ColorPalette.textBody.withOpacity(0.85),
            ),
            CustomRaisedButton(
              onPressed: () {
                this._formState.save();
                docRef.updateData(this._formState.value);
                this.widget.onModeChanged(_Modes.viewing);
              },
              text: 'Save',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._users.where('uid', isEqualTo: this.widget.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
        if (snap.hasError || !snap.hasData)
          return CircularProgressIndicator(backgroundColor: ColorPalette.blue);

        final DocumentSnapshot doc = snap.data.documents[0];
        final User user = User.fromJson(doc.data);
        if (this.widget.mode == _Modes.viewing) {
          return this._viewingWidget(user);
        }
        return this._editingWidget(doc.reference, user);
      },
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
      padding: EdgeInsets.symmetric(vertical: 10),
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

class _ProfileForm extends StatefulWidget {
  final Map<String, dynamic> initialState;
  final Function(FormBuilderState) onChanged;

  _ProfileForm({this.initialState = const {}, this.onChanged});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<_ProfileForm> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      autovalidate: true,
      initialValue: this.widget.initialState,
      key: this._key,
      onChanged: (Map<String, dynamic> _) {
        this.widget.onChanged(this._key.currentState);
      },
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            attribute: 'name',
            decoration: InputDecoration(
              labelText: 'Name',
              hintText: 'Full name',
            ),
            validators: [FormBuilderValidators.required()],
          ),
          FormBuilderDateTimePicker(
            attribute: 'dateOfBirth',
            decoration: InputDecoration(labelText: 'Date of Birth'),
            inputType: InputType.date,
            format: _dateFormatter,
            validators: [FormBuilderValidators.required()],
          ),
          FormBuilderDropdown(
            attribute: 'gender',
            decoration: InputDecoration(labelText: 'Gender'),
            items: [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            validators: [FormBuilderValidators.required()],
          ),
          FormBuilderTextField(
            attribute: 'height',
            decoration: InputDecoration(labelText: 'Height', suffixText: 'cm'),
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.min(1),
            ],
            valueTransformer: (dynamic val) {
              try {
                return double.parse(val);
              } on FormatException {
                return '';
              }
            },
          ),
          FormBuilderTextField(
            attribute: 'weight',
            decoration: InputDecoration(labelText: 'Weight', suffixText: 'kg'),
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.min(1),
            ],
            valueTransformer: (dynamic val) {
              try {
                return double.parse(val);
              } on FormatException {
                return '';
              }
            },
          ),
          FormBuilderDropdown(
            attribute: 'bloodType',
            decoration: InputDecoration(labelText: 'Blood Type'),
            items: [
              DropdownMenuItem(value: 'A', child: Text('A')),
              DropdownMenuItem(value: 'B', child: Text('B')),
              DropdownMenuItem(value: 'AB', child: Text('AB')),
              DropdownMenuItem(value: 'O', child: Text('O')),
            ],
            validators: [FormBuilderValidators.required()],
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/note.dart';
import 'package:medication_book/ui/widgets/buttons.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/secure_store.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final Future<String> _uid = SecureStorage.instance.read(key: 'uid');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._uid,
      builder: (BuildContext context, AsyncSnapshot<String> snap) {
        if (snap.connectionState != ConnectionState.done || !snap.hasData)
          return Container();

        return ContentLayout(
          topBar: TopBar(title: 'Notes'),
          main: _Notes(uid: snap.data),
        );
      },
    );
  }
}

class _Notes extends StatefulWidget {
  final String uid;

  _Notes({@required this.uid});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<_Notes> {
  Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    super.initState();
    final CollectionReference notes = Firestore.instance.collection('notes');
    this._dataStream =
        notes.where('userID', isEqualTo: this.widget.uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._dataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
        if (snap.hasError || !snap.hasData) return Container();

        final List<Note> notes = snap.data.documents.map(
          (DocumentSnapshot doc) {
            return Note.fromJson(doc.data);
          },
        ).toList();

        return ListView(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 50),
          children: <Widget>[
            _NoteCard(),
            CustomRaisedButton(
              onPressed: () {},
              text: 'Add',
            ),
          ],
        );
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RoundedCard(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Remember to drink enough water!',
                style: TextStyle(
                  color: ColorPalette.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'December 11, 2019',
                style: TextStyle(
                  color: ColorPalette.textBody,
                ),
              ),
            ],
          ),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.drag_handle),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

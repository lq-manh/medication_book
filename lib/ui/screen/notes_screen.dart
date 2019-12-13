import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/note.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/secure_store.dart';

final formatter = DateFormat("MMMM dd, yyyy HH:mm");
final CollectionReference notesCollection =
    Firestore.instance.collection('notes');

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final Future<String> _uid = SecureStorage.instance.read(key: 'uid');
  bool _addingNote = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this._uid,
      builder: (BuildContext context, AsyncSnapshot<String> snap) {
        if (snap.connectionState != ConnectionState.done || !snap.hasData)
          return Container();

        return ContentLayout(
          topBar: TopBar(
            title: 'Notes',
            action: IconButton(
              icon: Icon(this._addingNote ? Icons.clear : Icons.add),
              color: ColorPalette.white,
              onPressed: () => this.setState(() {
                this._addingNote = !this._addingNote;
              }),
            ),
          ),
          main: _Notes(
            uid: snap.data,
            addingNote: this._addingNote,
            onAddingNoteChanged: (bool value) => this.setState(() {
              this._addingNote = value;
            }),
          ),
        );
      },
    );
  }
}

class _Notes extends StatefulWidget {
  final String uid;
  final bool addingNote;
  final Function(bool) onAddingNoteChanged;

  _Notes({
    @required this.uid,
    @required this.addingNote,
    @required this.onAddingNoteChanged,
  });

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<_Notes> {
  Stream<QuerySnapshot> _dataStream;

  @override
  void initState() {
    super.initState();
    this._dataStream =
        notesCollection.where('userID', isEqualTo: this.widget.uid).snapshots();
  }

  void _removeNote(String id) {
    notesCollection.document(id).delete();
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._dataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
        if (snap.hasError || !snap.hasData) return Container();

        final Iterable<Widget> notes = snap.data.documents.map<Widget>(
          (DocumentSnapshot doc) {
            final Note n = Note.fromJson(doc.data);
            n.id = doc.documentID;
            return _NoteCard(n, onRemove: this._removeNote);
          },
        );

        return ListView(
          padding: EdgeInsets.fromLTRB(40, 20, 40, 50),
          children: <Widget>[
            ...notes,
            if (this.widget.addingNote)
              _NoteCard(
                Note(userID: this.widget.uid),
                initialMode: _NoteModes.adding,
                onCreate: () => this.widget.onAddingNoteChanged(false),
              ),
          ],
        );
      },
    );
  }
}

enum _NoteMenuButtons { edit, remove }
enum _NoteModes { viewing, editing, adding }

class _NoteCard extends StatefulWidget {
  final Note note;
  final _NoteModes initialMode;
  final Function() onCreate;
  final Function(String) onRemove;

  _NoteCard(
    this.note, {
    this.initialMode = _NoteModes.viewing,
    this.onCreate,
    this.onRemove,
  });

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<_NoteCard> {
  _NoteModes _mode;

  @override
  void initState() {
    super.initState();
    this._mode = this.widget.initialMode;
  }

  Widget _viewingWidget(Note note) {
    return RoundedCard(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  note.content != null ? note.content : '',
                  style: TextStyle(
                    color: ColorPalette.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  note.updatedAt != null
                      ? formatter.format(note.updatedAt)
                      : note.createdAt != null
                          ? formatter.format(note.createdAt)
                          : '',
                  style: TextStyle(
                    color: ColorPalette.textBody,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<_NoteMenuButtons>(
            icon: Icon(
              FontAwesomeIcons.ellipsisV,
              color: ColorPalette.textBody,
              size: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (_NoteMenuButtons button) {
              if (button == _NoteMenuButtons.edit)
                this.setState(() => this._mode = _NoteModes.editing);
              else if (button == _NoteMenuButtons.remove)
                this.widget.onRemove(note.id);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: _NoteMenuButtons.edit,
                child: Text('Edit'),
              ),
              PopupMenuItem(
                value: _NoteMenuButtons.remove,
                child: Text(
                  'Remove',
                  style: TextStyle(color: ColorPalette.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editingWidget(Note note) {
    return RoundedCard(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        initialValue: note.content,
        keyboardType: TextInputType.text,
        maxLength: 120,
        minLines: 1,
        maxLines: 3,
        onFieldSubmitted: (String value) {
          note.content = value;
          notesCollection.document(note.id).updateData(note.toJson());
          this._mode = _NoteModes.viewing;
          this.setState(() {});
        },
      ),
    );
  }

  Widget _addingWidget(Note note) {
    return RoundedCard(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        maxLength: 120,
        maxLines: 3,
        minLines: 1,
        onFieldSubmitted: (String value) {
          note.content = value;
          note.createdAt = DateTime.now();
          notesCollection.add(note.toJson());
          this.widget.onCreate();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Note note = this.widget.note;
    if (this._mode == _NoteModes.viewing)
      return this._viewingWidget(note);
    else if (this._mode == _NoteModes.editing)
      return this._editingWidget(note);
    else if (this._mode == _NoteModes.adding) return this._addingWidget(note);
    return null; // this line should never be reached
  }
}

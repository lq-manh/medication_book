import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medication_book/configs/configs.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/note.dart';
import 'package:medication_book/ui/widgets/buttons.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/secure_store.dart';
import 'package:medication_book/utils/utils.dart';

final _reCtrl = ReminderController();
final _formatter = DateFormat("MMMM dd, yyyy HH:mm");
final _notesCollection = Firestore.instance.collection('notes');

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
                this._addingNote = true;
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _NoteDialog(
                    Note(userID: snap.data),
                    onPop: () => this.setState(() {
                      this._addingNote = false;
                    }),
                  ),
                );
              }),
            ),
          ),
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
    this._dataStream = _notesCollection
        .where('userID', isEqualTo: this.widget.uid)
        .snapshots();
  }

  void _removeNote(Note note) async {
    if (note.reminder != null) _reCtrl.cancel(note.reminderNotiID);
    _notesCollection.document(note.id).delete();
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: this._dataStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
        if (snap.hasError || !snap.hasData) return Container();

        if (snap.data.documents.length <= 0)
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/image/notes.png',
                width: 120,
                color: Colors.black26,
              ),
              SizedBox(height: 10),
              Text(
                "No Notes",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );

        final List<Widget> noteCards = snap.data.documents.map<Widget>(
          (DocumentSnapshot doc) {
            final Note n = Note.fromJson(doc.data);
            n.id = doc.documentID;
            return _NoteCard(n, onRemove: this._removeNote);
          },
        ).toList();

        return ListView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
          children: noteCards,
        );
      },
    );
  }
}

enum _NoteMenuButtons { edit, remove }

class _NoteCard extends StatelessWidget {
  final Note note;
  final Function(Note) onRemove;

  _NoteCard(this.note, {this.onRemove});

  @override
  Widget build(BuildContext context) {
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
                Padding(padding: EdgeInsets.only(bottom: 10)),
                Text(
                  note.reminder != null ? _formatter.format(note.reminder) : '',
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
              color: ColorPalette.gray,
              size: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onSelected: (_NoteMenuButtons button) {
              if (button == _NoteMenuButtons.edit)
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _NoteDialog(
                    note,
                    onPop: () {},
                  ),
                );
              else if (button == _NoteMenuButtons.remove) this.onRemove(note);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: _NoteMenuButtons.edit,
                child: Text('Edit note'),
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
}

class _NoteDialog extends StatefulWidget {
  final Note note;
  final void Function() onPop;

  _NoteDialog(this.note, {@required this.onPop});

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<_NoteDialog> {
  final ReminderController _reCtrl = ReminderController();
  FormBuilderState _formState;

  @override
  void initState() {
    super.initState();
    _reCtrl.init();
  }

  Function() _saveNote(Note note) {
    return () {
      if (this._formState != null) {
        if (note.id != null)
          this._updateNote(note);
        else
          this._createNote(note);
      }
      this.widget.onPop();
      Navigator.pop(context);
    };
  }

  void _createNote(Note note) {
    note
      ..content = this._formState.value['content']
      ..reminder = this._formState.value['reminder']
      ..createdAt = DateTime.now();

    if (note.reminder != null) {
      note.reminderNotiID = Utils.randomInRange(
        Configs.noteNotiIDRange[0],
        Configs.noteNotiIDRange[1],
      );
      _reCtrl.addNoteReminder(note.reminderNotiID, note.reminder, note.content);
    }

    _notesCollection.add(note.toJson());
  }

  void _updateNote(Note note) async {
    note
      ..content = this._formState.value['content']
      ..reminder = this._formState.value['reminder'];

    if (note.reminder != null) {
      if (note.reminderNotiID == null)
        note.reminderNotiID = Utils.randomInRange(
          Configs.noteNotiIDRange[0],
          Configs.noteNotiIDRange[1],
        );
      _reCtrl.addNoteReminder(note.reminderNotiID, note.reminder, note.content);
    } else if (note.reminderNotiID != null) {
      _reCtrl.cancel(note.reminderNotiID);
    }

    _notesCollection.document(note.id).updateData(note.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final Note note = this.widget.note;

    return WillPopScope(
      onWillPop: () async {
        this.widget.onPop();
        return true;
      },
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _NoteForm(
                initialValue: {
                  'content': note.content,
                  'reminder': note.reminder,
                },
                onChanged: (FormBuilderState state) => this.setState(() {
                  this._formState = state;
                }),
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              ButtonBar(
                children: <Widget>[
                  CustomRaisedButton(
                    text: 'Cancel',
                    onPressed: () {
                      this.widget.onPop();
                      Navigator.pop(context);
                    },
                    color: ColorPalette.white,
                    textColor: ColorPalette.textBody,
                  ),
                  CustomRaisedButton(
                    text: 'Save',
                    onPressed: this._saveNote(note),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteForm extends StatefulWidget {
  final Map<String, dynamic> initialValue;
  final Function(FormBuilderState) onChanged;

  _NoteForm({this.initialValue = const {}, this.onChanged});

  @override
  _NoteFormState createState() => _NoteFormState();
}

class _NoteFormState extends State<_NoteForm> {
  final GlobalKey<FormBuilderState> _key = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      autovalidate: true,
      initialValue: this.widget.initialValue,
      key: this._key,
      onChanged: (Map<String, dynamic> _) {
        this.widget.onChanged(this._key.currentState);
      },
      child: Column(
        children: <Widget>[
          FormBuilderTextField(
            attribute: 'content',
            decoration: InputDecoration(labelText: 'Content'),
            maxLength: 256,
            maxLines: 3,
            minLines: 3,
            validators: [FormBuilderValidators.required()],
          ),
          FormBuilderDateTimePicker(
            attribute: 'reminder',
            decoration: InputDecoration(labelText: 'Reminder (optional)'),
            format: _formatter,
          ),
        ],
      ),
    );
  }
}

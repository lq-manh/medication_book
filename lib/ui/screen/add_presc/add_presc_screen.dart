import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/bloc/add_presc_bloc.dart';
import 'package:medication_book/bloc/bloc_provider.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/screen/add_presc/add_drug_screen.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/text_input.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/reminder_controller.dart';
import 'package:medication_book/utils/utils.dart';

class AddPrescScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AddPrescBloc(),
      child: AddPresc(),
    );
  }
}

class AddPresc extends StatefulWidget {
  @override
  _AddPrescState createState() => _AddPrescState();
}

class _AddPrescState extends State<AddPresc> {
  Prescription presc;
  List<Drug> listDrug;

  PrescriptionApi prescAPI = new PrescriptionApi();
  ReminderAPI reminderAPI = new ReminderAPI();

  ReminderController reCtrl = new ReminderController();

  bool isSaving = false;

  TextEditingController prescNameCtrl;
  TextEditingController prescDescCtrl;
  TextEditingController prescDurationCtrl;
  TextEditingController prescStartDayCtrl;
  TextEditingController prescEndDayCtrl;

  TextEditingController drugNameCtrl;
  TextEditingController drugNoteCtrl;
  TextEditingController drugAmountCtrl;
  TextEditingController drugDosageCtrl;

  AddPrescBloc _bloc;

  @override
  void initState() {
    super.initState();

    reCtrl.init();

    presc = new Prescription(
        name: "My Prescription",
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        desc: "Your illness",
        duration: 3,
        drugStore: null);

    listDrug = [];

    prescNameCtrl = new TextEditingController(text: presc.name);
    prescDescCtrl = new TextEditingController(text: presc.desc);

    prescDurationCtrl =
        new TextEditingController(text: presc.duration.toString());

    prescStartDayCtrl =
        new TextEditingController(text: Utils.convertDatetime(presc.date));

    prescEndDayCtrl = new TextEditingController(
        text: Utils.getNextDay(presc.date, presc.duration));

    _bloc = BlocProvider.of<AddPrescBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ContentLayout(
        topBar: TopBar(
          title: 'Add Prescription',
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        main: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                renderPrescEdit(),
                SizedBox(height: 20),
                renderDrugsEdit(),
                SizedBox(height: 20),
                renderAddPrescBtn(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderPrescEdit() {
    return Column(
      children: <Widget>[
        Heading(
          title: "Prescription",
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              TextInput(
                label: "Presc Name",
                ctrl: prescNameCtrl,
                suffix: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
                onSubmitted: (text) {
                  presc.name = text;
                },
                onChanged: (text) {
                  presc.name = text;
                },
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Description",
                ctrl: prescDescCtrl,
                suffix: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
                onSubmitted: (text) {
                  presc.desc = text;
                },
                onChanged: (text) {
                  presc.desc = text;
                },
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Duration",
                ctrl: prescDurationCtrl,
                suffix: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
                textInputType: TextInputType.number,
                onSubmitted: (number) {
                  int duration = int.parse(number);

                  if (duration > 0) {
                    presc.duration = duration;

                    prescEndDayCtrl.text =
                        Utils.getNextDay(presc.date, duration);
                  }
                  else {
                    prescDurationCtrl.text = presc.duration.toString();
                    Fluttertoast.showToast(msg: "Duration <= 0 is not allowed");
                  }
                },
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Start Day",
                ctrl: prescStartDayCtrl,
                enabled: false,
                inputFontSize: 16,
              ),
              TextInput(
                label: "End Day",
                ctrl: prescEndDayCtrl,
                enabled: false,
                inputFontSize: 16,
              ),
            ],
          ),
        )
      ],
    );
  }

  renderDrugsEdit() {
    return Column(
      children: <Widget>[
        Heading(
          title: "Drugs",
          action: IconButton(
            icon: Icon(FontAwesomeIcons.plusCircle),
            iconSize: 20,
            color: ColorPalette.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddDrugScreen(listDrug: listDrug),
                ),
              );
            },
          ),
        ),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 0),
            itemCount: listDrug.length,
            itemBuilder: (context, index) {
              Drug drug = listDrug[index];
              return DrugItem(
                drug: drug,
                showSession: true,
              );
            },
          ),
        )
      ],
    );
  }

  renderAddPrescBtn() {
    if (isSaving) return LoadingCircle();

    return LargeButton(
      title: "Add Prescription",
      onPressed: createPresc,
    );
  }

  createPresc() async {
    if (listDrug.length <= 0) {
      Fluttertoast.showToast(msg: "Please add some drugs");
    } else {
      setState(() {
        isSaving = true;
      });

      await _bloc.createPresc(presc, listDrug);

      Navigator.pop(context);
    }
  }
}

class Heading extends StatelessWidget {
  final String title;
  final Widget action;

  Heading({Key key, this.title, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: ColorPalette.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          action == null ? Container() : action,
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

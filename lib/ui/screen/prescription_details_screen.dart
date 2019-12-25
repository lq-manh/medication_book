import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/ui/screen/scanning/reminder_analyzer_screen.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  final Prescription prescription;
  final bool isView;

  PrescriptionDetailsScreen(this.prescription, this.isView);

  @override
  _PrescriptionDetailsScreenState createState() =>
      _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentLayout(
        topBar: TopBar(
          title: widget.prescription.drugStore.name,
          action: Container(),
          bottom: renderBottomAppBar(),
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
          child: renderBody(),
        ),
      ),
    );
  }

  renderBody() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          renderPrescBasicInfo(),
          renderDrugTable(),
          SizedBox(height: 20),
          widget.isView ? Container() : renderRemindBtn(),
        ],
      ),
    );
  }

  renderPrescBasicInfo() {
    TextStyle fieldStyle = TextStyle(
      color: ColorPalette.blue,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    TextStyle fieldStyle2 = TextStyle(
        color: ColorPalette.darkerGrey,
        fontSize: 14,
        fontWeight: FontWeight.w300);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Description", style: fieldStyle),
              Expanded(
                child: Text(
                  widget.prescription.desc,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: fieldStyle2,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("Date", style: fieldStyle),
              Expanded(
                child: Text(
                  Utils.convertDatetime(widget.prescription.date),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: fieldStyle2,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("Duration", style: fieldStyle),
              Expanded(
                child: Text(
                  widget.prescription.duration.toString() + " days",
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fieldStyle2,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("Start Date", style: fieldStyle),
              Expanded(
                child: Text(
                  Utils.convertDatetime(widget.prescription.date),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fieldStyle2,
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text("End Date", style: fieldStyle),
              Expanded(
                child: Text(
                  Utils.getNextDay(
                      widget.prescription.date, widget.prescription.duration),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fieldStyle2,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  renderDrugTable() {
    List<Drug> listDrug = widget.prescription.listDrugs;

    TextStyle fieldStyle = TextStyle(
      color: ColorPalette.blue,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    return Container(
      color: ColorPalette.white,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
      child: DataTable(
        columnSpacing: 15,
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              "Drug",
              style: fieldStyle,
            ),
          ),
          DataColumn(
            label: Text(
              "Amount",
              style: fieldStyle,
            ),
          ),
          DataColumn(
            label: Text(
              "Dosage",
              style: fieldStyle,
            ),
          ),
          DataColumn(
            label: Text(
              "Session",
              style: fieldStyle,
            ),
          )
        ],
        rows: renderDrudRows(listDrug),
      ),
    );
  }

  renderDrudRows(List<Drug> listDrug) {
    TextStyle fieldStyle2 = TextStyle(
        color: ColorPalette.darkerGrey,
        fontSize: 12,
        fontWeight: FontWeight.w300);

    return listDrug.map((drug) {
      return DataRow(
        cells: <DataCell>[
          DataCell(
            Text(
              drug.name,
              style: fieldStyle2,
            ),
          ),
          DataCell(
            Text(
              Utils.convertDoubletoString(drug.totalAmount) + " " + drug.unit,
              style: fieldStyle2,
            ),
          ),
          DataCell(
            Text(
              Utils.convertDoubletoString(drug.dosage) + " " + drug.unit,
              style: fieldStyle2,
            ),
          ),
          DataCell(
            Row(
              children: drug.sessions.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Utils.getSessionIcon(s, 14),
                );
              }).toList(),
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ],
      );
    }).toList();
  }

  renderRemindBtn() {
    return LargeButton(
      title: "Save & Remind Me",
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ReminderAnalyzerScreen(prescription: widget.prescription)));
      },
    );
  }

  renderBottomAppBar() {
    DrugStore drugStore = widget.prescription.drugStore;

    TextStyle style =
        TextStyle(color: ColorPalette.white, fontWeight: FontWeight.w300);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.mapMarkerAlt,
                color: ColorPalette.white,
                size: 14,
              ),
              SizedBox(width: 5),
              Text(
                drugStore.address,
                style: style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(
                FontAwesomeIcons.phoneAlt,
                color: ColorPalette.white,
                size: 14,
              ),
              SizedBox(width: 5),
              Text(
                drugStore.phoneNumber,
                style: style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/api/prescription_api.dart';
import 'package:medication_book/api/reminder_api.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/ui/screen/reminder_setting_screen.dart';
import 'package:medication_book/ui/screen/prescription_details_screen.dart';
import 'package:medication_book/ui/widgets/cards.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/global.dart';
import 'package:medication_book/utils/utils.dart';

import 'add_presc/add_presc_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryScreen> {
  PrescriptionApi prescApi = new PrescriptionApi();
  ReminderAPI reminderApi = new ReminderAPI();

  List<Prescription> listPresc = [];

  bool loading;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    getListPresc();
  }

  getListPresc() async {
    setState(() {
      loading = true;
    });

    listPresc = [];

    listPresc = await prescApi.getAllPresc();

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentLayout(
        topBar: TopBar(
          title: 'Prescriptions',
          leading: Container(),
          action: renderTopBarAction(),
        ),
        main: Container(
            child: loading
                ? LoadingCircle()
                : listPresc.length > 0
                    ? ListView.builder(
                        itemCount: listPresc.length,
                        itemBuilder: (context, index) {
                          return renderPrescItem(listPresc[index]);
                        },
                      )
                    : renderEmpty()));
  }

  renderTopBarAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        icon: new Icon(
          FontAwesomeIcons.plus,
          size: 20,
          color: ColorPalette.white,
        ),
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPrescScreen()));

          getListPresc();
        },
      ),
    );
  }

  renderEmpty() {
    return Column(
      children: <Widget>[
        Image.asset(
          "assets/image/prescription.png",
          width: 120,
          color: Colors.black26,
        ),
        SizedBox(height: 10),
        Text(
          "No Prescription",
          style: TextStyle(
              color: Colors.black26, fontWeight: FontWeight.w500, fontSize: 18),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  renderPrescItem(Prescription presc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ReminderSettingScreen(prescription: presc)));
        },
        child: RoundedCard(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: <Widget>[
                Image.asset(
                  "assets/image/medicineIcon2.png",
                  width: 40,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        presc.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorPalette.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        presc.drugStore.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorPalette.blacklight,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        Utils.convertDatetime(presc.date),
                        style: TextStyle(
                            color: ColorPalette.blacklight,
                            fontWeight: FontWeight.w300,
                            fontSize: 14,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
                renderActionBtn(presc)
                // IconButton(
                //   icon: Icon(
                //     FontAwesomeIcons.ellipsisV,
                //     color: Colors.black38,
                //   ),
                //   iconSize: 18,
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderActionBtn(Prescription presc) {
    return PopupMenuButton(
      icon: Icon(
        FontAwesomeIcons.ellipsisV,
        color: Colors.black38,
        size: 18,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (value) {
        onActionSelected(value, presc);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: "detail",
          child: Row(
            children: <Widget>[
              Text(
                'View details',
                style: TextStyle(
                  color: ColorPalette.blacklight,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
              Icon(
                FontAwesomeIcons.chevronRight,
                color: Colors.black38,
                size: 16,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        PopupMenuItem(
          value: "delete",
          child: Text(
            'Delete',
            style: TextStyle(
              color: ColorPalette.red,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  onActionSelected(dynamic value, Prescription presc) async {
    print(value);
    if (value == "detail")
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PrescriptionDetailsScreen(presc, true)));

    if (value == "delete") {
      await deletePresc(presc);

      listPresc.remove(presc);

      Global.hasChangedData = true;

      setState(() {});
    }
  }

  deletePresc(Prescription presc) async {
    await reminderApi.deleteReminderByPrescID(presc.id);

    await prescApi.deletePresc(presc);
  }
}

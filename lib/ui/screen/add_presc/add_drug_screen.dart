import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/drug_type.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/text_input.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class AddDrugScreen extends StatefulWidget {
  final List<Drug> listDrug;

  AddDrugScreen({Key key, this.listDrug}) : super(key: key);

  @override
  _AddDrugScreenState createState() => _AddDrugScreenState();
}

class _AddDrugScreenState extends State<AddDrugScreen> {
  List<DrugType> listType = Utils.listType;

  SwiperController _scrollController = new SwiperController();
  int swiperIndex = 2;
  DrugType currentType;

  TextEditingController drugNameCtrl;
  TextEditingController drugNoteCtrl;
  TextEditingController drugAmountCtrl;
  TextEditingController drugDosageCtrl;

  bool isSelectedDaytime = true;
  bool isSelectedNighttime = false;

  Drug drug;

  @override
  void initState() {
    super.initState();

    currentType = listType[swiperIndex];

    drug = new Drug(
      name: "Drug A",
      note: "Some notes",
      totalAmount: 10,
      dosage: 1,
    );

    drugNameCtrl = new TextEditingController(text: drug.name);

    drugNoteCtrl = new TextEditingController(text: drug.note);

    drugAmountCtrl = new TextEditingController(
        text: Utils.convertDoubletoString(drug.totalAmount));

    drugDosageCtrl = new TextEditingController(
        text: Utils.convertDoubletoString(drug.dosage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ContentLayout(
        topBar: TopBar(
          title: 'Add Drug',
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
                SizedBox(height: 20),
                renderDrugTypeSwiper(),
                SizedBox(height: 20),
                renderDrugForm(),
                SizedBox(height: 20),
                LargeButton(
                  title: "Add",
                  onPressed: addDrug,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  renderDrugTypeSwiper() {
    return Container(
      height: 100,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 0,
            left: 0,
            child: Center(
              child: Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    width: 2,
                    color: ColorPalette.blue.withOpacity(0.65),
                  ),
                ),
              ),
            ),
          ),
          Swiper(
            itemCount: listType.length,
            viewportFraction: 0.2,
            scale: 1,
            loop: true,
            fade: 0.2,
            index: swiperIndex,
            onIndexChanged: (index) {
              swiperIndex = index;
              currentType = listType[swiperIndex];

              setState(() {});
            },
            onTap: (index) {
              _scrollController.move(index, animation: true);
            },
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              DrugType type = listType[index];
              return Column(
                children: <Widget>[
                  Image.asset(
                    type.imagePath,
                    width: 60,
                    height: 60,
                  ),
                  Text(
                    type.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorPalette.blacklight,
                    ),
                  ),
                ],
                // mainAxisAlignment: MainAxisAlignment.center,
              );
            },
          ),
        ],
      ),
    );
  }

  renderDrugForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          TextInput(
            label: "Drug Name",
            ctrl: drugNameCtrl,
            suffix: Icon(
              Icons.edit,
              size: 14,
              color: ColorPalette.green,
            ),
            hintText: "Enter drug name",
            onSubmitted: (text) {
              drug.name = text;
            },
            onChanged: (text) {
              drug.name = text;
            },
          ),
          SizedBox(height: 10),
          TextInput(
            label: "Drug Note",
            ctrl: drugNoteCtrl,
            suffix: Icon(
              Icons.edit,
              size: 14,
              color: ColorPalette.green,
            ),
            hintText: "Enter drug note",
            onSubmitted: (text) {
              drug.note = text;
            },
            onChanged: (text) {
              drug.note = text;
            },
          ),
          SizedBox(height: 10),
          TextInput(
            label: "Amount",
            ctrl: drugAmountCtrl,
            suffix: Text(
              currentType.unit,
              style: TextStyle(
                color: ColorPalette.blacklight,
              ),
            ),
            hintText: "Enter amount",
            textInputType: TextInputType.number,
            onSubmitted: (text) {
              drug.totalAmount = double.parse(text);
            },
            onChanged: (text) {
              drug.totalAmount = double.parse(text);
            },
          ),
          SizedBox(height: 10),
          TextInput(
            label: "Dosage",
            ctrl: drugDosageCtrl,
            suffix: Text(
              currentType.unit,
              style: TextStyle(
                color: ColorPalette.blacklight,
              ),
            ),
            hintText: "Enter dosage",
            textInputType: TextInputType.number,
            onSubmitted: (text) {
              drug.dosage = double.parse(text);
            },
            onChanged: (text) {
              drug.dosage = double.parse(text);
            },
          ),
          SizedBox(height: 10),
          renderSessionOptions()
        ],
      ),
    );
  }

  renderSessionOptions() {
    return Row(
      children: <Widget>[
        Text(
          "Sessions",
          style: TextStyle(
            color: ColorPalette.blue,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: Session.values.map((s) {
            return Container(
              child: renderSession(s),
            );
          }).toList(),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  renderSession(Session s) {
    return GestureDetector(
      onTap: () {
        if (s == Session.MORNING)
          setState(() {
            isSelectedDaytime = !isSelectedDaytime;
          });

        if (s == Session.EVENING)
          setState(() {
            isSelectedNighttime = !isSelectedNighttime;
          });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: 90,
        height: 90,
        decoration: borderSessionContainer(s),
        child: Column(
          children: <Widget>[
            Utils.getSessionIcon(s, 30),
            SizedBox(height: 5),
            Text(Utils.convertSessionToString(s)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  borderSessionContainer(Session s) {
    if (s == Session.MORNING) {
      if (isSelectedDaytime)
        return BoxDecoration(
          border:
              Border.all(color: ColorPalette.blue.withOpacity(0.65), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(45)),
        );
      else
        return null;
    }

    if (s == Session.EVENING) {
      if (isSelectedNighttime)
        return BoxDecoration(
          border:
              Border.all(color: ColorPalette.blue.withOpacity(0.65), width: 2),
          borderRadius: BorderRadius.all(Radius.circular(45)),
        );
      else
        return null;
    }

    return null;
  }

  addDrug() {
    drug.sessions = [];
    drug.type = currentType.name;
    drug.unit = currentType.unit;

    if (isSelectedDaytime) drug.sessions.add(Session.MORNING);
    if (isSelectedNighttime) drug.sessions.add(Session.EVENING);

    widget.listDrug.add(drug);

    Navigator.pop(context);
  }
}

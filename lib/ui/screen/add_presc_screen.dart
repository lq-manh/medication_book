import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/drug_type.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/models/reminder.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/ui/widgets/drug_item.dart';
import 'package:medication_book/ui/widgets/large_button.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';
import 'package:medication_book/utils/utils.dart';

class AddPrescScreen extends StatefulWidget {
  @override
  _AddPrescScreenState createState() => _AddPrescScreenState();
}

class _AddPrescScreenState extends State<AddPrescScreen> {
  Prescription presc;
  List<Reminder> listReminder;
  List<Drug> listDrug;

  bool isSaving = false;

  TextEditingController prescNameCtrl;
  TextEditingController prescDescCtrl;
  TextEditingController prescDurationCtrl;
  TextEditingController prescStartDayCtrl;
  TextEditingController prescEndDayCtrl;

  @override
  void initState() {
    super.initState();

    presc = new Prescription(
        name: "My Prescription",
        date: DateTime.now().millisecondsSinceEpoch.toString(),
        desc: "Your illness",
        duration: 3,
        drugStore: null);

    listDrug = [
      new Drug(
          dosage: 1,
          name: "Chochola",
          sessions: [Session.MORNING, Session.EVENING],
          totalAmount: 10,
          unit: "pill"),
      new Drug(
          dosage: 1,
          name: "SuSuMi",
          sessions: [Session.MORNING, Session.EVENING],
          totalAmount: 10,
          unit: "pill")
    ];

    prescNameCtrl = new TextEditingController(text: presc.name);
    prescDescCtrl = new TextEditingController(text: presc.desc);

    prescDurationCtrl =
        new TextEditingController(text: presc.duration.toString());

    prescStartDayCtrl =
        new TextEditingController(text: Utils.convertDatetime(presc.date));

    prescEndDayCtrl = new TextEditingController(
        text: Utils.getNextDay(presc.date, presc.duration));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                suffixIcon: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Description",
                ctrl: prescDescCtrl,
                suffixIcon: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
              ),
              SizedBox(height: 10),
              TextInput(
                label: "Duration",
                ctrl: prescDurationCtrl,
                suffixIcon: Icon(
                  Icons.edit,
                  size: 14,
                  color: ColorPalette.green,
                ),
                textInputType: TextInputType.number,
                onSubmitted: (number) {
                  prescEndDayCtrl.text =
                      Utils.getNextDay(presc.date, int.parse(number));
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
            onPressed: renderDrugModal,
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
              return DrugItem(drug: drug);
            },
          ),
        )
      ],
    );
  }

  renderAddPrescBtn() {
    return LargeButton(
      title: "Add Prescription",
      onPressed: () {},
    );
  }

  renderDrugModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                "Add Drug",
                style: TextStyle(
                  color: ColorPalette.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              renderDrugTypeSwiper(),
              renderDrugForm(),
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
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
            ctrl: new TextEditingController(text: "a"),
            suffixIcon: Icon(
              Icons.edit,
              size: 14,
              color: ColorPalette.green,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  List<DrugType> listType = [
    DrugType("pill", "assets/image/pill.png"),
    DrugType("syrup", "assets/image/syrup.png"),
    DrugType("syringe", "assets/image/syringe.png"),
    DrugType("drops", "assets/image/drops.png"),
    DrugType("capsule", "assets/image/capsule.png"),
  ];

  SwiperController _scrollController = new SwiperController();

  renderDrugTypeSwiper() {
    return Container(
        height: 90,
        child: Stack(
          children: <Widget>[
            Positioned(
              // top: 0,
              right: 0,
              // bottom: 0,
              left: 0,
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 2,
                      color: ColorPalette.blue.withOpacity(0.65),
                    ),
                  ),
                ),
              ),
            ),
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                DrugType type = listType[index];

                return Column(
                  children: <Widget>[
                    Image.asset(
                      type.imagePath,
                      width: 50,
                      height: 50,
                    ),
                    Text(type.name),
                  ],
                );
              },

              itemCount: listType.length,
              viewportFraction: 0.2,
              scale: 1,
              loop: true,
              fade: 0.2,
              // onIndexChanged: widget.onChanged,
              // onTap: (index) {
              //   _scrollController.move(index, animation: true);
              // },
              controller: _scrollController,
              // pagination: new SwiperPagination(),
              // control: new SwiperControl(),
            ),
          ],
        ));
  }
}

class TextInput extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final Icon suffixIcon;
  final Function onSubmitted;
  final Function onChanged;
  final TextInputType textInputType;
  final bool enabled;
  final double inputFontSize;

  TextInput(
      {Key key,
      this.label,
      this.ctrl,
      this.suffixIcon,
      this.onSubmitted,
      this.onChanged,
      this.textInputType = TextInputType.text,
      this.enabled = true,
      this.inputFontSize = 20})
      : super(key: key);

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    TextStyle fieldStyle = TextStyle(
      color: ColorPalette.blue,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    TextStyle fieldStyle2 = TextStyle(
      color: ColorPalette.blacklight,
      fontSize: widget.inputFontSize,
      fontWeight: FontWeight.w300,
    );

    return Row(
      children: <Widget>[
        Text(widget.label, style: fieldStyle),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              controller: widget.ctrl,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: ColorPalette.blue, width: 1),
                  ),
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  suffix: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: widget.suffixIcon,
                  )),
              style: fieldStyle2,
              onSubmitted: widget.onSubmitted,
              onChanged: widget.onChanged,
              enabled: widget.enabled,
              keyboardType: widget.textInputType,
            ),
          ),
        )
      ],
    );
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

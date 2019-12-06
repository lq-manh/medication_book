import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';

import 'cards.dart';

class DrugItem extends StatefulWidget {
  final Drug drug;

  const DrugItem({Key key, this.drug}) : super(key: key);

  @override
  _DrugItemState createState() => _DrugItemState();
}

class _DrugItemState extends State<DrugItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
      child: RoundedCard(
          child: Container(
        width: 250,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.drug.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ColorPalette.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.drug.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: ColorPalette.blacklight,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ),
              Column(
                children: <Widget>[
                  Image.asset(
                    "assets/image/medicineIcon.png",
                    height: 40,
                  ),
                  Text(
                    (widget.drug.dosage > widget.drug.dosage.floor()
                            ? widget.drug.dosage.toString()
                            : widget.drug.dosage.floor().toString()) +
                        " " +
                        widget.drug.unit,
                    style: TextStyle(
                      color: ColorPalette.blacklight,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              )
            ],
          ),
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/drug.dart';
import 'package:medication_book/models/session.dart';
import 'package:medication_book/utils/utils.dart';

import 'cards.dart';

class DrugItem extends StatefulWidget {
  final Drug drug;
  final bool showSession;
  final bool removable;
  final Function onRemove;

  const DrugItem({
    Key key,
    this.drug,
    this.showSession = false,
    this.removable = false,
    this.onRemove,
  }) : super(key: key);

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
          child: Stack(
            children: <Widget>[
              renderBody(),
              if (widget.removable) renderRemoveBtn()
            ],
          ),
        ),
      ),
    );
  }

  renderBody() {
    return Container(
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
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.drug.note != null ? widget.drug.note : "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: ColorPalette.darkerGrey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                if (widget.showSession)
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      renderSession(widget.drug.sessions)
                    ],
                  )
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          Column(
            children: <Widget>[
              Image.asset(
                Utils.getImageType(widget.drug.type),
                height: 60,
              ),
              Text(
                "${Utils.convertDoubletoString(widget.drug.dosage)} ${widget.drug.unit}",
                style: TextStyle(
                    color: ColorPalette.darkerGrey,
                    fontWeight: FontWeight.w300),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          )
        ],
      ),
    );
  }

  renderRemoveBtn() {
    return Positioned(
      top: 5,
      right: 5,
      child: GestureDetector(
        onTap: widget.onRemove,
        child: Icon(
          FontAwesomeIcons.solidTimesCircle,
          color: ColorPalette.red,
          size: 20,
        ),
      ),
    );
  }

  renderSession(List<Session> session) {
    return Row(
      children: session
          .map((s) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Utils.getSessionIcon(s, 20),
              ))
          .toList(),
    );
  }
}

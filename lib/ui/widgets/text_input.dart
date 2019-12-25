import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class TextInput extends StatefulWidget {
  final String label;
  final TextEditingController ctrl;
  final Widget suffix;
  final Function onSubmitted;
  final Function onChanged;
  final TextInputType textInputType;
  final bool enabled;
  final double inputFontSize;
  final String hintText;

  TextInput(
      {Key key,
      this.label,
      this.ctrl,
      this.suffix,
      this.onSubmitted,
      this.onChanged,
      this.textInputType = TextInputType.text,
      this.enabled = true,
      this.inputFontSize = 20,
      this.hintText})
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
      color: ColorPalette.darkerGrey,
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
                    child: widget.suffix,
                  ),
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: Colors.black26)),
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

import 'package:flutter/material.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class ContentLayout extends StatefulWidget {
  final TopBar topBar;
  final Widget main;

  ContentLayout({this.topBar, this.main});

  @override
  _ContentLayoutState createState() => _ContentLayoutState();
}

class _ContentLayoutState extends State<ContentLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white10),
      child: Column(
        children: <Widget>[
          widget.topBar,
          if (widget.main != null) Expanded(child: widget.main),
        ],
      ),
    );
  }
}

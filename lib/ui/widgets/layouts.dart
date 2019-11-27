import 'package:flutter/material.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class ContentLayout extends StatelessWidget {
  final TopBar topBar;
  final Widget main;

  ContentLayout({this.topBar, this.main});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        this.topBar,
        if (this.main != null) Expanded(child: this.main),
      ],
    );
  }
}

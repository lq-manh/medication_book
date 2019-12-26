import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class ContentLayout extends StatelessWidget {
  final TopBar topBar;
  final Widget main;
  final BoxDecoration backgroundDecoration;

  ContentLayout({@required this.topBar, this.main, this.backgroundDecoration});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: this.backgroundDecoration ??
          BoxDecoration(color: ColorPalette.lightGrey),
      child: Column(
        children: <Widget>[
          this.topBar,
          if (this.main != null) Expanded(child: this.main),
        ],
      ),
    );
  }
}

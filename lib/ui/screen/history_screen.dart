import 'package:flutter/material.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ContentLayout(
      topBar: TopBar(
        title: 'Histories',
        bottom: Container(),
        leading: Container(),
        action: Container(),
      ),
      main: Container()
    );
  }
}

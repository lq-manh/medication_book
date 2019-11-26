import 'package:flutter/material.dart';
import 'package:medication_book/ui/widgets/cards.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RoundedCard(
        child: Container(
          width: 300,
          height: 200,
        ),
      ),
    );
  }
}

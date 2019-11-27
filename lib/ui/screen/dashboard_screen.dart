import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image(
          image: AssetImage('assets/image/splash_logo.png'),
          width: 128,
          height: 128,
        ),
      ),
    );
  }
}

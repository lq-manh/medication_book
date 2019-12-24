import 'package:flutter/material.dart';

class ColorPalette {
  static const Color black = Colors.black;
  static const Color darkerGrey = Color(0xFF404040);
  static const Color darkGrey = Color(0xFF606060);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color white = Colors.white;

  static const Color blue = Color(0xFF42A3E3);
  static const Color green = Color(0xFF58D6B4);
  static const Color red = Color(0xFFFF3400);
  static const Color sunOrange = Color(0xFFFF9100);

  static const Color textBody = ColorPalette.darkGrey;
}

final BoxShadow commonBoxShadow = BoxShadow(
  color: ColorPalette.darkGrey.withOpacity(0.1),
  offset: Offset(0, 5),
  blurRadius: 5,
);

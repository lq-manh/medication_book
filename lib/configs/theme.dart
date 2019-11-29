import 'package:flutter/material.dart';

class ColorPalette {
  static const Color black = Colors.black;
  static const Color blue = Color(0xFF42A3E3);
  static const Color green = Color(0xFF58D6B4);
  static const Color white = Colors.white;
  static const Color blacklight = Color(0xFF505050);
}

final BoxShadow commonBoxShadow = BoxShadow(
  color: ColorPalette.black.withOpacity(0.15),
  offset: Offset(0, 5),
  blurRadius: 10,
);

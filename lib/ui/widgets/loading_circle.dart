import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';

class LoadingCircle extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;

  const LoadingCircle({Key key, this.size, this.color, this.strokeWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size == null ? 40 : size,
        width: size == null ? 40 : size,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              color == null ? ColorPalette.blue : color),
          strokeWidth: strokeWidth == null ? 4.0 : strokeWidth,
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:medication_book/ui/animation/quick_action_menu.dart';

class BlurredOverlay extends StatelessWidget {
  final Function onTapCancel;

  const BlurredOverlay({Key key, this.onTapCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapCancel();
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade500.withOpacity(0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                    // horizontal: 40,
                  ),
                  child: QuickActionMenu(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

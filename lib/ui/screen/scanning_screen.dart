import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class Scanning extends StatefulWidget {
  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  QRReaderController scanQRCodeController;

  @override
  void initState() {
    super.initState();
    initScanner();
  }

  initScanner() async {
    if (cameras.length > 0) {
      scanQRCodeController = new QRReaderController(
          cameras[0], ResolutionPreset.medium, [CodeFormat.qr],
          (dynamic value) {
            print(value);
        scanQRCodeController.stopScanning();
        // detectQRCode(value).then((_) {
        //   widget.scanQRCodeController.startScanning();
        // });
      });
      scanQRCodeController.initialize().then((_) {
        if (!mounted)
          return;
        else {
          setState(() {});
          scanQRCodeController.startScanning();
        }
      });
    }
  }

  Widget renderQRScanner() {
    if (scanQRCodeController != null) {
      if (scanQRCodeController.value.isInitialized) {
        return ClipRect(
          child: AspectRatio(
            aspectRatio: scanQRCodeController.value.aspectRatio,
            child: new QRReaderPreview(scanQRCodeController),
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              width: screenWidth,
              height: screenHeight,
              child: renderQRScanner(),
            ),
          ],
        ),
      ),
    );
  }
}

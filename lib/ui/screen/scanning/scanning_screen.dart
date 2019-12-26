import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medication_book/bloc/scanning_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/models/prescription.dart';
import 'package:medication_book/ui/screen/prescription_details_screen.dart';

class Scanning extends StatefulWidget {
  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  ScanningBloc scanningBloc = new ScanningBloc();

  QRReaderController scanQRCodeController;
  List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initScanner();
  }

  initScanner() async {
    cameras = await availableCameras();

    if (cameras.length > 0) {
      scanQRCodeController = new QRReaderController(
          cameras[0], ResolutionPreset.medium, [CodeFormat.qr],
          (dynamic value) async {
        scanQRCodeController.stopScanning();
        print(value);
        Prescription prescription = await scanningBloc.detect(value);
        if (prescription != null) {
          showScanningResult(prescription);
        } else {
          await Fluttertoast.showToast(msg: "Can not detect this QR code.");

          scanQRCodeController.startScanning();
        }
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

  showScanningResult(Prescription prescription) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            scanQRCodeController.startScanning();
            return true;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/background-scan.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Text("Your Prescription",
                    style: TextStyle(
                        color: ColorPalette.blue, fontWeight: FontWeight.bold)),
                renderPrescription(prescription),
                renderDetailBtn(prescription),
                SizedBox(height: 10)
              ],
            ),
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    );
  }

  Widget renderPrescription(Prescription prescription) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Column(children: <Widget>[
                  Text(
                    "Drug store: ",
                    style: TextStyle(
                      color: ColorPalette.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    prescription.drugStore.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(color: ColorPalette.darkerGrey),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
                SizedBox(height: 10),
                Column(children: <Widget>[
                  Text(
                    "Address: ",
                    style: TextStyle(
                      color: ColorPalette.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    prescription.drugStore.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(color: ColorPalette.darkerGrey),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
                SizedBox(height: 10),
                Column(children: <Widget>[
                  Text(
                    "Medicine description: ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: ColorPalette.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    prescription.desc,
                    style: TextStyle(color: ColorPalette.darkerGrey),
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
      ],
    );
  }

  renderDetailBtn(Prescription prescription) {
    return GestureDetector(
      onTap: () async {
        scanQRCodeController?.dispose();

        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PrescriptionDetailsScreen(prescription, false)));

        initScanner();
      },
      child: Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                ColorPalette.blue.withOpacity(0.8),
                ColorPalette.green.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          children: <Widget>[
            Text(
              "View Details",
              style: TextStyle(fontSize: 14, color: ColorPalette.white),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_forward,
              color: ColorPalette.white,
              size: 14,
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
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
        return Container(
          color: ColorPalette.white,
        );
      }
    } else {
      return Container(
        color: ColorPalette.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: screenWidth,
            height: screenHeight,
            child: renderQRScanner(),
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            child: Column(
              children: <Widget>[
                HeaderBar(),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(color: Colors.black45.withOpacity(0.5)),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                                color: Colors.black45.withOpacity(0.5)),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorPalette.white.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.black45.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.black45.withOpacity(0.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              margin: EdgeInsets.all(20), 
                              child: Text(
                                "Move camera to QR Code to get the prescription",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorPalette.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    scanQRCodeController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      scanQRCodeController?.dispose();
    }

    if (state == AppLifecycleState.resumed) {
      initScanner();
    }
  }
}

class HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
      color: Colors.black45.withOpacity(0.5),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorPalette.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "Scan Bill",
            style: TextStyle(color: ColorPalette.white, fontSize: 18),
          ),
          IconButton(
            icon: Icon(
              Icons.photo,
              color: ColorPalette.white.withOpacity(0),
            ),
            onPressed: () {},
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

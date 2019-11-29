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
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0),
                              child: Text("Your Prescription",
                                  style: TextStyle(
                                      color: ColorPalette.blue,
                                      fontWeight: FontWeight.bold)),
                            ),
                            renderPrescription(prescription),
                            renderDetailBtn(prescription)
                          ])))),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget renderPrescription(Prescription prescription) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Image.asset(
            "assets/image/medicine.png",
            height: 100,
          ),
          SizedBox(width: 25),
          Column(
            children: <Widget>[
              Column(children: <Widget>[
                Text(
                  "Drug store: ",
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  prescription.drugStore.name,
                  style: TextStyle(color: Colors.black38),
                ),
              ], crossAxisAlignment: CrossAxisAlignment.start),
              SizedBox(height: 10),
              Column(children: <Widget>[
                Text(
                  "Address: ",
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  prescription.drugStore.address,
                  style: TextStyle(color: Colors.black38),
                ),
              ], crossAxisAlignment: CrossAxisAlignment.start),
              SizedBox(height: 10),
              Column(children: <Widget>[
                Text(
                  "Medicine description: ",
                  style: TextStyle(color: Colors.black87),
                ),
                Text(
                  prescription.desc,
                  style: TextStyle(color: Colors.black38),
                ),
              ], crossAxisAlignment: CrossAxisAlignment.start),
              //Text(prescription.drugStore.name, style: TextStyle(color: Colors.black87, fontSize: 16),),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          )
        ],
        //crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  renderDetailBtn(Prescription prescription) {
    return Container(
      height: 50,
      child: RaisedButton(
        onPressed: () async {
          scanQRCodeController?.dispose();

          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PrescriptionDetailsScreen(prescription))
          );

          initScanner();
        },
        color: ColorPalette.blue,
        child: Row(
          children: <Widget>[
            Text(
              "VIEW DETAILS",
              style: TextStyle(fontSize: 16, color: ColorPalette.white),
            ),
            SizedBox(width: 5,),
            Icon(Icons.arrow_forward, color: ColorPalette.white)
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
              //color: Colors.black38.withOpacity(0.5),
            ),
            Container(
              width: screenWidth,
              height: screenHeight,
              // child: renderQRScanner(),
              //color: Colors.black45.withOpacity(0.5),
              child: Column(
                children: <Widget>[
                  HeaderBar(),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Expanded(
                        child:
                            Container(color: Colors.black45.withOpacity(0.5)),
                        flex: 1,
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
                                width: MediaQuery.of(context).size.width * 0.6),
                            Expanded(
                              child: Container(
                                  color: Colors.black45.withOpacity(0.5)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                            Container(color: Colors.black45.withOpacity(0.5)),
                        flex: 2,
                      ),
                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.all(10),
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
              color: ColorPalette.white,
            ),
            onPressed: () {},
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

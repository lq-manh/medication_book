import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication_book/ui/screen/spash_screen.dart';
// import 'package:permission_handler/permission_handler.dart';

List<CameraDescription> cameras;

/// Application EntryPoint
//void main() => runApp(MyApp());

Future<Null> main() async {
  // SystemChrome.setSystemUIOverlayStyle(new SystemUiOverlayStyle(
  //     statusBarColor: Color(0xFF1980BA) // set status bar color
  // ));

  cameras = await availableCameras();

  // await PermissionHandler().requestPermissions([
  //   PermissionGroup.camera
  // ]);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

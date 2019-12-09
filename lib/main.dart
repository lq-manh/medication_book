import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication_book/ui/screen/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Null> main() async {
  await PermissionHandler().requestPermissions([
    PermissionGroup.camera
  ]);

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
        fontFamily: "GoogleSans"
      )
    );
  }
}

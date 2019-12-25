import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medication_book/ui/screen/splash_screen.dart';
import 'package:medication_book/utils/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Global.hasChangedData = false;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      theme: ThemeData(
        fontFamily: "GoogleSans",
        textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 1.15),
      ),
    );
  }
}

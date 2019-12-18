import 'package:flutter/material.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/ui/widgets/loading_circle.dart';
import 'package:medication_book/utils/secure_store.dart';
import 'package:medication_book/ui/screen/login_screen.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 120),
            Image(
              image: AssetImage('assets/image/app_icon_no_padding.png'),
              width: 256,
            ),
            Text(
              "Medication Book",
              style: TextStyle(
                color: ColorPalette.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            LoadingCircle(
              color: ColorPalette.white,
              size: 40,
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await Future.delayed(Duration(seconds: 3));
    await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    checkLogin();
  }

  void checkLogin() async {
    String uid = await SecureStorage.instance.read(key: 'uid');
    if (uid == null || uid == '') {
      setState(() {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()));
      });
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }
}

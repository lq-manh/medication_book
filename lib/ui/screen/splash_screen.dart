import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medication_book/utils/secure_store.dart';
import 'package:medication_book/ui/screen/login_screen.dart';
import 'package:medication_book/ui/screen/home_screen.dart';

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
      body: Center(
          child: Column(
        children: <Widget>[
          Expanded(
            child: Image(
              image: AssetImage('assets/image/splash_logo.png'),
              width: 256,
              height: 256,
            ),
            flex: 6,
          ),
          Expanded(
            child: Center(
              child: new SpinKitFadingCircle(
                color: Color.fromRGBO(249, 66, 58, 1),
                size: 50.0,
              ),
            ),
            flex: 3,
          ),
        ],
      )),
    );
  }

  @override
  void initState() {
    super.initState();
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

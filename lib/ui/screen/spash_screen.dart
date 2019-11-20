import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medication_book/utils/secure_store.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

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
            child: Image(image: AssetImage('assets/image/splash_logo.png')),
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
    String email = await SecureStorage.instance.read(key: 'email');
    String password = await SecureStorage.instance.read(key: 'password');
    String token = await SecureStorage.instance.read(key: 'token');
    if (email == null ||
        email == '' ||
        password == null ||
        password == '' ||
        token == null ||
        token == '') {
      // not login tey
    } else {
//      var result = await ChatWorkAPI().reLoginToChatwork(email, password, token);
//      var bodyResult = json.decode(result.body);
//      bool isSuccess = bodyResult['status']['success'];
//      if (isSuccess) {
//        setState(() {
//          Navigator.of(context).pushReplacement(
//              MaterialPageRoute(builder: (context) => ChatRoomScreen( cwData: bodyResult['result'],)));
//        });
//      } else {
//        setState(() {
//          Navigator.of(context).pushReplacement(
//              MaterialPageRoute(builder: (context) => LoginScreen()));
//        });
//      }
    }
  }
}

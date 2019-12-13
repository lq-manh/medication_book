import 'package:flutter/material.dart';
import 'package:medication_book/bloc/login_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  LoginBloc _loginBloc = new LoginBloc();

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorPalette.blue, ColorPalette.green],
          ),
        ),
        child: ContentLayout(
          topBar: TopBar(
            title: 'Sign In',
            hasShadow: false,
          ),
          main: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage('assets/image/app_icon_no_padding.png'),
                width: 256,
                height: 256,
              ),
              new Container(
                width: 300,
                height: 100,
                margin: EdgeInsets.only(top: 30, bottom: 20),
                child: Text(
                  'By sign in with social network, your data will be backed up in Cloud and you will able to sync data across your devices.',
                  style: TextStyle(color: ColorPalette.white),
                  textAlign: TextAlign.justify,
                ),
              ),
              new Container(
                width: 300,
                height: 60,
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: StreamBuilder(
                    stream: _loginBloc.googleLoginStream,
                    builder: (context, snapshot) => new RaisedButton(
                        padding:
                            EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
                        color: Colors.white,
                        onPressed: () {
                          _loginBloc.loginViaGoogle().then((result) {
                            if (result == LoginStatus.FINISH_LOGIN) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()));
                            }
                          });
                        },
                        child: (snapshot.hasData &&
                                snapshot.data == LoginStatus.START_LOGIN)
                            ? CircularProgressIndicator()
                            : new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/image/google-48.png',
                                    height: 36.0,
                                  ),
                                  new Container(
                                      padding: EdgeInsets.only(
                                          left: 30.0, right: 10.0),
                                      child: new Text(
                                        "Sign in with Google",
                                        textScaleFactor: 1.15,
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ))),
              ),
              new Container(
                width: 300,
                height: 60,
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: StreamBuilder(
                    stream: _loginBloc.facebookLoginStream,
                    builder: (context, snapshot) => new RaisedButton(
                        padding:
                            EdgeInsets.only(top: 3.0, bottom: 3.0, left: 3.0),
                        color: Color(0xff3b5998),
                        onPressed: () {
                          _loginBloc.loginViaFacebook().then((result) {
                            if (result == LoginStatus.FINISH_LOGIN) {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => HomeScreen()));
                            }
                          });
                        },
                        child: (snapshot.hasData &&
                                snapshot.data == LoginStatus.START_LOGIN)
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )
                            : new Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/image/facebook-logo.png',
                                    height: 36.0,
                                  ),
                                  new Container(
                                      padding: EdgeInsets.only(
                                          left: 30.0, right: 10.0),
                                      child: new Text(
                                        "Sign in with Facebook",
                                        textScaleFactor: 1.15,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

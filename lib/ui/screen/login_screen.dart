import 'package:flutter/material.dart';
import 'package:medication_book/bloc/login_bloc.dart';
import 'package:medication_book/configs/theme.dart';
import 'package:medication_book/ui/screen/home_screen.dart';
import 'package:medication_book/ui/widgets/buttons.dart';
import 'package:medication_book/ui/widgets/layouts.dart';
import 'package:medication_book/ui/widgets/top_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  LoginBloc _loginBloc = LoginBloc();

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ContentLayout(
        backgroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [ColorPalette.blue, ColorPalette.green],
          ),
        ),
        topBar: TopBar(title: 'Sign In', hasShadow: false),
        main: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/image/app_icon_no_padding.png', width: 256),
              Padding(padding: EdgeInsets.only(bottom: 100)),
              Text(
                'By sign in via a social network, your data will be backed up in the cloud and you will be able to sync them across your devices.',
                style: TextStyle(color: ColorPalette.white),
                textAlign: TextAlign.justify,
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              StreamBuilder(
                stream: _loginBloc.googleLoginStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return _SignInButton(
                    onPresssed: () async {
                      final status = await _loginBloc.loginViaGoogle();
                      if (status == LoginStatus.FINISH_LOGIN) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      }
                    },
                    iconAssetName: 'assets/image/google-logo.png',
                    text: 'Sign In with Google',
                  );
                },
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              StreamBuilder(
                stream: _loginBloc.facebookLoginStream,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return _SignInButton(
                    onPresssed: () async {
                      final status = await _loginBloc.loginViaFacebook();
                      if (status == LoginStatus.FINISH_LOGIN) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      }
                    },
                    iconAssetName: 'assets/image/facebook-logo.png',
                    text: 'Sign In with Facebook',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final Function() onPresssed;
  final String iconAssetName;
  final String text;

  _SignInButton({
    @required this.onPresssed,
    @required this.iconAssetName,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    return CustomRaisedButton(
      color: Colors.white,
      onPressed: this.onPresssed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(this.iconAssetName, height: 24),
          Padding(padding: EdgeInsets.only(right: 10)),
          Text(this.text, style: TextStyle(color: ColorPalette.blacklight)),
        ],
      ),
    );
  }
}

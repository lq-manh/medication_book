import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';

// login status
enum LoginStatus { START_LOGIN, FINISH_LOGIN, LOGIN_ERROR }

// login bloc
class LoginBloc {
  StreamController _facebookLoginStream = new StreamController();
  StreamController _googleLoginStream = new StreamController();

  Stream get facebookLoginStream => _facebookLoginStream.stream;
  Stream get googleLoginStream => _googleLoginStream.stream;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// login via Google
  void loginViaGoogle() async {
    _googleLoginStream.sink.add(LoginStatus.START_LOGIN);
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      Firestore.instance
          .collection('users')
          .document(user.email)
          .setData(json.decode(user.toString()));
    } catch (err) {
      _googleLoginStream.sink.add(LoginStatus.LOGIN_ERROR);
    }
  }

  /// login via Facebook
  void loginViaFacebook() async {
    _facebookLoginStream.sink.add(LoginStatus.START_LOGIN);
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );

        final FirebaseUser user =
            (await _auth.signInWithCredential(credential)).user;

        _facebookLoginStream.sink.add(LoginStatus.FINISH_LOGIN);
        break;
      default:
        _facebookLoginStream.sink.add(LoginStatus.LOGIN_ERROR);
        break;
    }
  }

  void dispose() {
    _facebookLoginStream.close();
    _googleLoginStream.close();
  }
}

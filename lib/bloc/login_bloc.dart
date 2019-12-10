import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medication_book/utils/secure_store.dart';

// login status
enum LoginStatus { START_LOGIN, FINISH_LOGIN, LOGIN_ERROR }

// login bloc
class LoginBloc {
  StreamController _facebookLoginStream = new StreamController();
  StreamController _googleLoginStream = new StreamController();

  Stream get facebookLoginStream => _facebookLoginStream.stream;
  Stream get googleLoginStream => _googleLoginStream.stream;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void dispose() {
    _facebookLoginStream.close();
    _googleLoginStream.close();
  }

  /// login via Google
  Future<LoginStatus> loginViaGoogle() async {
    _googleLoginStream.sink.add(LoginStatus.START_LOGIN);

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    try {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      this._createUserIfNotExists(user);

      await SecureStorage.instance.write(key: 'uid', value: user.uid);

      _googleLoginStream.sink.add(LoginStatus.FINISH_LOGIN);
      return LoginStatus.FINISH_LOGIN;
    } catch (err) {
      _googleLoginStream.sink.add(LoginStatus.LOGIN_ERROR);
      return LoginStatus.LOGIN_ERROR;
    }
  }

  /// login via Facebook
  Future<LoginStatus> loginViaFacebook() async {
    _facebookLoginStream.sink.add(LoginStatus.START_LOGIN);

    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      this._createUserIfNotExists(user);

      await SecureStorage.instance.write(key: 'uid', value: user.uid);

      _facebookLoginStream.sink.add(LoginStatus.FINISH_LOGIN);
      return LoginStatus.FINISH_LOGIN;
    }
    _facebookLoginStream.sink.add(LoginStatus.LOGIN_ERROR);
    return LoginStatus.LOGIN_ERROR;
  }

  void _createUserIfNotExists(FirebaseUser user) async {
    final CollectionReference users = Firestore.instance.collection('users');
    final QuerySnapshot result =
        await users.where('uid', isEqualTo: user.uid).getDocuments();
    if (result.documents.length > 0) return;

    users.add({
      "uid": user.uid,
      "avatar": user.photoUrl,
      "name": user.displayName,
    });
  }
}

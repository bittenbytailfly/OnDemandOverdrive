import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

enum AuthState { NotSignedIn, SigningIn, SignedIn }

//TODO: Handle timeouts and errors etc.
class FirebaseUserAuth extends ChangeNotifier {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  FirebaseUser _user;
  AuthState _state;

  FirebaseUser get user => _user;
  AuthState get state => _state;

  set state(AuthState state) {
    this._state = state;
    notifyListeners();
  }

  FirebaseUserAuth() : super(){
    _setCurrentUser();
  }

  void signIn() async {
    this.state = AuthState.SigningIn;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);

    var user = await _auth.currentUser();
    await _registerUser(user);

    _setCurrentUser();
  }

  Future<void> _registerUser(FirebaseUser user) async {
    var userToken = await user.getIdToken();
    var fcmToken = await _fcm.getToken();

    var tokenMap = new Map<String, dynamic>();
    tokenMap['userToken'] = userToken.token;
    tokenMap['fcmToken'] = fcmToken;

    final response = await http.post('https://www.1024design.co.uk/api/odod/register',
      body: tokenMap
    );

    if (response.statusCode != 201) {
      throw Exception();
    }
  }

  void signOut() async {
    this.state = AuthState.SigningIn;
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
    _setCurrentUser();
  }

  void _setCurrentUser() async {
    this.state = AuthState.SigningIn;
    var user = await _auth.currentUser();
    this._user = user;
    this.state = user == null ? AuthState.NotSignedIn : AuthState.SignedIn;
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthState { NotSignedIn, SigningIn, SignedIn }

//TODO: Handle timeouts and errors etc.
class FirebaseUserAuth extends ChangeNotifier {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void handleSignIn() async {
    this.state = AuthState.SigningIn;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser
        .authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _auth.signInWithCredential(credential);
    _setCurrentUser();
  }

  void handleSignOut() async {
    this.state = AuthState.SigningIn;
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
    _setCurrentUser();
  }

  void _setCurrentUser() async {
    var user = await _auth.currentUser();
    this._user = user;
    this.state = user == null ? AuthState.NotSignedIn : AuthState.SignedIn;
  }
}
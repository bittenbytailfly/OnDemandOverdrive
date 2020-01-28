import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseUserAuth extends ChangeNotifier {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  FirebaseUserAuth() : super(){
    _setCurrentUser();
  }

  Future handleSignIn() async {
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

  Future handleSignOut() async {
    final futures = await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
    _setCurrentUser();
  }

  Future<void> _setCurrentUser() async {
    var user = await _auth.currentUser();
    this._user = user;
    notifyListeners();
  }

  //todo: should be a prop
  FirebaseUser getCurrentUser() {
    return this._user;
  }
}
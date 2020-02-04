import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class FirebaseUserService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<FirebaseUser> getCurrentUser() async {
    final user = await _auth.currentUser();
    return user;
  }

  Future<FirebaseUser> signIn() async {
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

    return getCurrentUser();
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
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
}
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //Future<FirebaseUser> _user;

  /*@override
  void initState() {
    super.initState();
    //this._user = _getCurrentUser();
  }*/

  @override
  Widget build(BuildContext context) {
    return Container();
    /*return FutureBuilder(
      future: _user,
        builder: (context, snapshot){
          return Drawer(
            child: Column(
              children: [
                snapshot.hasData ? _buildUserDrawerHeader(snapshot.data) : _buildEmptyDrawerHeader(),
                ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Notificatons'),
                ),
                _buildMenu(snapshot),
              ],
            ),
          );
      }
    );*/
  }

  /*Widget _buildMenu(AsyncSnapshot<FirebaseUser> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData){
      return ListTile(
        title: Text("Sign In"),
        leading: Icon(Icons.person),
        onTap: _handleSignIn,
      );
    }
    else if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
      return ListTile(
        title: Text("Sign Out"),
        leading: Icon(Icons.exit_to_app),
        onTap: _handleSignOut,
      );
    }
    else {
      return Container();
    }
  }

  Widget _buildUserDrawerHeader(FirebaseUser user) {
    return UserAccountsDrawerHeader(
      currentAccountPicture: Container(
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
          )
      ),
      accountName: Container(
        child: Text(user.displayName),
      ),
    );
  }

  Widget _buildEmptyDrawerHeader() {
    return UserAccountsDrawerHeader(
      currentAccountPicture: Container(
          child: CircleAvatar(
            child: ClipOval(
              child: Center(
                child: Icon(
                  Icons.person,
                  size: 100.0,
                ),
              ),
            ),
          )
      ),
      accountName: Container(
        child: Text('Not signed in'),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    setState(() {
      this._user = _getCurrentUser();
    });
  }

  Future _handleSignOut() async {
    final futures = await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut()
    ]);
    setState(() {
      this._user = _getCurrentUser();
    });
  }

  Future<FirebaseUser> _getCurrentUser() {
    return _auth.currentUser();
  }*/
}


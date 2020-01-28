import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FirebaseUserAuth.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  MenuDrawer({Key key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUserAuth>(
      builder: (context, auth, child) {
        return Drawer(
          child: Column(
            children: [
              auth.getCurrentUser() != null ? _buildUserDrawerHeader(auth.getCurrentUser()) : _buildEmptyDrawerHeader(),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notificatons'),
              ),
              _buildMenu(auth.getCurrentUser()),
            ],
          ),
        );
      }
    );
  }

  Widget _buildMenu(FirebaseUser snapshot) {
    if (snapshot == null){
      return ListTile(
        title: Text("Sign In"),
        leading: Icon(Icons.person),
        onTap: Provider.of<FirebaseUserAuth>(context, listen: false).handleSignIn,
      );
    }
    else {
      return ListTile(
        title: Text("Sign Out"),
        leading: Icon(Icons.exit_to_app),
        onTap: Provider.of<FirebaseUserAuth>(context, listen: false).handleSignOut,
      );
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
}


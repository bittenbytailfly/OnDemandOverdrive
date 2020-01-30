import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FirebaseUserAuth.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUserAuth>(
      builder: (context, auth, child) {
        return Drawer(
          child: Column(
            children: [
              MenuDrawerHeader(),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notificatons'),
              ),
              SignInButton(),
            ],
          ),
        );
      }
    );
  }
}

class MenuDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUserAuth>(
      builder: (context, userAuth, child) {

        final avatarWidget = userAuth.state == AuthState.SignedIn
          ? CircleAvatar(
              backgroundImage: NetworkImage(userAuth.user.photoUrl),
            )
          : CircleAvatar(
              child: ClipOval(
                  child: Icon(Icons.person, size: 50.0,)),
            );

        return UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
              image: AssetImage('assets/images/drawer-bg.png'),
              fit: BoxFit.cover,
            )
          ),
          currentAccountPicture: Container(
              child: avatarWidget
          ),
          accountName: Container(
            child: Text(userAuth.state == AuthState.SignedIn ? userAuth.user.displayName : 'Not Signed In'),
          ),
        );
      }
    );
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUserAuth>(
      builder: (context, userAuth, child) {
        Widget title;
        Widget leading;
        GestureTapCallback tapEvent;

        switch (userAuth.state){
          case AuthState.NotSignedIn:
            title = Text('Sign In');
            leading = Icon(
              Icons.person,
            );
            tapEvent = userAuth.handleSignIn;
            break;
          case AuthState.SigningIn:
            title = Text(
              'Signing In',
              style: TextStyle(color: Colors.grey),
            );
            leading = Icon(
              Icons.schedule,
              color: Colors.grey,
            );
            break;
          case AuthState.SignedIn:
            title = Text('Sign Out');
            leading = Icon(
              Icons.exit_to_app,
            );
            tapEvent = userAuth.handleSignOut;
            break;
            break;
        }

        return ListTile(
          title: title,
          leading: leading,
          onTap: tapEvent,
        );
      },
    );
  }
}

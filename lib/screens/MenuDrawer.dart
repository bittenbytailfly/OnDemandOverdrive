import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FirebaseUserAuth.dart';
import 'package:ondemand_overdrive/screens/SubscriptionScreen.dart';
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
                title: Text('Subscriptions'),
                onTap: () {
                  Navigator.pop(context);
                  _pushSubscriptionScreen(context);
                },
              ),
              SignInButton(),
            ],
          ),
        );
      }
    );
  }

  void _pushSubscriptionScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return SubscriptionScreen();
        },
      ),
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
            tapEvent = userAuth.signIn;
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
            tapEvent = userAuth.signOut;
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

import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/screens/NotificationsScreen.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  void _pushSubscriptionScreen(context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return NotificationsScreen();
        },
      ),
    );
  }
}

class MenuDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, account, child) {

        final avatarWidget = account.authState == AuthState.SignedIn
          ? CircleAvatar(
              backgroundImage: NetworkImage(account.user.photoUrl),
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
            child: Text(account.authState == AuthState.SignedIn ? account.user.displayName : 'Not Signed In'),
          ),
        );
      }
    );
  }
}

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, account, child) {
        Widget title;
        Widget leading;
        GestureTapCallback tapEvent;

        switch (account.authState){
          case AuthState.NotSignedIn:
            title = Text('Sign In');
            leading = Icon(
              Icons.person,
            );
            tapEvent = account.signIn;
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
            tapEvent = account.signOut;
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

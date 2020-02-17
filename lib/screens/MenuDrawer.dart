import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/screens/SubscriberListingsScreen.dart';
import 'package:ondemand_overdrive/screens/SubscriptionsScreen.dart';
import 'package:ondemand_overdrive/services/NavigationService.dart';
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
          ListTile(
            leading: Icon(Icons.star),
            title: Text('My Listings'),
            subtitle: Text('Based on subscriptions'),
            onTap: () {
              Navigator.pop(context);
              _pushSubscriberListingsScreen(context);
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
          return SubscriptionsScreen();
        },
      ),
    );
  }

  void _pushSubscriberListingsScreen(context) {
    NavigationService().navigateToSubscriberListings();
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
          case AuthState.Error:
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Something went wrong, please try again later'),
                  ),
              );
              account.authState = AuthState.NotSignedIn;
            });
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

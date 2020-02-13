import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:provider/provider.dart';

class SubscriptionServicesSignIn extends StatelessWidget {
  final Function() onSignedIn;
  final Widget signedInWidget;

  SubscriptionServicesSignIn({ Key key, this.signedInWidget, this.onSignedIn }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, account, child) {
        switch (account.authState) {
          case AuthState.NotSignedIn:
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Sign in to subscribe to notifications when a listing is added from a director/actor you follow.',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      child: Text('Sign In'),
                      onPressed: () {
                        account.signIn();
                        this.onSignedIn();
                      },
                    ),
                  )
                ],
              ),
            );
          case AuthState.SigningIn:
            return Center(
              child: CircularProgressIndicator(),
            );
          case AuthState.SignedIn:
            return signedInWidget;
          case AuthState.Error:
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text('Something went wrong - please try again later'),
              ));
            Navigator.pop(context);
            return null;
          default:
            throw new Exception('Argument out of range');
        }
      },
    );
  }
}


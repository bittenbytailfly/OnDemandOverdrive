import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FirebaseUserAuth.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUserAuth>(builder: (context, auth, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Subscriptions'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_alert),
          onPressed: null,
        ),
        body: _buildSubscriptionBody(auth),
      );
    });
  }

  Widget _buildSubscriptionBody(FirebaseUserAuth auth) {
    switch (auth.state) {
      case AuthState.NotSignedIn:
        return Center(
          child: Text('You must be signed in to use this feature.'),
        );
      case AuthState.SigningIn:
        return Center(
          child: CircularProgressIndicator(),
        );
        break;
      case AuthState.SignedIn:
        return _buildSubscriptionList(auth.user);
        break;
    }
    throw new Exception('Argument out of range');
  }

  Widget _buildSubscriptionList(FirebaseUser user) {
    return Consumer<SubscriptionService>(builder: (context, sub, child) {
      return FutureBuilder(
        future: sub.getSubscriptions(user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length == 0){
              return Center(
                child: Text('You don\'t currently have any subscriptions.')
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: Text('Test'),
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      );
    });
  }


}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/SubscriptionType.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:provider/provider.dart';
import 'NewNotificationScreen.dart';
import 'package:ondemand_overdrive/models/Subscription.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            child: Icon(Icons.add_alert),
            onPressed: () => _pushAddNotificationPage(context),
          );
        },
      ),
      body: _buildSubscriptionBody(),
    );
  }

  Widget _buildSubscriptionBody() {
    return Consumer<AccountProvider>(
      builder: (context, account, child){
        switch (account.authState) {
          case AuthState.NotSignedIn:
            return Center(
              child: Text('You must be signed in to use this feature.'),
            );
          case AuthState.SigningIn:
            return Center(
              child: CircularProgressIndicator(),
            );
          case AuthState.SignedIn:
            return SubscriptionList();
          default:
            throw new Exception('Argument out of range');
        }
      },
    );
  }

  void _pushAddNotificationPage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewNotificationScreen())).then((result) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Added $result'),
        ));
    });
  }
}

class SubscriptionList extends StatefulWidget {
  @override
  _SubscriptionListState createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  @override
  Widget build(BuildContext context) {

    return Consumer<AccountProvider>(
      builder: (context, account, child){
        if (account.subscriptionState == SubscriptionState.Retrieved) {
          if (account.subscriptions.length == 0) {
            return Center(child: Text('You don\'t currently have any subscriptions.'));
          }
          return ListView.builder(
              itemCount: account.subscriptions.length,
              itemBuilder: (context, index) {
                Subscription sub = account.subscriptions[index];
                return SubscriptionListTile(
                  subscription: sub,
                );
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class SubscriptionListTile extends StatefulWidget {
  final Subscription subscription;

  SubscriptionListTile({this.subscription});

  @override
  _SubscriptionListTileState createState() => _SubscriptionListTileState();
}

class _SubscriptionListTileState extends State<SubscriptionListTile> {
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionType type = SubscriptionService.getTypeById(widget.subscription.subscriptionTypeId);

    return new ListTile(
      leading: Icon(type.icon),
      title: Text(widget.subscription.value),
      subtitle: Text(type.name),
      trailing: this._deleting ? _buildDeletingIndicator() : _buildDeleteButton(),
    );
  }

  Widget _buildDeletingIndicator() {
    return Container(
      height: 20.0,
      width: 20.0,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildDeleteButton() {
    return Consumer<AccountProvider>(
      builder: (context, account, child) {
        return GestureDetector(
          child: Icon(
            Icons.delete,
            color: Colors.teal,
          ),
          onTap: () {
            setState(() {
              this._deleting = true;
            });
            account.deleteSubscription(widget.subscription.subscriptionId).then((_) {
              setState(() {
                this._deleting = false;
                final subName = widget.subscription.value;
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text('Deleted $subName'),
                  ));
              });
            });
          },
        );
      }
    );
  }
}

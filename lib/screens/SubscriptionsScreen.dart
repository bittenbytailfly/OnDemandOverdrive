import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/SubscriptionType.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/services/NavigationService.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:ondemand_overdrive/widgets/NoConnectionNotification.dart';
import 'package:provider/provider.dart';
import 'NewSubscriptionScreen.dart';
import 'package:ondemand_overdrive/models/Subscription.dart';

class SubscriptionsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return Consumer<AccountProvider>(
            builder: (context, account, child) {
              return account.authState == AuthState.SignedIn
                  ? FloatingActionButton(
                      child: Icon(Icons.add_alert),
                      onPressed: () => _pushAddNotificationPage(context),
                    )
                  : Container();
            },
          );
        },
      ),
      body: _buildSubscriptionBody(),
    );
  }

  Widget _buildSubscriptionBody() {
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
                    'Sign in to subscribe to notifications when a title is added from a director/actor you follow.',
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: RaisedButton(
                      child: Text('Sign In'),
                      onPressed: account.signIn,
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
            return SubscriptionList();
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

  void _pushAddNotificationPage(context) {
    NavigationService().navigateToNewSubscriptionScreen().then((result) {
      if (result != null && result.length > 0) {
        Scaffold.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text('Added $result'),
        ));
      }
    });
  }
}

class SubscriptionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, account, child) {
        switch (account.subscriptionState){
          case SubscriptionState.Fetching:
            return Center(
              child: CircularProgressIndicator(),
            );
          case SubscriptionState.Retrieved:
            if (account.subscriptions.length == 0) {
              return Center(child: Text('You don\'t currently have any subscriptions.'));
            }
            return ListView.builder(
              padding: EdgeInsets.only(bottom: 100.0),
              itemCount: account.subscriptions.length,
              itemBuilder: (context, index) {
                Subscription sub = account.subscriptions[index];
                return SubscriptionListTile(
                  subscription: sub,
                  onDeleted: (bool success) {
                    _subscriptionDeleted(context, success, sub);
                  },
                );
              });
          case SubscriptionState.Error:
            return NoConnectionNotification(
              onRefresh: account.getSubscriptions,
            );
          default:
            throw new Exception('Argument out of range');
        }
      },
    );
  }

  void _subscriptionDeleted(BuildContext context, bool success, Subscription sub) {
    if (!success) {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Something went wrong - please try again later'),
        )
        );
    }
    else {
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text('Deleted ' + sub.value),
        )
        );
    }
  }
}

class SubscriptionListTile extends StatefulWidget {
  final Subscription subscription;
  final void Function(bool success) onDeleted;

  SubscriptionListTile({this.subscription, this.onDeleted});

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
    return Consumer<AccountProvider>(builder: (context, account, child) {
      return GestureDetector(
        child: Icon(
          Icons.delete,
          color: Colors.teal,
        ),
        onTap: () {
          this.setState(() {
            this._deleting = true;
          });
          account.deleteSubscription(widget.subscription).then((successfullyDeleted) {
            widget.onDeleted(successfullyDeleted);
            setState(() {
              this._deleting = false;
            });
          });
        },
      );
    });
  }
}

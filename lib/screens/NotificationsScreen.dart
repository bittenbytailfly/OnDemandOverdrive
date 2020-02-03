import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FirebaseUserAuth.dart';
import 'package:ondemand_overdrive/models/SubscriptionType.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:provider/provider.dart';
import 'NewNotificationScreen.dart';
import 'package:ondemand_overdrive/models/Subscription.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FirebaseUserAuth>(builder: (context, auth, child) {
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
        return SubscriptionList(
            user: auth.user,
        );
        break;
    }
    throw new Exception('Argument out of range');
  }

  void _pushAddNotificationPage(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewNotificationScreen())).then((result) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(result),
        ));
    });
  }
}

class SubscriptionList extends StatefulWidget {
  final FirebaseUser user;

  SubscriptionList({this.user});

  @override
  _SubscriptionListState createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  List<Subscription> _subscriptions;
  bool _loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadSubscriptions();
  }

  void _loadSubscriptions() {
    setState(() {
      this._loading = true;
    });

    SubscriptionService.getSubscriptions(widget.user).then((result) {
      setState(() {
        _subscriptions = result;
        this._loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!this._loading) {
      if (this._subscriptions.length == 0) {
        return Center(child: Text('You don\'t currently have any subscriptions.'));
      }
      return ListView.builder(
          itemCount: this._subscriptions.length,
          itemBuilder: (context, index) {
            Subscription sub = this._subscriptions[index];
            return SubscriptionListTile(
              subscription: sub,
              user: widget.user,
              onDeleted: (subscription) => _subscriptionDeleted(subscription),
            );
          });
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _subscriptionDeleted(subscription) {
    this._loadSubscriptions();
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Removed ' + subscription.value),
      ));
  }
}

class SubscriptionListTile extends StatefulWidget {
  final Subscription subscription;
  final FirebaseUser user;
  final void Function(Subscription subscription) onDeleted;

  SubscriptionListTile({this.subscription, this.user, this.onDeleted});

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
    return GestureDetector(
      child: Icon(
        Icons.delete,
        color: Colors.teal,
      ),
      onTap: () => _deleteSubscription(context, widget.user, widget.subscription),
    );
  }

  void _deleteSubscription(BuildContext context, FirebaseUser user, Subscription sub) {
    setState(() {
      this._deleting = true;
    });
    SubscriptionService.deleteSubscription(user, sub.subscriptionId).then((result) {
      setState(() {
        this._deleting = false;
      });
      widget.onDeleted(sub);
    });
  }
}

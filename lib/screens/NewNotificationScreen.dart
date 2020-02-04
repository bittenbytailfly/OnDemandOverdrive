import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/SubscriptionType.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:provider/provider.dart';

class NewNotificationScreen extends StatefulWidget {
  @override
  _NewNotificationScreenState createState() => _NewNotificationScreenState();
}

class _NewNotificationScreenState extends State<NewNotificationScreen> {
  bool _adding = false;
  String _notificationValue;
  List<SubscriptionType> _subscriptionTypes;
  SubscriptionType _selectedSubscriptionType;

  @override
  void initState() {
    super.initState();
    this._subscriptionTypes = SubscriptionService.getAllTypes();
    this._selectedSubscriptionType = this._subscriptionTypes[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Notification'),
      ),
      body: _buildAdditionForm()
    );
  }

  Widget _buildAdditionForm(){
    return Container(
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          DropdownButtonFormField<SubscriptionType>(
            decoration: InputDecoration(
              labelText: 'Notification Type',
            ),
            value: _selectedSubscriptionType,
            items: this._subscriptionTypes.map((SubscriptionType subType) {
              return new DropdownMenuItem<SubscriptionType>(
                value: subType,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(subType.icon,
                        color: Colors.teal,
                      ),
                    ),
                    Text(subType.name),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubscriptionType = value;
              });
            },
          ),
          TextField(
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              setState(() {
                this._notificationValue = value;
              });
            },
            decoration: InputDecoration(
              labelText: this._selectedSubscriptionType.label,
              hintText: this._selectedSubscriptionType.example,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Consumer<AccountProvider>(
                builder: (consumer, account, child){
                  return RaisedButton(
                    child: Text(this._adding ? 'Adding ...' : 'Add'),
                    onPressed: this._adding ? null :  () {
                      setState(() {
                        _adding = true;
                      });
                      account.registerSubscription(this._selectedSubscriptionType.id, this._notificationValue);
                      Navigator.pop(context, this._notificationValue);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

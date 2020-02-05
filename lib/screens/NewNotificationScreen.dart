import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  List<SubscriptionType> _subscriptionTypes;
  SubscriptionType _selectedSubscriptionType;
  TextEditingController _subscriptionValueController = new TextEditingController();

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
          TypeAheadFormField(
            textFieldConfiguration: TextFieldConfiguration(
              controller: this._subscriptionValueController,
              decoration: InputDecoration(
                labelText: this._selectedSubscriptionType.label,
                hintText: this._selectedSubscriptionType.example,
              ),
              textCapitalization: TextCapitalization.words,
            ),
            hideOnEmpty: true,
            hideOnLoading: true,
            hideOnError: true,
            suggestionsCallback: (term) {
              if (term != null && term.length <= 2) {
                return null;
              }
              return this._selectedSubscriptionType.id == 1
                ? SubscriptionService.getActors(term)
                : SubscriptionService.getDirectors(term);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            onSuggestionSelected: (suggestion) {
              this._subscriptionValueController.text = suggestion;
            },
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
                      account.registerSubscription(this._selectedSubscriptionType.id, this._subscriptionValueController.text);
                      Navigator.pop(context, this._subscriptionValueController.text);
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

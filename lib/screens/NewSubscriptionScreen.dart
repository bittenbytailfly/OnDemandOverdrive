import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ondemand_overdrive/models/SubscriptionType.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:provider/provider.dart';

class NewSubscriptionScreen extends StatefulWidget {
  @override
  _NewSubscriptionScreenState createState() => _NewSubscriptionScreenState();
}

class _NewSubscriptionScreenState extends State<NewSubscriptionScreen> {
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
        title: Text('New Subscription'),
      ),
      body: _buildAdditionForm()
    );
  }

  Widget _buildAdditionForm(){
    final _formKey = GlobalKey<FormState>();

    return Builder(
      builder: (context) {
        return Form(
          key: _formKey,
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
                hideOnEmpty: false,
                hideOnLoading: true,
                hideOnError: true,
                noItemsFoundBuilder: (context) => ListTile(
                    title: Text('No matching names found in the database, but you can still add a subscription for future occurrences')
                ),
                suggestionsCallback: (term) {
                  if (term != null && term.length <= 2) {
                    return null;
                  }
                  switch (this._selectedSubscriptionType.id){
                    case SubscriptionType.ACTOR:
                      return SubscriptionService.getActors(term);
                    case SubscriptionType.DIRECTOR:
                      return SubscriptionService.getDirectors(term);
                    default:
                      return SubscriptionService.getTitle(term);
                  }
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
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
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
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _adding = true;
                            });
                            account.registerSubscription(this._selectedSubscriptionType.id, this._subscriptionValueController.text).then((successfullyAdded) {
                              if (successfullyAdded) {
                                Navigator.pop(context, this._subscriptionValueController.text);
                              }
                              else {
                                Scaffold.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(SnackBar(
                                    content: Text('Something went wrong - please try again later.'),
                                  ));
                              }
                            }).whenComplete(() {
                              setState(() {
                                _adding = false;
                              });
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );


  }
}

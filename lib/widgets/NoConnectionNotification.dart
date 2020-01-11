import 'package:flutter/material.dart';

class NoConnectionNotification extends StatelessWidget{
  final VoidCallback onRefresh;

  NoConnectionNotification({Key key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Unable to load data'),
          RaisedButton(
            onPressed: () => onRefresh(),
            child: Text('Retry'),
          )
        ],
      ),
    );
  }
}
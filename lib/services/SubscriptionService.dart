import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

//TODO: Error handling
class SubscriptionService with ChangeNotifier {
  Future getSubscriptions(FirebaseUser user) async {
    var userToken = await user.getIdToken();
    final response = await http.get('https://www.1024design.co.uk/api/odod/subscriptions?userToken=' + userToken.token);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception();
    }
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:ondemand_overdrive/models/SubscriptionType.dart';
import 'package:ondemand_overdrive/models/Subscription.dart';

//TODO: Error handling
class SubscriptionService {

  Future<List<Subscription>> getSubscriptions(FirebaseUser user) async {
    var userToken = await user.getIdToken();
    var plainTextToken = userToken.token;
    final response = await http.get('https://www.1024design.co.uk/api/odod/subscriptions',
        headers: {HttpHeaders.authorizationHeader: "Bearer $plainTextToken"});

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body).map<Subscription>((json) => Subscription.fromJson(json)).toList();
      return data;
    } else {
      throw Exception();
    }
  }

  Future<void> registerNewSubscription(FirebaseUser user, int subscriptionTypeId, String subscriptionValue) async {
    var userToken = await user.getIdToken();
    var plainTextToken = userToken.token;
    var subscriptionMap = new Map<String, dynamic>();
    subscriptionMap['subscriptionType'] = subscriptionTypeId.toString();
    subscriptionMap['value'] = subscriptionValue;
    final response = await http.post('https://www.1024design.co.uk/api/odod/subscrijptions',
        headers: {HttpHeaders.authorizationHeader: "Bearer $plainTextToken"},
        body: subscriptionMap);

    if (response.statusCode != 201) {
      throw Exception();
    }
  }

  Future<void> deleteSubscription(FirebaseUser user, String subscriptionId) async {
    var userToken = await user.getIdToken();
    var plainTextToken = userToken.token;
    final response = await http.delete('https://www.1024design.co.uk/api/odod/subscriptions?id=' + subscriptionId,
      headers: {HttpHeaders.authorizationHeader: "Bearer $plainTextToken"});

    if (response.statusCode != 200) {
      throw Exception();
    }
  }

  static Future<List<String>> getActors(String term) async {
    final response = await http.get('https://www.1024design.co.uk/api/odod/actors?term=$term');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception();
    }
  }

  static Future<List<String>> getDirectors(String term) async {
    final response = await http.get('https://www.1024design.co.uk/api/odod/directors?term=$term');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception();
    }
  }

  static SubscriptionType getTypeById(int id){
    switch (id){
      case 1:
        return SubscriptionType.actor();
      case 2:
        return SubscriptionType.director();
      case 3:
        return SubscriptionType.title();
      default:
        throw new Exception('Invalid SubscriptionTypeId');
    }
  }

  static List<SubscriptionType> getAllTypes(){
    return <SubscriptionType>[
      SubscriptionType.actor(),
      SubscriptionType.director(),
      //SubscriptionType.title(),
    ];
  }
}
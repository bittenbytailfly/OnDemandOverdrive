import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:provider/provider.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  static const String SUBSCRIBER_LISTINGS = 'SubscriberListings';

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  factory NavigationService() {
    return _instance;
  }

  Future<dynamic> navigateToSubscriberListings() {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(SUBSCRIBER_LISTINGS, ModalRoute.withName('/'));
  }

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, ModalRoute.withName('/'));
  }



  NavigationService._internal();
}
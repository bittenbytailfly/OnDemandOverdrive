import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  static const String SUBSCRIBER_LISTINGS = 'SubscriberListings';
  static const String LISTINGS = '/';

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  factory NavigationService() {
    return _instance;
  }

  Future<dynamic> navigateToSubscriberListings() {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(SUBSCRIBER_LISTINGS, ModalRoute.withName(LISTINGS));
  }

   NavigationService._internal();
}
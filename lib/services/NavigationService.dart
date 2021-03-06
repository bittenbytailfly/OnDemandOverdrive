import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:provider/provider.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  static const String SUBSCRIBER_LISTINGS = 'SubscriberListings';
  static const String SUBSCRIPTIONS = 'Subscriptions';
  static const String NEW_SUBSCRIPTION_SCREEN = 'NewSubscriptionScreen';
  static const String LISTINGS = '/';
  static const String LISTING_DETAIL = 'ListingDetail';

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  factory NavigationService() {
    return _instance;
  }

  Future<dynamic> navigateToListingDetailScreen(BigInt id) {
    return navigatorKey.currentState.pushNamed(LISTING_DETAIL, arguments: { 'id': id });
  }

  Future<dynamic> navigateToNewSubscriptionScreen() {
    return navigatorKey.currentState.pushNamed(NEW_SUBSCRIPTION_SCREEN);
  }

  Future<dynamic> navigateToSubscriptionsScreen() {
    final accountProvider = Provider.of<AccountProvider>(navigatorKey.currentContext, listen: false);
    if (accountProvider.user != null) {
      accountProvider.getSubscriptions();
    }
    return navigatorKey.currentState.pushNamed(SUBSCRIPTIONS);
  }

  Future<dynamic> navigateToSubscriberListingsScreen() {
    final accountProvider = Provider.of<AccountProvider>(navigatorKey.currentContext, listen: false);
    accountProvider.subscriberListingsState = SubscriberListingsState.Initialized;
    return navigatorKey.currentState.pushNamedAndRemoveUntil(SUBSCRIBER_LISTINGS, ModalRoute.withName(LISTINGS));
  }

   NavigationService._internal();
}
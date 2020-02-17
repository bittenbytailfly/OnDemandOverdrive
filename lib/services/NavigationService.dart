import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _singleton = NavigationService._internal();
  String _lastNamedRoute = '';

  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  factory NavigationService() {
    return _singleton;
  }

  Future<dynamic> navigateTo(String routeName) {
    //TODO: figure out how not to push twice.
    return navigatorKey.currentState.pushNamed(routeName).then((_) => _lastNamedRoute = routeName);
  }

  NavigationService._internal();
}
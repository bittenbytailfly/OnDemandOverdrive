import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/Subscription.dart';
import 'package:ondemand_overdrive/services/FirebaseUserService.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';

enum AuthState { NotSignedIn, SigningIn, SignedIn, Error }
enum SubscriptionState { Fetching, Retrieved, Error }

class AccountProvider extends ChangeNotifier {
  final FirebaseUserService _firebaseUserService = new FirebaseUserService();
  final SubscriptionService _subscriptionService = new SubscriptionService();

  FirebaseUser _user;
  FirebaseUser get user => _user;
  set user(FirebaseUser user) {
    this._user = user;
    if (user != null) {
      this.getSubscriptions();
    }
    this.authState = user != null
        ? AuthState.SignedIn
        : AuthState.NotSignedIn;
  }

  AuthState _authState;
  AuthState get authState => _authState;
  set authState(AuthState state) {
    this._authState = state;
    notifyListeners();
  }

  SubscriptionState _subscriptionState = SubscriptionState.Fetching;
  SubscriptionState get subscriptionState => _subscriptionState;
  set subscriptionState(SubscriptionState state) {
    this._subscriptionState = state;
    notifyListeners();
  }

  List<Subscription> _subscriptions;
  List<Subscription> get subscriptions => _subscriptions;

  AccountProvider() {
    this._firebaseUserService.getCurrentUser().then((user){
      this.user = user;
    });
  }

  void signIn() {
    this.authState = AuthState.SigningIn;
    this._firebaseUserService.signIn().then((user) {
      this.user = user;
    }).timeout(const Duration(seconds: 10), onTimeout: _handleSignInTimeout)
    .catchError(_handleSignInError);
  }

  void signOut() {
    this.authState = AuthState.SigningIn;
    this._firebaseUserService.signOut().then((_) {
      this.user = null;
    });
  }

  void getSubscriptions() {
    this.subscriptionState = SubscriptionState.Fetching;
    var user = this.user;
    this._subscriptionService.getSubscriptions(user).then((subscriptions){
      this._subscriptions = subscriptions;
      this.subscriptionState = SubscriptionState.Retrieved;
    }).timeout(const Duration(seconds: 10), onTimeout: _handleSubscriptionTimeout)
    .catchError(_handleSubscriptionError)
    ;
  }

  void registerSubscription(int subscriptionTypeId, String value) {
    this.subscriptionState = SubscriptionState.Fetching;
    this._subscriptionService.registerNewSubscription(this.user, subscriptionTypeId, value).then((_) {
      this.getSubscriptions();
    });
  }

  Future<void> deleteSubscription(String id) async {
    this._subscriptionService.deleteSubscription(this.user, id).then((_){
      final updatedSubs = List<Subscription>.from(this._subscriptions);
      updatedSubs.removeWhere((sub) => sub.subscriptionId == id);
      this._subscriptions = updatedSubs;
      notifyListeners();
    });
  }

  FutureOr<Null> _handleSubscriptionError(Object error) async {
    this.subscriptionState = SubscriptionState.Error;
    throw new Exception();
  }

  FutureOr<Null> _handleSubscriptionTimeout() {
    this.subscriptionState = SubscriptionState.Error;
    throw new Exception('Subscription timeout');
  }

  FutureOr<Null> _handleSignInError(Object error) async {
    this.authState = AuthState.Error;
    throw new Exception();
  }

  FutureOr<Null> _handleSignInTimeout() {
    this.authState = AuthState.Error;
    throw new Exception('Subscription timeout');
  }
}
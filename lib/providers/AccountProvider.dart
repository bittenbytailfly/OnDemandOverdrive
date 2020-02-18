import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/SubscriberListing.dart';
import 'package:ondemand_overdrive/models/Subscription.dart';
import 'package:ondemand_overdrive/services/FirebaseUserService.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';

enum AuthState { NotSignedIn, SigningIn, SignedIn, Error }
enum SubscriptionState { Fetching, Retrieved, Error }
enum SubscriberListingsState { Fetching, Retrieved, Error }

class AccountProvider extends ChangeNotifier {
  final FirebaseUserService _firebaseUserService = new FirebaseUserService();
  final SubscriptionService _subscriptionService = new SubscriptionService();

  FirebaseUser _user;
  FirebaseUser get user => _user;
  set user(FirebaseUser user) {
    this._user = user;
    this.authState = user != null
        ? AuthState.SignedIn
        : AuthState.NotSignedIn;
  }

  AuthState _authState = AuthState.SigningIn;
  AuthState get authState => _authState;
  set authState(AuthState state) {
    if (this._authState != state) {
      this._authState = state;
      notifyListeners();
    }
  }

  SubscriptionState _subscriptionState = SubscriptionState.Fetching;
  SubscriptionState get subscriptionState => _subscriptionState;
  set subscriptionState(SubscriptionState state) {
    if (this._subscriptionState != state) {
      this._subscriptionState = state;
      notifyListeners();
    }
  }

  SubscriberListingsState _subscriberListingsState = SubscriberListingsState.Fetching;
  SubscriberListingsState get subscriberListingsState => _subscriberListingsState;
  set subscriberListingsState(SubscriberListingsState state) {
    if (this._subscriberListingsState != state) {
      this._subscriberListingsState = state;
      notifyListeners();
    }
  }

  List<Subscription> _subscriptions;
  List<Subscription> get subscriptions => _subscriptions;

  List<SubscriberListing> _subscriberListings;
  List<SubscriberListing> get subscriberListings => _subscriberListings;

  AccountProvider() {
    this._firebaseUserService.getCurrentUser().then((user){
      this.user = user;
    });
  }

  Future<FirebaseUser> signIn() async {
    this.authState = AuthState.SigningIn;
    this.user = await this._firebaseUserService.signIn()
        .timeout(const Duration(seconds: 10), onTimeout: _handleSignInTimeout)
        .catchError(_handleSignInError);
    return user;
  }

  void signOut() {
    this.authState = AuthState.SigningIn;
    this._firebaseUserService.signOut(user).then((_) {
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
    .catchError(_handleSubscriptionError);
  }

  void getSubscriberListings() {
    if (this.user == null){
      return;
    }

    this.subscriberListingsState = SubscriberListingsState.Fetching;
    var user = this.user;

    this._subscriptionService.getSubscriberListings(user).then((listings) {
      this._subscriberListings = listings;
      this.subscriberListingsState = SubscriberListingsState.Retrieved;
    }).timeout(const Duration(seconds: 10), onTimeout: () => _handleSubscriberListingsError(null))
    .catchError(_handleSubscriberListingsError);
  }

  Future<bool> registerSubscription(int subscriptionTypeId, String value) async {
    this.subscriptionState = SubscriptionState.Fetching;
    try {
      await this._subscriptionService.registerNewSubscription(this.user, subscriptionTypeId, value);
      this.getSubscriptions();
      return true;
    }
    catch (_) {
      return false;
    }
  }

  Future<bool> deleteSubscription(Subscription sub) async {
    try {
      await this._subscriptionService.deleteSubscription(this.user, sub.subscriptionId);
      final updatedSubs = List<Subscription>.from(this._subscriptions);
      updatedSubs.removeWhere((d) => d.subscriptionId == sub.subscriptionId);
      this._subscriptions = updatedSubs;
      notifyListeners();
      return true;
    }
    catch (_) {
      return false;
    }
  }

  FutureOr<Null> _handleSubscriptionError(Object error) async {
    this.subscriptionState = SubscriptionState.Error;
    throw new Exception();
  }

  FutureOr<Null> _handleSubscriptionTimeout() {
    this.subscriptionState = SubscriptionState.Error;
    throw new Exception('Subscription timeout');
  }

  FutureOr<Null> _handleSubscriberListingsError(Object error) async {
    this.subscriberListingsState = SubscriberListingsState.Error;
    throw new Exception();
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
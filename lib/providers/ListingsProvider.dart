import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FilterList.dart';
import 'package:ondemand_overdrive/models/Listing.dart';
import 'package:ondemand_overdrive/services/ListingsService.dart';

enum ListingsState { Fetching, Retrieved, NetworkError, UnspecifiedError }

class ListingsProvider extends ChangeNotifier {
  final _listingsService = new ListingsService();

  List<Listing> listings;
  final FilterList listingTypeFilter = new FilterList(['movie', 'series']);
  FilterList genreFilter;

  ListingsState _state = ListingsState.Fetching;
  ListingsState get state => _state;
  set state(ListingsState state){
    this._state = state;
    this.notifyListeners();
  }

  void getListings() {
    this.state = ListingsState.Fetching;
    this._listingsService.getListings().then((result) {
      this.listings = result;
      if (genreFilter == null) {
        this._listingsService.getGenres().then((result){
          this.genreFilter = new FilterList(result);
        })
        .timeout(const Duration(seconds:10), onTimeout: _handleTimeoutException)
        .catchError(_handleUnspecifiedError);
      }
      this.state = ListingsState.Retrieved;
    }).timeout(const Duration(seconds: 10), onTimeout: _handleTimeoutException
    ).catchError(_handleUnspecifiedError);
  }

  void _handleTimeoutException() {
    this.state = ListingsState.NetworkError;
    throw new Exception();
  }

  void _handleUnspecifiedError() {
    this.state = ListingsState.UnspecifiedError;
    throw new Exception();
  }
}
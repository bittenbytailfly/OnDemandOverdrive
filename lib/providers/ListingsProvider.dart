import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FilterList.dart';
import 'package:ondemand_overdrive/models/Listing.dart';
import 'package:ondemand_overdrive/services/ListingsService.dart';

enum ListingsState { Fetching, Retrieved, NetworkError, UnspecifiedError }

class ListingsProvider extends ChangeNotifier {
  final _listingsService = new ListingsService();

  List<Listing> filteredListings = new List<Listing>();
  List<Listing> allListings;
  List<String> genres;
  final FilterList listingTypeFilter = new FilterList(['movie', 'series']);
  FilterList genreFilter;
  int numberOfFiltersApplied = 0;

  ListingsState _state = ListingsState.Fetching;
  ListingsState get state => _state;
  set state(ListingsState state){
    this._state = state;
    this.notifyListeners();
  }

  ListingsProvider() {
    this.getListings();
    this.listingTypeFilter.addListener(_filterUpdated);
  }

  void getListings() {
    this.state = ListingsState.Fetching;
    this._listingsService.getListings().then((listings) {
      this.allListings = listings;
      if (genreFilter == null) {
        this._listingsService.getGenres().then((genres){
          this.genres = genres;
          this.genreFilter = new FilterList(genres);
          this.genreFilter.addListener(_filterUpdated);
          this.filterListings();
        })
        .timeout(const Duration(seconds:10), onTimeout: _handleTimeoutException)
        .catchError((error) => _handleUnspecifiedError());
      }
      else {
       this.filteredListings.addAll(listings);
       this.state = ListingsState.Retrieved;
      }
    }).timeout(const Duration(seconds: 10), onTimeout: _handleTimeoutException
    ).catchError((error) => _handleUnspecifiedError());
  }

  void filterListings() {
    this.state = ListingsState.Fetching;
    var selectedGenreSet = Set<String>();
    selectedGenreSet.addAll(genreFilter.where((f) => f.isSelected).map((f) => f.name));
    List<Listing> filtered = new List<Listing>();
    filtered.addAll(allListings.where((l) =>
    selectedGenreSet.intersection(l.genres.toSet()).length > 0 && this.listingTypeFilter.isActive(l.type)));
    this.filteredListings = filtered;
    this.numberOfFiltersApplied = (this.listingTypeFilter.hasFilterApplied ? 1 : 0) + (this.genreFilter.hasFilterApplied ? 1 : 0);
    this.state = ListingsState.Retrieved;
  }

  FutureOr<Null> _handleTimeoutException() {
    this.state = ListingsState.NetworkError;
    throw new Exception();
  }

  FutureOr<Null> _handleUnspecifiedError() {
    this.state = ListingsState.UnspecifiedError;
    throw new Exception();
  }

  void _filterUpdated() {
    this.filterListings();
  }
}
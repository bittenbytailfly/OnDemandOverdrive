import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ondemand_overdrive/models/Listing.dart';
import 'package:ondemand_overdrive/models/FilterList.dart';
import 'package:ondemand_overdrive/screens/FilterDrawer.dart';
import 'package:ondemand_overdrive/screens/ListingDetailScreen.dart';
import 'package:ondemand_overdrive/screens/MenuDrawer.dart';
import 'package:ondemand_overdrive/services/ListingsService.dart';
import 'package:ondemand_overdrive/widgets/NoConnectionNotification.dart';

class ListingsScreen extends StatelessWidget {
  final String title;

  ListingsScreen({Key key, this.title}) : super(key: key);

  void _getListings() {
    Future.wait([listingsService.getGenres(), listingsService.getListings()])
        .then((futures) {
          this._genres = futures[0].cast<String>();
          this._listings = futures[1].cast<Listing>();

          // pre-populate all the filters
          this._listingTypeFilter = new FilterList(['movie', 'series']);
          this._genreFilter = new FilterList(_genres);

          this._genreFilter.addListener(_updateListings);
          this._listingTypeFilter.addListener(_updateListings);

          this._updateListings();
        })
        .timeout(const Duration(seconds: 10), onTimeout: _filterListingsError)
        .catchError((error) => _filterListingsError());
  }

  Future _refreshListings() async {
    setState(() {
      this._filteredListings = new Future(() {
        listingsService
            .getListings()
            .then((listings) {
              this._listings = listings.cast<Listing>();
              _updateListings();
            })
            .timeout(const Duration(seconds: 10),
                onTimeout: _filterListingsError)
            .catchError((error) => _filterListingsError());
      });
    });
  }

  void _updateListings() {
    setState(() {
      _filteredListings = _filterListings();
    });
  }

  //Ensures the "unable to load data" message appears
  FutureOr<Null> _filterListingsError() async {
    setState(() {
      _filteredListings = new Future(() => throw new Exception());
    });
  }

  Future _filterListings() async {
    var selectedGenreSet = Set<String>();
    selectedGenreSet
        .addAll(_genreFilter.where((f) => f.isSelected).map((f) => f.name));
    List<Listing> filtered = new List<Listing>();
    filtered.addAll(_listings.where((l) =>
        selectedGenreSet.intersection(l.genres.toSet()).length > 0 &&
        this._listingTypeFilter.isActive(l.type)));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        automaticallyImplyLeading: true,
        actions: <Widget>[
          Container()
        ],
      ),
      body: _buildListings(),
      drawer: MenuDrawer(),
      endDrawer: FilterDrawer(
          genres: this._genres,
          listingTypeFilter: this._listingTypeFilter,
          genreFilter: this._genreFilter),
    );
  }

  Widget _buildListings() {
    return RefreshIndicator(
      onRefresh: _refreshListings,
      displacement: 20.0,
      child: Container(
          child: FutureBuilder(
              future: _filteredListings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length > 0
                      ? _buildResultWidget(snapshot.data)
                      : _buildNoResultsWidget();
                } else if (snapshot.hasError) {
                  return NoConnectionNotification(
                    onRefresh: () => _getListings(),
                  );
                }
                return _buildLoadingIndicator();
              })),
    );
  }

  Widget _buildResultWidget(List<Listing> listings) {
    return OrientationBuilder(
      builder: (context, orientation) {
        List<Widget> slivers = _buildScrollView(listings.toList(), orientation);
        return CustomScrollView(
          slivers: slivers,
        );
      },
    );
  }

  SliverPadding _buildGridViewWidget(
      Orientation orientation, List<Listing> listings) {
    return SliverPadding(
      padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
      sliver: SliverGrid(
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: orientation == Orientation.landscape ? 4 : 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        delegate: SliverChildBuilderDelegate((context, i) {
          return _buildListing(listings[i]);
        }, childCount: listings.length),
      ),
    );
  }

  Widget _buildAdMobBanner(String adUnitId, AdmobBannerSize bannerSize) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Center(
          child: AdmobBanner(
            adUnitId: kReleaseMode
                ? adUnitId
                : 'ca-app-pub-3940256099942544/6300978111',
            adSize: bannerSize,
          ),
        ),
      ]),
    );
  }

  Widget _buildNoResultsWidget() {
    return Container(
        child: Center(child: Text('No results matching your search')));
  }

  Widget _buildLoadingIndicator() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildListing(Listing listing) {
    return GestureDetector(
      child: Column(children: [
        Expanded(
          flex: 10,
          child: ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: AspectRatio(
                aspectRatio: 0.71,
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image(
                      image: AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Container(
                    child: FadeInImage(
                      image: NetworkImage(listing.image),
                      fit: BoxFit.fitHeight,
                      height: double.maxFinite,
                      placeholder:
                          AssetImage('assets/images/placeholder-trans.png'),
                    ),
                  ),
                ]),
              )),
        ),
        Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                listing.name,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            )),
      ]),
      onTap: () => _pushListingDetailPage(listing.id),
    );
  }

  void _pushListingDetailPage(BigInt id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            body: ListingDetailScreen(id: id),
          );
        },
      ),
    );
  }

  List<Widget> _buildScrollView(
      List<Listing> listings, Orientation orientation) {
    List<Widget> widgets = <Widget>[];

    final listingsBeforeFirstAd = orientation == Orientation.landscape ? 4 : 6;

    widgets.add(FilterButton());
    widgets.add(_buildGridViewWidget(
        orientation, listings.take(listingsBeforeFirstAd).toList()));
    widgets.add(_buildAdMobBanner('ca-app-pub-1438831506348729/6805128414',
        AdmobBannerSize.MEDIUM_RECTANGLE));
    if (listings.length > listingsBeforeFirstAd) {
      widgets.add(_buildGridViewWidget(
          orientation, listings.skip(listingsBeforeFirstAd).toList()));
    }

    return widgets;
  }
}

class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.teal.shade700,
            backgroundBlendMode: BlendMode.darken,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: FlatButton.icon(
              color: Colors.transparent,
              label: Text(
                'FILTER',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              icon: Icon(Icons.filter_list),
              onPressed: Scaffold.of(context).openEndDrawer,
            ),
          ),
        ),
      ]),
    );
  }
}

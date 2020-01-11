import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/Listing.dart';
import 'package:ondemand_overdrive/models/FilterList.dart';
import 'package:ondemand_overdrive/screens/ListingDetailScreen.dart';
import 'package:ondemand_overdrive/services/ListingsService.dart';
import 'package:ondemand_overdrive/widgets/NoConnectionNotification.dart';

class ListingsScreen extends StatefulWidget {
  ListingsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingsScreen> {
  List<Listing> _listings;
  Future _filteredListings;
  List<String> _genres;
  FilterList _listingTypeFilter;
  FilterList _genreFilter;
  final listingsService = new ListingsService();

  @override
  void initState() {
    super.initState();

    _getListings();
  }

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
    });
  }

  Future _updateListings() async {
    setState(() {
      _filteredListings = _filterListings();
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
        title: Text(widget.title),
      ),
      body: _buildListings(),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: FutureBuilder(
          future: _filteredListings,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              const largerFontStyle = TextStyle(fontSize: 18.0);
              return CustomScrollView(slivers: <Widget>[
                _buildDrawerSliver(largerFontStyle),
                _buildListingTypeFilterHeaderSliver(),
                _buildListingTypeFilterSliver(largerFontStyle),
                _buildDividingSliver(),
                _buildGenreFilterHeaderSliver(),
                _buildGenreFilterSliver(largerFontStyle),
              ]);
            } else if (snapshot.hasError) {
              throw new Exception();
            }
            return _buildLoadingIndicator();
          }),
    );
  }

  Widget _buildListingTypeFilterHeaderSliver() {
    return SliverList(
      delegate: SliverChildListDelegate([
        CheckboxListTile(
          title: const Text(
            'Listing Type',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          value: _listingTypeFilter.hasSelectedItems(),
          onChanged: (bool checked) {
            this._listingTypeFilter.toggleAll(checked);
          },
        )
      ]),
    );
  }

  Widget _buildGenreFilterHeaderSliver() {
    return SliverList(
      delegate: SliverChildListDelegate([
        CheckboxListTile(
          title: const Text(
            'Genre',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          value: _genreFilter.hasSelectedItems(),
          onChanged: (bool checked) {
            this._genreFilter.toggleAll(checked);
          },
        )
      ]),
    );
  }

  Widget _buildDividingSliver() {
    return SliverList(
      delegate: SliverChildListDelegate([Divider()]),
    );
  }

  Widget _buildDrawerSliver(TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildListDelegate([
        DrawerHeader(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Filter Results',
              style: largerFontStyle,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.teal,
          ),
        )
      ]),
    );
  }

  Widget _buildGenreFilterSliver(TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        return CheckboxListTile(
          title: Text(
            _genreFilter[i].name,
            style: largerFontStyle,
          ),
          value: _genreFilter[i].isSelected,
          onChanged: (bool checked) {
            this._genreFilter[i].toggle(checked);
          },
        );
      }, childCount: _genreFilter.length),
    );
  }

  Widget _buildListingTypeFilterSliver(TextStyle largerFontStyle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int i) {
        var label = _listingTypeFilter[i].name[0].toUpperCase() +
            _listingTypeFilter[i].name.substring(1);
        return CheckboxListTile(
          title: Text(
            label,
            style: largerFontStyle,
          ),
          value: _listingTypeFilter[i].isSelected,
          onChanged: (bool checked) {
            this._listingTypeFilter[i].toggle(checked);
          },
        );
      }, childCount: _listingTypeFilter.length),
    );
  }

  Widget _buildListings() {
    return RefreshIndicator(
      onRefresh: _updateListings,
      displacement: 20.0,
      child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: FutureBuilder(
              future: _filteredListings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.length > 0
                      ? _buildResultWidget(snapshot)
                      : _buildNoResultsWidget();
                } else if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.none) {
                  return NoConnectionNotification(
                    onRefresh: () => _getListings(),
                  );
                }
                return _buildLoadingIndicator();
              })),
    );
  }

  Widget _buildResultWidget(AsyncSnapshot snapshot) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return GridView.builder(
            itemCount: snapshot.data.length,
            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.landscape ? 5 : 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, i) {
              return _buildListing(snapshot.data[i]);
            });
      },
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
                  Center(
                    child: FadeInImage(
                      image: NetworkImage(listing.image),
                      fit: BoxFit.contain,
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
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/Listing.dart';
import 'package:http/http.dart' as http;
import 'package:ondemand_overdrive/screens/ListingDetailScreen.dart';

class ListingsScreen extends StatefulWidget {
  ListingsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingsScreen> {

  Future _listingsFuture;
  Future _filteredListings;
  Future _genres;
  List<String> _selectedListingTypes;
  List<String> _selectedGenres;

  @override
  void initState(){
    super.initState();
    this._listingsFuture = _getListings();
    this._selectedListingTypes = ['movie','series'];
    this._selectedGenres = List<String>();
    this._genres = _getGenres();
    // pre-populate all the genre tick boxes
    this._genres.then((genres) => this._selectedGenres.addAll(genres));

    _filterListings();
  }

  void _filterListings(){
    setState(() {
      var selectedGenreSet = Set<String>();
      selectedGenreSet.addAll(_selectedGenres);
      _filteredListings = _listingsFuture.then(
              (listings) => listings.where(
                      (l) =>
                      (_selectedListingTypes.length == 0 || _selectedListingTypes.contains(l.type)) &&
                              (selectedGenreSet.length == 0 || selectedGenreSet.intersection(l.genres.toSet()).length > 0)
              ).toList());
    });
  }

  Future<List<String>> _getGenres() async {
    final response = await http.get('http://test.1024design.co.uk/api/listings/genres');

    if (response.statusCode == 200){
      var data = jsonDecode(response.body);
      return data.cast<String>();
    }
    else {
      throw Exception();
    }
  }

  Future<List<Listing>> _getListings() async {
    final response = await http.get('http://test.1024design.co.uk/api/listings');

    if (response.statusCode == 200){
      var data = jsonDecode(response.body);
      var listings = data as List;
      return listings.map<Listing>((json) => Listing.fromJson(json)).toList();
    }
    else {
      throw Exception();
    }
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

  Widget _buildDrawer(){
    return Drawer(
      child: FutureBuilder(
        future: _genres,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                        DrawerHeader(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Filter Results',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.teal,
                          ),
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'Listing Type',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          value: _selectedListingTypes.length > 0,
                          onChanged: (bool checked) {
                            if (checked) {
                              setState(() {
                                this._selectedListingTypes.add('movie');
                                this._selectedListingTypes.add('series');
                              });
                            }
                            else {
                              setState(() {
                                this._selectedListingTypes.removeRange(0, this._selectedListingTypes.length);
                              });
                            }
                            _filterListings();
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'Movies',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          value: _selectedListingTypes.contains('movie'),
                          onChanged: (bool checked) {
                            if (checked) {
                              this._selectedListingTypes.add('movie');
                            }
                            else {
                              this._selectedListingTypes.remove('movie');
                            }
                            _filterListings();
                          },
                        ),
                        CheckboxListTile(
                          title: const Text(
                            'Series',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          value: _selectedListingTypes.contains('series'),
                          onChanged: (bool checked) {
                            if (checked) {
                              this._selectedListingTypes.add('series');
                            }
                            else {
                              this._selectedListingTypes.remove('series');
                            }
                            _filterListings();
                          },
                        ),
                        Divider(),
                        CheckboxListTile(
                          title: const Text(
                            'Genre',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          value: _selectedGenres.length > 0,
                          onChanged: (bool checked) {
                            if (checked) {
                              setState(() {
                                this._genres.then((genres) => this._selectedGenres.addAll(genres));
                              });
                            }
                            else {
                              setState(() {
                                this._selectedGenres.removeRange(0, this._selectedGenres.length);
                              });
                            }
                            _filterListings();
                          },
                        ),
                      ])
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((BuildContext context,
                        int i) {
                      return CheckboxListTile(
                        title: Text(
                          snapshot.data[i],
                          style: TextStyle(fontSize: 18.0),
                        ),
                        value: _selectedGenres.contains(snapshot.data[i]),
                        onChanged: (bool checked) {
                          if (checked) {
                            this._selectedGenres.add(snapshot.data[i]);
                          }
                          else {
                            this._selectedGenres.remove(snapshot.data[i]);
                          }
                          _filterListings();
                        },
                      );
                    }
                    ,childCount: snapshot.data.length),
                  )
                ]
            );
          }
          else if (snapshot.hasError) {
            throw new Exception();
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      ),
    );
  }

  Widget _buildListings(){

    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: FutureBuilder(
          future: _filteredListings,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data.length,
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, i) {
                  return _buildListing(snapshot.data[i]);
                }
              );
            }
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        )
    );
  }

  Widget _buildListing(Listing listing){
    return GestureDetector(
      child: Column(
          children: [
            Expanded(
              flex: 10,
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image(
                        image: AssetImage('assets/images/placeholder.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    FadeInImage(
                      image: NetworkImage(listing.image),
                      fit: BoxFit.contain,
                      placeholder: AssetImage('assets/images/placeholder-trans.png'),
                    ),
                  ]
                )
              ),
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
                )
            ),
          ]
      ),
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
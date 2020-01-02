import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/listing.dart';
import 'package:http/http.dart' as http;
import 'package:ondemand_overdrive/screens/ListingDetailScreen.dart';

class ListingsScreen extends StatefulWidget {
  ListingsScreen({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingsScreen> {
  Future<List> _getListings() async {
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _buildListings(),
    );
  }

  Widget _buildListings(){

    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: FutureBuilder(
            future: _getListings(),
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
                  child: FadeInImage.assetNetwork(
                    image: listing.image,
                    fit: BoxFit.contain,
                    placeholder: 'assets/images/placeholder.png',
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
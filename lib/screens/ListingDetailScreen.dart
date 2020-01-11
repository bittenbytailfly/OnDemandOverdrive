import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ondemand_overdrive/models/ListingDetail.dart';
import 'package:ondemand_overdrive/services/ListingsService.dart';
import 'package:transparent_image/transparent_image.dart';

class ListingDetailScreen extends StatefulWidget {
  final BigInt id;

  ListingDetailScreen({Key key, this.id}) : super(key: key);

  @override
  _ListingDetailScreenState createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final _listingsService = new ListingsService();
  Future _listingDetail;

  @override
  void initState(){
    super.initState();

    _getListingDetail();
  }

  void _getListingDetail() {
    setState(() {
      _listingDetail = this._listingsService.getDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ListingDetail>(
        future: this._listingDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildDetailScreen(snapshot.data, context);
          }
          else if (snapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Unable to load data'),
                  RaisedButton(
                    onPressed: () => _getListingDetail(),
                    child: Text('Retry'),
                  )
                ],
              ),
            );
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  Widget _buildDetailScreen(ListingDetail listing, BuildContext context) {
    return SingleChildScrollView(
      child: _buildStack(listing, context),
    );
  }

  Widget _buildStack(ListingDetail listing, BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildBackgroundStack(listing),
        _buildForegroundStack(listing, context),
      ],
    );
  }

  Widget _buildForegroundStack(ListingDetail listing, BuildContext context) {
    var appBar = AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        listing.name,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final _thirdHeight = MediaQuery.of(context).size.height / 6;

    return Column(
      children: <Widget>[
        appBar,
        Padding(
          padding: EdgeInsets.only(top: _thirdHeight - appBar.preferredSize.height, left: 8.0, right: 8.0, bottom: 8.0),
          child: Column(
            children: [
              _buildListingDetailHeader(listing),
              _buildTextInfo('', listing.description),
              _buildTextInfo('Actors', listing.actors),
              _buildTextInfo('Directed By', listing.director),
              _buildTextInfo('Production', listing.production),
              _buildTextInfo('Genre', listing.genre),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildListingDetailHeader(ListingDetail listing) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildCoverArt(listing),
          ),
          Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        listing.name,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Text(
                      listing.releaseDate.toString() + " - " + listing.runtime,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Container _buildCoverArt(ListingDetail listing) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 5,
          blurRadius: 5,
        )
      ]),
      child: ClipRRect(
          borderRadius: new BorderRadius.circular(8.0),
          child: FadeInImage.assetNetwork(
            image: listing.image,
            fit: BoxFit.contain,
            placeholder: 'assets/images/placeholder.png',
          )),
    );
  }

  Widget _buildTextInfo(String title, String detail) {
    return Visibility(
      visible: detail != null && detail.length > 0,
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: <Widget>[
            Visibility(
              visible: title != null && title.length > 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                detail,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundStack(ListingDetail listing) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final _thirdHeight = MediaQuery.of(context).size.height / 3;
      return Stack(children: <Widget>[
        FadeInImage(
          image: NetworkImage(listing.image),
          height: _thirdHeight,
          width: constraints.maxWidth,
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
        ),
        BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: new Container(
            height: _thirdHeight,
            decoration:
                new BoxDecoration(color: Colors.grey[200].withOpacity(0.1)),
          ),
        ),
        FadeInImage(
          image: NetworkImage(listing.background),
          height: _thirdHeight,
          width: constraints.maxWidth,
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
        ),
      ]);
    });
  }
}

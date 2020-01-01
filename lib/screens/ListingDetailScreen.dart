import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ondemand_overdrive/listingDetail.dart';

class ListingDetailPage extends StatelessWidget{
  final BigInt id;

  ListingDetailPage({Key key, this.id}) : super(key: key);

  Future<ListingDetail> _getDetail() async {
    final response = await http.get('http://test.1024design.co.uk/api/listingdetail/' + this.id.toString());

    if (response.statusCode == 200){
      var data = jsonDecode(response.body);
      return ListingDetail.fromJson(data);
    }
    else {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Listing Detail'),
        ),
        body: FutureBuilder<ListingDetail>(
            future: _getDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(
                    snapshot.data.description
                );
              }
              else if (snapshot.hasError) {
                return Text(
                    this.id.toString()
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
}
import 'dart:convert';
import 'package:ondemand_overdrive/models/Listing.dart';
import 'package:http/http.dart' as http;
import 'package:ondemand_overdrive/models/ListingDetail.dart';

class ListingsService {
  Future getGenres() async {
    final response =
        await http.get('https://www.1024design.co.uk/api/odod/genres');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data.cast<String>();
    } else {
      throw Exception();
    }
  }

  Future getListings() async {
    final response = await http.get('https://www.1024design.co.uk/api/odod/listings');

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var listings = data as List;
      return listings.map<Listing>((json) => Listing.fromJson(json)).toList();
    } else {
      throw Exception();
    }
  }

  Future<ListingDetail> getDetail(BigInt id) async {
    final response = await http.get('https://www.1024design.co.uk/api/odod/listing/' + id.toString());

    if (response.statusCode == 200){
      var data = jsonDecode(response.body);
      return ListingDetail.fromJson(data);
    }
    else {
      throw Exception();
    }
  }
}

import 'package:flutter/cupertino.dart';

class Listing {
  final BigInt id;
  final String name;
  final String image;

  Listing({this.id, this.name, this.image});

  factory Listing.fromJson(Map<String, dynamic> json){
    return Listing(
      id: BigInt.parse(json['id'].toString()),
      name: json['Title'],
      image: json['Image']
    );
  }
}
import 'package:html_unescape/html_unescape.dart';

class Listing {
  final BigInt id;
  final String name;
  final String image;

  Listing({this.id, this.name, this.image});

  factory Listing.fromJson(Map<String, dynamic> json){
    var unescape = new HtmlUnescape();
    return Listing(
      id: BigInt.parse(json['id'].toString()),
      name: unescape.convert(json['Title']),
      image: json['Image']
    );
  }
}
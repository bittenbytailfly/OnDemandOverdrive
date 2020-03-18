import 'package:html_unescape/html_unescape.dart';

class Listing {
  final BigInt id;
  final String name;
  final String image;
  final String type;
  final List<String> genres;

  Listing({this.id, this.name, this.image, this.type, this.genres});

  factory Listing.fromJson(Map<String, dynamic> json){
    var unescape = new HtmlUnescape();
    return Listing(
        id: BigInt.parse(json['id'].toString()),
        name: unescape.convert(json['title']),
        image: json['image'],
        type: json['type'],
        genres: List.from(json['genres'])
    );
  }
}
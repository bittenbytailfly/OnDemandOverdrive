import 'package:html_unescape/html_unescape.dart';

class ListingDetail {
  final BigInt id;
  final String name;
  final String image;
  final String description;
  final int releaseDate;
  final String runtime;
  final String background;

  ListingDetail({this.id, this.name, this.image, this.description, this.releaseDate, this.runtime, this.background});

  factory ListingDetail.fromJson(Map<String, dynamic> json){
    var unescape = new HtmlUnescape();

    return ListingDetail(
        id: BigInt.parse(json['Id'].toString()),
        name: unescape.convert(json['Title']),
        image: json['Image'],
        description: unescape.convert(json['Description']),
        releaseDate: json['ReleaseDate'],
        runtime: json['Runtime'],
        background: json['Background'],
    );
  }
}
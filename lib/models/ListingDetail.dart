import 'package:html_unescape/html_unescape.dart';

class ListingDetail {
  final BigInt id;
  final String name;
  final String image;
  final String description;
  final int releaseDate;
  final String runtime;
  final String background;
  final String director;
  final String actors;
  final String production;
  final String genre;

  ListingDetail({this.id, this.name, this.image, this.description, this.releaseDate, this.runtime, this.background, this.actors, this.director, this.production, this.genre});

  factory ListingDetail.fromJson(Map<String, dynamic> json){
    var unescape = new HtmlUnescape();

    return ListingDetail(
      id: BigInt.parse(json['id'].toString()),
      name: unescape.convert(json['title']),
      image: json['image'],
      description: unescape.convert(json['description']),
      releaseDate: json['releaseDate'],
      runtime: json['runtime'],
      background: json['background'],
      actors: json['actors'],
      director: json['director'],
      production: json['production'],
      genre: json['genres'],
    );
  }
}
import 'package:html_unescape/html_unescape.dart';

class SubscriberListing {
  final BigInt id;
  final String title;
  final String image;
  final String description;
  final String coverImage;
  final DateTime dateAdded;

  SubscriberListing({this.id, this.title, this.image, this.description, this.coverImage, this.dateAdded});

  factory SubscriberListing.fromJson(Map<String, dynamic> json) {
    var unescape = new HtmlUnescape();

    return SubscriberListing(
      id: BigInt.parse(json['id'].toString()),
      title: unescape.convert(json['title']),
      image: json['image'],
      description: json['description'],
      coverImage: json['coverImage'],
      dateAdded: DateTime.parse(json['dateAdded'].toString())
    );
  }
}
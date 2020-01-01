

class ListingDetail {
  final BigInt id;
  final String name;
  final String image;
  final String description;
  final int releaseDate;
  final String runtime;

  ListingDetail({this.id, this.name, this.image, this.description, this.releaseDate, this.runtime});

  factory ListingDetail.fromJson(Map<String, dynamic> json){
    return ListingDetail(
        id: BigInt.parse(json['Id'].toString()),
        name: json['Title'],
        image: json['Image'],
        description: json['Description'],
        releaseDate: json['ReleaseDate'],
        runtime: json['Runtime'],
    );
  }
}
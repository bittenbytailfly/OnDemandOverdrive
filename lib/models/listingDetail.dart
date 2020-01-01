

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
    return ListingDetail(
        id: BigInt.parse(json['Id'].toString()),
        name: json['Title'],
        image: json['Image'],
        description: json['Description'],
        releaseDate: json['ReleaseDate'],
        runtime: json['Runtime'],
        background: json['Background'],
    );
  }
}
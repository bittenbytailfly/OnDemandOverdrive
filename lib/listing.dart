class Listing {
  final String name;
  final String image;

  Listing({this.name, this.image});

  factory Listing.fromJson(Map<String, dynamic> json){
    return Listing(
      name: json['Title'],
      image: json['Image']
    );
  }
}
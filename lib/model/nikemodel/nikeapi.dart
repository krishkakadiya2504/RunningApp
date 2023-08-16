class Shoe {
  final String name;
  final String imageUrl;
  final String details;
  final int priceInr;

  Shoe({
    required this.name,
    required this.imageUrl,
    required this.details,
    required this.priceInr,
  });

  factory Shoe.fromJson(Map<String, dynamic> json) {
    return Shoe(
      name: json['name'],
      imageUrl: json['image_url'],
      details: json['details'],
      priceInr: json['price_inr'],
    );
  }
}

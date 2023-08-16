class Product {
  final String name;
  final String brand;
  final String color;
  final double price;
  final double oldPrice;
  final int discountPercentage;
  final String details;
  final String imageUrl;
  final List<Review> reviews;
  final String style;
  final  List<String> availableColors;
  final  List<String> availableSizes;
  final String description;

  Product({
    required this.availableColors, required this.availableSizes,
    required this.name,
    required this.brand,
    required this.color,
    required this.price,
    required this.oldPrice,
    required this.discountPercentage,
    required this.details,
    required this.imageUrl,
    required this.reviews,
    required this.style,

    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<Review> parseReviews(List<dynamic> reviews) {
      return reviews.map((review) => Review.fromJson(review)).toList();
    }

    return Product(
      name: json['name'],
      brand: json['brand'],
      color: json['color'],
      price: json['price'].toDouble(),
      oldPrice: json['old_price'].toDouble(),
      discountPercentage: json['discount_percentage'],
      details: json['details'],
      imageUrl: json['image_url'],
      reviews: parseReviews(json['reviews']),
      style: json['style'],
      availableColors: List<String>.from(json['available_colors']),
      availableSizes: List<String>.from(json['available_sizes']),
      description: json['description'],
    );
  }
}
class Review {
  final String user;
  final int rating;
  final String review;

  Review({
    required this.user,
    required this.rating,
    required this.review,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      user: json['user'] ?? '',
      rating: json['rating'] ?? 0,
      review: json['review'] ?? '',
    );
  }
}



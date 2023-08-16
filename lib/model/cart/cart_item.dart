class CartItem {
  final String imageUrl;
  final String productName;
  final double productPrice;

  CartItem({
    required this.imageUrl,
    required this.productName,
    required this.productPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'productName': productName,
      'productPrice': productPrice,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      imageUrl: json['imageUrl'],
      productName: json['productName'],
      productPrice: json['productPrice'],
    );
  }
}

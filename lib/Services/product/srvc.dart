import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;


import '../../model/product/s1.dart';


class ProductService {
  Future<List<Product>> getProducts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/prudect.json');
      final jsonData = json.decode(jsonString);
      final productsData = jsonData['products'] as List<dynamic>;
      return productsData.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }
}

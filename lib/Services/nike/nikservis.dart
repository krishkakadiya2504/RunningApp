import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../model/nikemodel/nikeapi.dart';





class NikeServices {
  Future<List<Shoe>> getProducts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/nikes.json');
      final jsonData = json.decode(jsonString);
      final NikeData = jsonData['shoes'] as List<dynamic>;
      return NikeData.map((item) => Shoe.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error loading products: $e');
    }
  }
}

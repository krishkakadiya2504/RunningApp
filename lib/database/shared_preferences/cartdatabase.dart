
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart/cart_item.dart';

class CartDatabase {
  static const _cartKey = 'cart';

  Future<List> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartStringList = prefs.getStringList(_cartKey);
    if (cartStringList == null) return [];
    return cartStringList
        .map((json) => CartItem.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartStringList =
    items.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList(_cartKey, cartStringList);
  }
}

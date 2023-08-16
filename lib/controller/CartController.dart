import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/product/s1.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  var totalCartitem;

  List<Product> get cartItems => _cartItems;
  List<Product> wishlistItems = [];


  // A method to update the cart items by fetching from Firestore
  void removeFromWishlist(String productName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      // Remove the product from Firestore
      await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('Wislist')
          .doc(productName)
          .delete();

      // Remove the product from the local cart
      _cartItems.removeWhere((product) => product.name == productName);
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error removing from Wislist and Firestore: $error');
    }
  }

  void clearWishlist() {
    wishlistItems.clear();
    notifyListeners();
  }
  Future<void> moveAllWishlistToCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      // Fetch all documents from the 'Wislist' collection
      final wishlistSnapshot = await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('Wislist')
          .get();

      // Loop through each document in the 'Wislist' collection
      for (var doc in wishlistSnapshot.docs) {
        // Get the data from the 'Wislist' document
        Map<String, dynamic> wishlistData = doc.data() as Map<String, dynamic>;

        // Add the data to the 'cart' collection
        await FirebaseFirestore.instance
            .collection('Registration')
            .doc(user.uid)
            .collection('cart')
            .doc(doc.id) // Use the same document ID in 'cart' collection
            .set(wishlistData);

        // Delete the document from the 'Wislist' collection
        await doc.reference.delete();
      }

      // Clear the local wishlistItems list
      wishlistItems.clear();
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error moving wishlist to cart: $error');
    }
  }
  Future<void> _saveShoppingDetails({
    required String address,
    required String mobileNumber,
    required String email,
    required String paymentMethod,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      final currentDate = DateTime.now();
      final formattedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      final formattedDateStr = formattedDate.toLocal().toString();

      await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('Order')
          .doc(formattedDateStr) // Use the formatted date as the document ID
          .set({
        'address': address,
        'mobileNumber': mobileNumber,
        'email': email,
        'paymentMethod': paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving shopping details: $e');
      throw e;
    }
  }


  Future<void> moveCartToOrder(String address, String mobileNumber, String email, String paymentMethod) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('cart')
          .get();

      for (var doc in cartSnapshot.docs) {
        Map<String, dynamic> cartData = doc.data() as Map<String, dynamic>;

        await _saveShoppingDetails(
          address: address,
          mobileNumber: mobileNumber,
          email: email,
          paymentMethod: paymentMethod,
        );

        String orderId = Uuid().v4();
        final currentDate = DateTime.now();
        final formattedDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
        final formattedDateStr = formattedDate.toLocal().toString();
        await FirebaseFirestore.instance
            .collection('Registration')
            .doc(user.uid)
            .collection('Order')
            .doc(formattedDateStr) // Use the formatted date as the document ID
            .collection('orders')
            .doc(orderId)
            .set(cartData);

        await doc.reference.delete();
      }

      _cartItems.clear();
      notifyListeners();
    } catch (error) {
      print('Error moving cart to order: $error');
    }
  }
  Future<void> addToCartAndFirestore(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('cart')
          .doc(product.name);

      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Product already exists in cart, update the quantity
        final currentQuantity = (cartSnapshot.data()?['quantity'] ?? 0) + 1;

        await cartRef.update({
          'quantity': currentQuantity,
        });
      } else {
        // Product doesn't exist in cart, add it
        await cartRef.set({
          'productName': product.name,
          'price': product.price,
          'image': product.imageUrl,
          'details': product.details,
          'quantity': 1, // Set initial quantity to 1
          // Add more fields as needed
        });
      }

      // Add the product to the cart locally
      _cartItems.add(product);
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error adding to cart and Firestore: $error');
    }
  }
  void removeFromCart(String productName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      // Remove the product from Firestore
      await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('Wislist')
          .doc(productName)
          .delete();

      // Remove the product from the local cart
      _cartItems.removeWhere((product) => product.name == productName);
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error removing from cart and Firestore: $error');
    }
  }



  void clearCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      // Clear the cart collection in Firestore
      await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('cart')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Clear the local cart
      _cartItems.clear();
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error clearing cart and Firestore: $error');
    }
  }

  Future<void> addToWishlistAndFirestore(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('Wislist')
          .doc(product.name);

      final cartSnapshot = await cartRef.get();

      if (cartSnapshot.exists) {
        // Product already exists in cart, update the quantity
        final currentQuantity = (cartSnapshot.data()?['quantity'] ?? 0) + 1;

        await cartRef.update({
          'quantity': currentQuantity,
        });
      } else {
        // Product doesn't exist in cart, add it
        await cartRef.set({
          'productName': product.name,
          'price': product.price,
          'image': product.imageUrl,
          'details': product.details,
          'quantity': 1, // Set initial quantity to 1
          // Add more fields as needed
        });
      }

      // Add the product to the cart locally
      wishlistItems.add(product);
      notifyListeners();
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error adding to Wishlist and Firestore: $error');
    }
  }

  // void addToWishlist(Product product) {
  //   wishlistItems.add(product);
  //   notifyListeners();
  // }

  Future<double> fetchTotalCartPriceFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Handle the case where the user is not authenticated
      return 0.0;
    }

    try {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('Registration')
          .doc(user.uid)
          .collection('cart')
          .get();

      double totalCartPrice = 0.0;
      totalCartitem = cartSnapshot.docs.length;

      cartSnapshot.docs.forEach((doc) {
        final price = doc.data()['price'] ?? 0.0;
        totalCartPrice += price;
      });

      return totalCartPrice;
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error fetching total cart price from Firestore: $error');
      return 0.0;
    }
  }

  bool get isCartEmpty {
    return _cartItems.isEmpty;
  }
}
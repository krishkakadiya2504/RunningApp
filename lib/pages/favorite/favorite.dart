import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/CartController.dart';

class favorite extends StatefulWidget {
  const favorite({super.key});

  @override
  State<favorite> createState() => _favoriteState();
}

class _favoriteState extends State<favorite> {
  @override
  Widget build(BuildContext context) {
    // final cartProvider = Provider.of<CartProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shopping WishList'),
          backgroundColor: Color.fromRGBO(46, 184, 197, 0.5019607843137255),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Registration')
              .doc(user?.uid) // Use null-aware operator to handle null user
              .collection('Wislist')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('Cart is Empty'));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var WishlistItem = snapshot.data!.docs[index].data();

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: ListTile(
                            leading: Image.network(WishlistItem['image']),
                            title: Center(child: Text(WishlistItem['productName'])),
                            trailing:Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {


                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  final productName = WishlistItem['productName']; // Use the unique identifier of the product
                                  cartProvider.removeFromCart(productName);
                                },
                              ),
                            ],
                          ),

                            subtitle: Column(
                              children: [

                                Text(
                                  "\$${WishlistItem['price']?.toStringAsFixed(2) ?? 'N/A'}",
                                  // Use null-aware operator and null-coalescing operator
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    WishlistItem['details'] ?? 'No details available',
                                    maxLines: 2),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ],
            );
          },
        ),

        bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.135,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [



                    FilledButton(
                        onPressed: () {
                          cartProvider.clearCart();
                        },
                        child: Text('Clear Wishlist'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(46, 184, 197, 0.5019607843137255),
                            ))),
                    FilledButton(
                        onPressed: () {
                            cartProvider.moveAllWishlistToCart();
                        },
                        child: Text('Add To Cart All'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromRGBO(46, 184, 197, 0.5019607843137255),
                            ))),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controller/CartController.dart';
import '../Item_and_buy/Buypage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Color.fromRGBO(46, 184, 197, 0.5019607843137255),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Registration')
            .doc(user?.uid) // Use null-aware operator to handle null user
            .collection('cart')
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
                    var cartItem = snapshot.data!.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          leading: Image.network(cartItem['image']),
                          title: Center(child: Text(cartItem['productName'])),
                          trailing: IconButton(
                            onPressed: () {
                              final productName = cartItem['productName'];
                              cartProvider.removeFromCartAndFirestore(productName).then((_) {
                                // Handle any post-removal actions if needed
                              });
                            },
                            icon: Icon(Icons.delete_forever_outlined),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                "\$${cartItem['price']?.toStringAsFixed(2) ?? 'N/A'}\n Quantity : X ${cartItem['quantity']}",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                cartItem['details'] ?? 'No details available',
                                maxLines: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

              ),
              FutureBuilder<double>(
                future: cartProvider.fetchTotalCartPriceFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading total cart price');
                  } else {
                    final totalCartPrice = snapshot.data ?? 0.0;
                    final totalCartItem = cartProvider.totalCartitem;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'TotalPrice: \$${totalCartPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            'TotalItemsInCart: $totalCartItem',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ... (rest of the code remains the same)
                        ],
                      ),
                    );
                  }
                },
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
                  child: Text('Clear cart'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                    Color.fromRGBO(46, 184, 197, 0.5019607843137255),
                  ))),
              FilledButton(
                  onPressed: () {
                    Get.to(
                      BuyScreen(
                        // totalCartPrice:
                        //     cartProvider.fetchTotalCartPriceFromFirestore.toStringAsFixed(2),
                        totalItemsInCart:
                            cartProvider.cartItems.length.toString(),
                      ),
                    );
                  },
                  child: Text('Buy Iteams'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                    Color.fromRGBO(46, 184, 197, 0.5019607843137255),
                  ))),
            ],
          ),
        ),
      )),
    );
  }
}

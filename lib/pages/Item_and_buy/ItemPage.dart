import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:running/model/product/s1.dart';
import '../../Services/product/srvc.dart';
import '../../controller/CartController.dart';
import '../cart/cart.dart';
import '../favorite/favorite.dart';

class itemPage extends StatefulWidget {
  Product Productitem;

  itemPage({required this.Productitem});

  static itemPage createWithNewData({
    required Product Productitem,
  }) {
    return itemPage(
      Productitem: Productitem,
    );
  }

  @override
  State<itemPage> createState() => _itemPageState();
}

class _itemPageState extends State<itemPage> {
  ProductService productService = ProductService();

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(255, 255, 255, 1.0),

        appBar: AppBar(
          backgroundColor: Color.fromRGBO(46, 184, 197, 0.5019607843137255),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                      child: Icon(Icons.shopping_cart)),
                  Text(
                    cartProvider.cartItems.length.toString(),
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                itemdetails(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromRGBO(46, 184, 197, 0.5019607843137255),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  cartProvider.addToWishlistAndFirestore(
                      widget.Productitem); // Add to wishlist
                  // Show a snackbar or toast indicating the item was added to the wishlist
                  Get.snackbar(
                    onTap: (snack) => Get.to(() => favorite()),
                    'Added to Wishlist',
                    '${widget.Productitem.name} added to the wishlist!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                icon: Icon(Icons.favorite_border, color: Colors.black),
                label: Text(
                  'ADD TO WishList',
                  style: TextStyle(color: Colors.black),
                )),
            FilledButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  cartProvider.addToCartAndFirestore(widget.Productitem);
                  // You can use Get.snackbar to display a snackbar with GetX.
                  Get.snackbar(
                    'Added to cart',
                    '${widget.Productitem.name} added to the cart!',
                    onTap: (snack) => Get.to(() => CartScreen()),
                  );
                },
                icon: Icon(Icons.shopping_bag_outlined, color: Colors.black),
                label: Text(
                  'ADD TO Cart',
                  style: TextStyle(color: Colors.black),
                ))
          ]),
        ),
      ),
    );
  }

  itemdetails() {
    var mh = MediaQuery.of(context).size.height;
    var mw = MediaQuery.of(context).size.width;

    return Center(
      child: Stack(
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(height: mh * 0.03),
            Image.network(
              widget.Productitem.imageUrl,
            ),
            Column(
              children: [
                SizedBox(height: mh * 0.03),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30)),
                    color: Color.fromRGBO(46, 184, 197, 0.5019607843137255),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Row(
                                            children: [
                                              Text("${widget.Productitem.name}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        // SizedBox(height: mh * 0.02, ),

                                        Padding(
                                          padding: const EdgeInsets.all(7.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "Compny :- ${widget.Productitem.brand}",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  )),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(" Price :- ",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                              Text(
                                                  "\$ ${widget.Productitem.price} ",
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        Row(
                                          children: [
                                            Text(" style :- ",
                                                style: TextStyle(

                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            Text("${widget.Productitem.style} ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Product Detail :-",
                                  maxLines: 4,
                                  style: TextStyle(

                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("\t\t${widget.Productitem.details}",
                                    maxLines: 5,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                " Now Trending :-",
                                maxLines: 4,
                                style: TextStyle(

                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: mh * 0.2,
                          child: FutureBuilder<List<Product>>(
                            future: productService.getProducts(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Error loading data'),
                                );
                              } else {
                                List<Product> products = snapshot.data ?? [];

                                return GridView.count(
                                  scrollDirection: Axis.horizontal,
                                  crossAxisCount: 1, // Two columns
                                  children: List.generate(
                                      products.length >= 5
                                          ? 3
                                          : products.length, (index) {
                                    // Get the index of the last 5 elements
                                    int productIndex = products.length >= 5
                                        ? (products.length - 5 + index)
                                        : index;
                                    Product product = products[productIndex];
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigate to a new instance of itemPage with different data
                                        navigator!.push(MaterialPageRoute(
                                          builder: (context) =>
                                              itemPage.createWithNewData(
                                                  Productitem: product),
                                        ));
                                      },
                                      child: SizedBox(
                                        height: mh * 01,
                                        width: mw * 0.1,
                                        child: Card(
                                          child: Column(
                                            children: [
                                              Flexible(

                                                child: Container(
                                                  width: 200,
                                                  color: Colors.white,
                                                  child: Image(
                                                    image: NetworkImage(
                                                      product.imageUrl,
                                                    ),
                                                    fit: BoxFit.contain,

                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(' ${product.name}',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                    "${product.brand} - ${product.color}",
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                          width: mw * 0.11),
                                                      Text(
                                                        "${product.oldPrice}  ",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      Text(
                                                        ":- ",
                                                      ),
                                                      Text(
                                                        "${product.price} ",
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "${product.discountPercentage}% off ",
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(height: mh * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Product Reviwe:-",
                              style: TextStyle(

                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: mh * 0.02),
                        Column(
                          children: widget.Productitem.reviews.map((review) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  borderOnForeground: true,
                                  elevation: 5,
                                  color: Colors.primaries[
                                      Random().nextInt(Colors.accents.length)],
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.primaries[Random()
                                                        .nextInt(Colors
                                                            .primaries
                                                            .length
                                                            .bitLength)],
                                                child: Text('${review.user}'
                                                    .toUpperCase()[0])),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: mh * 0.01,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    ' ${review.user}'
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    )),
                                              ),
                                              RatingBar.builder(
                                                initialRating:
                                                    review.rating.toDouble(),
                                                minRating: 1,
                                                itemSize: mh * 0.025,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  print(rating);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(review.review,
                                            textWidthBasis:
                                                TextWidthBasis.longestLine),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: mh * 0.05,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}

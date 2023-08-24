import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:running/pages/Seeall_page/Seall.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../Services/product/srvc.dart';
import '../../model/brand/brand.dart';
import '../../model/product/s1.dart';
// import '../../model/user/user.dart';
import '../Item_and_buy/ItemPage.dart';
// import '../cart/cart.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});



  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductService productService = ProductService();

  var itemCount = 0;

  var currentIndex = 0;
@override
  void initState() {
    // TODO: implement initState
    super.initState();

}
  @override
  Widget build(BuildContext context) {
    final mediaQueryh = MediaQuery.of(context).size.height;
    final mediaQueryw = MediaQuery.of(context).size.width;
     // ignore: unused_local_variable
     CarouselController carouselController = Get.put(CarouselController());
    return Center(
      child: Column(
        children: [
          Column(

            children: [


              Padding(
                padding: const EdgeInsets.only(top: 20.0, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Hello ",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
      ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Welcome to Running... ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),


              SizedBox(
                height: mediaQueryh * 0.01,
              ),


              GetX<CarouselController>(

                builder: (carouselController) {
                  return CarouselSlider(
                    items: Brandl
                        .map(
                          (url) => Image.asset(
                            url,
                            fit: BoxFit.contain,
                          ),
                    )
                        .toList(),
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.10,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayCurve: Curves.linear,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                      initialPage: carouselController.currentIndex.value,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        carouselController.onPageChanged(index);
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: mediaQueryh * 0.02,
              ),
              Obx(
                () =>  AnimatedSmoothIndicator(
                  activeIndex: carouselController.currentIndex.value ,
                  count: 7,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.black,
                    dotColor: Colors.black12,
                    dotHeight: mediaQueryh * 0.01,
                    dotWidth: mediaQueryw * 0.02,
                  ),
                ),
              ),
              SizedBox(
                height: mediaQueryh * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                        "Top Offers",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {Get.to(Seeallpage(name : 'Top Offers'));},
                        child: const Text('See all'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: mediaQueryh*0.25,
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
                        children: List.generate(4, (index) {
                          Product product1 = products[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(itemPage(
                                   Productitem: product1,


                                ));
                              },
                              child: Card(

                                child: Column(
                                  children: [
                                    Flexible(

                                      child: Container(
                                        width: 200,
                                        color: Colors.white,
                                        child: Image(
                                          image: NetworkImage(
                                            product1.imageUrl,
                                          ),
                                          fit: BoxFit.contain,

                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [Text(
                                          ' ${product1.name}'
                                          ,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                        Text(
                                          "${product1.brand} - ${product1.color}",

                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: mediaQueryw*0.15),

                                            Text(
                                              "${product1.oldPrice}  ",
                                              style: const TextStyle(color: Colors.red),
                                            ),
                                            const Text(
                                              ":- ",

                                            ),
                                            Text(
                                              "${product1.price} ",

                                            ),
                                          ],

                                        ),

                                        Text(
                                          "${product1.discountPercentage}% off ",

                                        ),],
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                "New-Arrivals",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                )
                            ),
                            TextButton(onPressed: () {
                              Get.to(Seeallpage(name :"New-Arrivals"));
                            }, child:  const Text(
                                "See all",

                            )),
                          ],
                        ),
                        SizedBox(
                          height: mediaQueryh*0.2,

                          child: Column(
                            children: [
                              Stack(children: [
                                Column(
                                  children: [
                                    SizedBox(height: mediaQueryh*0.02,),
                                    Row(

                                      children: [
                                        Container(
                                          alignment: Alignment.center,

                                          color: Colors.blueAccent,
                                          child: Text(
                                            '_Best Choice_ ',
                                            style: GoogleFonts.pacifico(
                                              decoration: TextDecoration.combine([

                                                // TextDecoration.underline, // Add underline decoration
                                                TextDecoration.overline, // Add overline decoration
                                                // TextDecoration.lineThrough, // Add line-through decoration
                                              ]),
                                              decorationColor: const Color.fromRGBO(46, 197, 156, 1.0),
                                              backgroundColor: const Color.fromRGBO(220, 255, 70, 1.0),
                                              fontSize: 40, // Increase the font size to make it more eye-catching
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black, // Set the text color
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ],
                                ),

                                Container(alignment: Alignment.topRight,child: SizedBox(height: mediaQueryh*0.2,child: const Image(image: NetworkImage('https://assets.myntassets.com/dpr_1.5,q_60,w_400,c_limit,fl_progressive/assets/images/20882902/2023/3/20/fc40b3b6-2c65-4018-847b-9c742e6a902e1679293837877-Skechers-Men-Sports-Shoes-8271679293837441-1.jpg'),fit: BoxFit.contain,))),
                                Column(
                                  children: [
                                    SizedBox(height: mediaQueryh*0.12,),
                                    Row(

                                      children: [
                                        SizedBox(height: mediaQueryh*0.01,width: mediaQueryw*0.1,),

                                        const Text(
                                          "Sparx",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: mediaQueryh*0.01,width: mediaQueryw*0.1,),

                                    Row(

                                      children: [
                                        SizedBox(height: mediaQueryh*0.01,width: mediaQueryw*0.15,),

                                        RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "\$",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black, // Set the text color
                                                ),
                                              ),
                                              TextSpan(
                                                text: "849.69",
                                                style: TextStyle(
                                                  fontSize: 24, // Increase the font size for the price
                                                  fontWeight: FontWeight.w700, // Use a bolder font for the price
                                                  color: Color.fromRGBO(46, 197, 156, 1.0), // Set the price text color
                                                  decoration: TextDecoration.underline, // Add underline decoration
                                                  decorationColor: Color.fromRGBO(46, 197, 156, 1.0), // Set the decoration color
                                                  decorationThickness: 2.0, // Adjust the thickness of the underline
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),


                                  ],
                                ),

                              ],)

                            ],
                          ),
                        ),


                      ],
                    ),
                  ),


                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Container(
                    alignment: Alignment.topLeft,
                    child: const Text('Lates Shoes',      style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )
                    ),
                  ),
          SizedBox(width: mediaQueryw*0.55,),
                  Container(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {Get.to(Seeallpage(name : 'Lates Shoes'));},
                      child: const Text('See all',

                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: mediaQueryh*0.25,
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
                        children: List.generate(products.length >= 10 ? 5 : products.length, (index) {
                          //     // Get the index of the last 5 elements
                              int productIndex = products.length >= 5 ? (products.length - 5 + index) : index;
                              Product product1 = products[productIndex];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(itemPage(
                                     Productitem: product1,

                                ));
                              },
                              child: Card(

                                child: Column(
                                  children: [
                                    Flexible(

                                      child: Container(
                                        width: 200,
                                        color: Colors.white,
                                        child: Image(
                                          image: NetworkImage(
                                            product1.imageUrl,
                                          ),
                                          fit: BoxFit.contain,

                                        ),
                                      ),
                                    ),
                                   Column(
                                     children: [Text(
                                         ' ${product1.name}'
                                         ,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                       Text(
                                         "${product1.brand} - ${product1.color}",

                                       ),
                                       Row(
                                         children: [
                                           SizedBox(width: mediaQueryw*0.15),

                                           Text(
                                             "${product1.oldPrice}  ",
                                             style: const TextStyle(color: Colors.red),
                                           ),
                                           const Text(
                                             ":- ",

                                           ),
                                           Text(
                                             "${product1.price} ",

                                           ),
                                         ],

                                       ),

                                       Text(
                                         "${product1.discountPercentage}% off ",

                                       ),],
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

            ],
          ),
          // Custom Drawer

        ],
      ),
    );
  }
}
class CarouselController extends GetxController {
  var currentIndex = 0.obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}
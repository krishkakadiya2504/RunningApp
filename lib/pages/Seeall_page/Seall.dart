import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:running/Services/nike/nikservis.dart';

import '../../model/nikemodel/nikeapi.dart';

class Seeallpage extends StatefulWidget {
  var name;

  Seeallpage({required this.name});

  @override
  State<Seeallpage> createState() => _SeeallpageState();
}

class _SeeallpageState extends State<Seeallpage> {
  NikeServices nikeService = NikeServices();
  @override
  Widget build(BuildContext context) {
    var mediaQueryh = MediaQuery.of(context).size.height;
    // var mediaQueryw = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.name}", style: GoogleFonts.akshar()),
          backgroundColor:Color.fromRGBO(46, 184, 197,0.5019607843137255) ,
        ),
        body: Center(
          child: FutureBuilder<List<Shoe>>(
            future: nikeService.getProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error loading data'),
                );
              } else {
                List<Shoe> Shoes = snapshot.data ?? [];

                return GridView.count(
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 2, // Two columns
                  children: List.generate(Shoes.length, (index) {
                    //     // Get the index of the last 5 elements

                    Shoe product1 = Shoes[index];
                    return SizedBox(
                      height: mediaQueryh * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: Column(
                            children: [
                              SizedBox(
                                height: mediaQueryh * 0.1,
                                child: Center(
                                  child: Image(
                                    image: NetworkImage(
                                      product1.imageUrl,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Text(' ${product1.name}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                "\₹${product1.priceInr} ",
                              ),
                              Text(
                                "${product1.details} ",
                                maxLines: 2,
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
      ),
    );
  }
}

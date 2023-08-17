import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:running/controller/CartController.dart';
import 'package:running/pages/profile/profilepage.dart';

import '../../pages/notification/notifictionservices.dart';
import '../../pages/Catogry/Catogry.dart';
import '../../pages/Home/HomePage.dart';
import '../../pages/cart/cart.dart';
import '../../pages/favorite/favorite.dart';
import '../../controller/Homecontroller.dart';


class BottomNavBar extends StatefulWidget {




  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var Controller = Get.put(HomeController());
  // final HomeController controller = Get.find();
  final List<Widget> pages = [
    HomePage(),
    NotificationPage(),
    Categorypage(),
    ProfilScreen(),
  ];

  final List<FluidNavBarIcon> navigationIcons = [

    FluidNavBarIcon(icon: CupertinoIcons.home, extras: {'label': 'Screen 1'}),
    FluidNavBarIcon(icon: Icons.notification_add_outlined, extras: {'label': 'Screen 1'}),
    FluidNavBarIcon(icon: Icons.category_rounded, extras: {'label': 'Screen 2'}),
    FluidNavBarIcon(icon: CupertinoIcons.person_alt, extras: {'label': 'Screen 3'}),
  ];





  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(

        appBar:    AppBar(
          leading: IconButton(onPressed: () =>    Get.to(() => favorite()), icon: Icon(Icons.favorite_border_outlined)),
          backgroundColor:Color.fromRGBO(46, 184, 197,0.5019607843137255) ,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () {
                       Get.to(CartScreen());
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
        bottomNavigationBar: Obx(
              () =>FluidNavBar(
                icons: navigationIcons,
                onChange: (index) => Controller.changePage(index),
                style: FluidNavBarStyle(
                  iconUnselectedForegroundColor: Color.fromRGBO(0, 0, 0, 1.0),
                  iconSelectedForegroundColor: Color.fromRGBO(46, 184, 197, 0.76),
                ),
                defaultIndex: Controller.currentIndex.value,
              ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Obx(
                    () => Center(
                  child: pages.elementAt(Controller.currentIndex.value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

import '../../model/navigation/nb.dart';
import '../intro/intro1.dart';

class splashScreen extends StatefulWidget {
  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    checkConnectivityAndLoginStatus();
  }

  Future<void> checkConnectivityAndLoginStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetDialog();
    } else {
      await checkLoginStatus();
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var islogin = await prefs.getString('islogin');

    await Future.delayed(Duration(seconds: 3), () {
    Get.off(  islogin == null ? intropages() : BottomNavBar());
    });
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No Internet Connection"),
          content: Text("Please connect to the internet and try again."),
          actions: <Widget>[
            TextButton(
              child: Text("Retry"),
              onPressed: () {
                Navigator.of(context).pop();
                checkConnectivityAndLoginStatus();
              },
            ),
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Get.back();
                Navigator.of(context).pop();


              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 100,
                width: MediaQuery.of(context).size.width * 100,
                child: Image.asset(
                  'assets/images/iconcuv1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

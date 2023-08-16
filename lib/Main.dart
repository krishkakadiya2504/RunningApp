import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:running/controller/CartController.dart';
import 'package:running/pages/login/sPlasScreen.dart';
// import 'pages/login/splashScreen.dart';
import 'pages/profile/Setting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: RunningApp(),
    ),
  );
}

class RunningApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController _themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      title: 'SplashScreen',
      debugShowCheckedModeBanner: false,
      theme: _themeController.isDarkMode.value
          ? ThemeData.dark()
          : ThemeData.light(),
      home: splashScreen(),
    ));
  }
}



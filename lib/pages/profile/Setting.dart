import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/Loginpage.dart';

class SettingPage extends StatelessWidget {
  // Function to show language selection dialog
  void showLanguageDialog(BuildContext context) async {
    String selectedLanguage = await showDialog(
      context: context,
      builder: (BuildContext context) {
        String chosenLanguage = "English"; // Default language
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('English'),
                value: 'English',
                groupValue: chosenLanguage,
                onChanged: (value) {
                  chosenLanguage = value!;
                  Get.back(result: chosenLanguage);
                },
              ),
              RadioListTile(
                title: Text('Hindi'),
                value: 'Hindi',
                groupValue: chosenLanguage,
                onChanged: (value) {
                  chosenLanguage = value!;
                  Get.back(result: chosenLanguage);
                },
              ),
              RadioListTile(
                title: Text('Gujarati'),
                value: 'Gujarati',
                groupValue: chosenLanguage,
                onChanged: (value) {
                  chosenLanguage = value!;
                  Get.back(result: chosenLanguage);
                },
              ),
              RadioListTile(
                title: Text('French'),
                value: 'French',
                groupValue: chosenLanguage,
                onChanged: (value) {
                  chosenLanguage = value!;
                  Get.back(result: chosenLanguage);
                },
              ),
            ],
          ),
        );
      },
    );

    // Update the language
    if (selectedLanguage != null) {
      // Save the selected language to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedLanguage', selectedLanguage);

      // Update the app's text language
      // Implement your logic here to change the language
      // You might want to use packages like 'flutter_localizations' for localization
    }
  }
  Future<void> googleSignOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      print("Google Sign Out Successful");

      // Optionally, you can also sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear SharedPreferences data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to the LoginPage
      Get.offAll(
          LoginPage()); // Make sure you import the necessary package for Get.offAll
    } catch (error) {
      print("Error signing out from Google: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Color.fromRGBO(46, 184, 197, 0.5019607843137255),
        ),
        body: Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GetBuilder<ThemeController>(
                builder: (_themeController) {
                  return Obx(
                    () =>  SwitchListTile(
                      title: Text('Dark Mode'),
                      value: _themeController.isDarkMode.value,
                      onChanged: (newValue) {
                        _themeController.toggleTheme();
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Notification Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the notification settings page
                // You can use Get.to() or Navigator.push() here
              },
            ),
            ListTile(
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showLanguageDialog(context);
              },
            ),
            ListTile(
              title: Text('Privacy Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the privacy settings page
                // You can use Get.to() or Navigator.push() here
              },
            ),
            ListTile(
              title: Text('Account Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the account settings page
                // You can use Get.to() or Navigator.push() here
              },
            ),
            ListTile(
              title: Text('Display Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to the display settings page
                // You can use Get.to() or Navigator.push() here
              },
            ),
            SizedBox(
              height: height * 0.4,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (user.providerData
                        .any((userInfo) => userInfo.providerId == 'password')) {
                      // User logged in with email and password
                      await FirebaseAuth.instance.signOut();
                    } else if (user.providerData
                        .any((userInfo) => userInfo.providerId == 'google.com')) {
                      // User logged in with Google
                      await googleSignOut();
                    }
                    // Handle other authentication providers if needed

                    // Clear SharedPreferences data
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();

                    // Navigate to the LoginPage
                    Get.offAll(
                        LoginPage()); // Make sure you import the necessary package for Get.offAll
                  } else {
                    print("No user is currently logged in.");
                  }
                } catch (error) {
                  print("Error logging out: $error");
                }
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                // Customize the button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeTheme(isDarkMode.value ? ThemeData.dark() : ThemeData.light());
  }
}

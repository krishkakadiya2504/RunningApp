import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:running/pages/Home/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/navigation/nb.dart';
import 'Creatuser.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _key = GlobalKey<FormState>();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);

        String userEmail = googleUser.email;
        String userId = _auth.currentUser!.uid;

        // Check if the user's UID exists in the "Registration" collection
        DocumentSnapshot userSnapshot =
        await _firestore.collection('Registration').doc(userId).get();

        if (userSnapshot.exists) {
          Get.offAll(() =>BottomNavBar());
        } else {
          // User document doesn't exist, create it
          await _firestore.collection('Registration').doc(userId).set({
            'name': googleUser.displayName,
            'email': userEmail,
            'registrationTime': DateTime.now(),
            // Other fields as needed

          });
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('islogin', userId);
        // Continue with navigation or other actions
        Get.offAll(() =>BottomNavBar());
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
      Get.snackbar(
        'Google Sign-In Error',
        'An error occurred while signing in with Google. Please try again.',
      );
    }
  }



  void _handleEmailPasswordSignIn() async {
    if (_key.currentState!.validate()) {
      try {
        final String email = emailcontroller.text.trim();
        final String password = passwordcontroller.text;
        final UserCredential userCredential =
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          // Check if the user's UID exists in the Firestore collection
          final String userId = userCredential.user!.uid;
          DocumentSnapshot userSnapshot = await _firestore
              .collection('users')
              .doc(userId)
              .get();

          if (userSnapshot.exists) {
            // User document exists, you can access and use the data
            String name = userSnapshot['name']; // Replace with your field name
            String email = userSnapshot['email']; // Replace with your field name

            print('User Name: $name');
            print('User Email: $email');
          } else {
            // User document doesn't exist, handle accordingly
            print('User document does not exist.');
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('islogin', '${email}');
          // Continue with navigation or other actions
          Get.off(    HomePage(),
          );
        }
      } catch (error) {
        print("Email/Password Sign-In Error: $error");
        Get.snackbar(
          'Sign-In Error',
          'An error occurred during email/password sign-in. Please check your credentials and try again.',
        );
      }
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.idTokenChanges().listen((User? user) {
      if (user == null) {
        // User is signed out
        print('User is signed out.');
        // You can perform any actions you need when the user is signed out
      } else {
        // User is signed in
        print('User is signed in.');
        // You can perform any actions you need when the user is signed in
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => PasswordVisibilityProvider(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(46, 184, 197, 1.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.height * 0.02,
                    ),
                    SizedBox(
                      height: mediaQuery.height * 0.06,
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      child: Lottie.asset(
                        'assets/images/lottie.json',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.height * 0.13,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Hello-Again!",
                              style: TextStyle(
                                fontSize: 30,
                                letterSpacing: 0.50,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Welcome Back You’ve Been Missed!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: mediaQuery.height * 0.35,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            child: Form(
                              key: _key,
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Username/Email',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: emailcontroller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email.';
                                        } else if (!GetUtils.isEmail(value)) {
                                          return 'Please enter a valid email.';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: 'Username/Email',
                                        hintStyle: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: mediaQuery.height * 0.02),
                                    const Text(
                                      "Password",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Consumer<PasswordVisibilityProvider>(
                                      builder: (context, passwordVisibilityProvider, _) {
                                        return TextFormField(
                                          controller: passwordcontroller,
                                          obscureText:
                                          !passwordVisibilityProvider.isPasswordVisible,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your password.';
                                            }
                                            return null;
                                          },
                                          keyboardType:
                                          TextInputType.visiblePassword,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white54,
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            suffix: IconButton(
                                              onPressed: () {
                                                passwordVisibilityProvider
                                                    .togglePasswordVisibility();
                                              },
                                              icon: Icon(
                                                passwordVisibilityProvider
                                                    .isPasswordVisible
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // Forgot Password button callback
                                        },
                                        child: const Text(
                                          'Forgot Password ?',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: mediaQuery.height * 0.02),
                                    Container(
                                      alignment: Alignment.center,
                                      child: GestureDetector(
                                        onTap: _handleEmailPasswordSignIn,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: mediaQuery.height * 0.05,
                                          width: mediaQuery.width * 0.5,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            color: const Color.fromRGBO(
                                                46, 184, 197, 1.0),
                                          ),
                                          child: const Text(
                                            "Sign In",
                                            style: TextStyle(
                                              decoration:
                                              TextDecoration.underline,
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: mediaQuery.height * 0.02),
                                    const Center(
                                      child: Text(
                                        "OR",
                                        style: TextStyle(
                                          decoration:
                                          TextDecoration.underline,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: mediaQuery.height * 0.02),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: _handleGoogleSignIn,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: mediaQuery.height * 0.05,
                                            width: mediaQuery.width * 0.5,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              color: const Color.fromRGBO(
                                                  46, 184, 197, 1.0),
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    height: mediaQuery.height *
                                                        0.02,
                                                    width:
                                                    mediaQuery.width * 0.02),
                                                SvgPicture.asset(
                                                  'assets/images/google.svg',
                                                ),
                                                Text(
                                                  " Sign in with google",
                                                  style: TextStyle(
                                                    decoration:
                                                    TextDecoration.underline,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: mediaQuery.height *
                                                        0.02,
                                                    width:
                                                    mediaQuery.width * 0.02),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: mediaQuery.height * 0.06,
                                        width: mediaQuery.width * 0.02),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Don’t have an account?",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Get.to(Creatuser());
                                          },
                                          child: Text(
                                            "Sign Up for free",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordVisibilityProvider with ChangeNotifier {
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'Loginpage.dart';

class Creatuser extends StatefulWidget {
  @override
  _CreatuserState createState() => _CreatuserState();
}

class _CreatuserState extends State<Creatuser> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _createUserWithEmailAndPassword() async {
    if (_key.currentState!.validate()) {
      try {
        final String name = _nameController.text;
        final String email = _emailController.text;
        final String password = _passwordController.text;

        // Check if the email is already registered
        final QuerySnapshot existingUsers = await _firestore
            .collection('Registration')
            .where('email', isEqualTo: email)
            .get();

        if (existingUsers.docs.isNotEmpty) {
          Get.snackbar(
            'Email Already Registered',
            'The provided email address is already registered. Please use a different email.',
          );
          return;
        }

        UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          final String userId = userCredential.user!.uid;
          await _saveUserDataToFirestore(userId, name, email);
          Get.snackbar(
            'Registration Successful',
            'Welcome, $name! Your account has been created.',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } catch (error) {
        print("User Registration Error: $error");
      }
    }
  }


  Future<void> _saveUserDataToFirestore(String userId, String name, String email) async {
    final DateTime registrationTime = DateTime.now();
    try {
      await _firestore.collection('Registration').doc(userId).set({
        'name': name,
        'email': email,
        'registrationTime': registrationTime,
      });
    } catch (error) {
      print("Firestore Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return SafeArea(
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
                            "Create Account",
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 0.50,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Let’s Create Account Together",
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
                                    "Your Username",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Username.';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Username",
                                      hintStyle: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: mediaQuery.height * 0.01),
                                  const Text(
                                    'Email Address',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email.';
                                      }
                                      if (!value.isEmail) {
                                        return 'Please enter a valid email.';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: mediaQuery.height * 0.01),
                                  const Text(
                                    "Password",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password.';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: mediaQuery.height * 0.01),
                                  GestureDetector(
                                    onTap: _createUserWithEmailAndPassword,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: mediaQuery.height * 0.05,
                                        width: mediaQuery.width * 0.5,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          color: const Color.fromRGBO(
                                            46,
                                            184,
                                            197,
                                            1.0,
                                          ),
                                        ),
                                        child: const Text(
                                          "Submit",
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Already have an account?",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "Sign in",
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
    );
  }
}

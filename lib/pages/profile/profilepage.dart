import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../controller/profilecantroller.dart';
import 'Setting.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {

   RxBool isEditing = false.obs;
  var _key = GlobalKey();

  var namecontroller = TextEditingController();

  var emailcontroller = TextEditingController();

  var phonecontroller = TextEditingController();

  final ProfileController profileController = Get.put(ProfileController());

  var Biocontrol = TextEditingController();

  var ProfileImageUrl = ''.obs;

  var name;


  Future<void> updateProfileData() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        final userId = user.uid;

        // Update user data in Firestore
        await FirebaseFirestore.instance.collection('Registration').doc(userId).set(

        {
            'name': namecontroller.text,
            'email': emailcontroller.text,
            'phonenumber': phonecontroller.text,
            'biodata': Biocontrol.text,
          },
          SetOptions(merge: true), // Merge new data with existing data
        );

        isEditing.value = false; // Set isEditing to false after saving

        // Fetch and set the data again after updating
        await fetchUserData();
      }
    } catch (error) {
      print("Error updating user data: $error");
      // Handle the error
    }
  }


  Future<void> saveImageAndUpdateProfile() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null && profileController.pickedImage.value != null) {
        final userId = user.uid;

        // Upload the image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('$userId')
            .child('$userId.jpg');

        final uploadTask = storageRef.putFile(profileController.pickedImage.value!);
        final storageSnapshot = await uploadTask.whenComplete(() {});

        final imageUrl = await storageSnapshot.ref.getDownloadURL();

        // Update the user's profile image URL in Firestore using set with merge options
        await FirebaseFirestore.instance.collection('Registration').doc(userId).set(
          {
            'profileImageUrl': imageUrl,
          },
          SetOptions(merge: true), // Merge new data with existing data
        );

        // Save the image URL in the ProfileImageUrl variable
        ProfileImageUrl.value = imageUrl;
        // Show a success message or perform other actions
      }
    } catch (error) {
      print("Error saving image and updating profile: $error");
      // Show an error message or handle the error
    }
  }


  @override
  void initState() {
    super.initState();
    // Call a function to fetch user data from Firestore
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final User? user = _auth.currentUser;

      if (user != null) {
        final userId = user.uid;

        // Fetch user data from Firestore
        final userData = await FirebaseFirestore.instance
            .collection('Registration')
            .doc(userId)
            .get();

        // Set the fetched data in the respective controllers or variables
        namecontroller.text
    = userData['name'];
        emailcontroller.text = userData['email'];
        ProfileImageUrl.value = userData['profileImageUrl'];
        phonecontroller.text = userData['phonenumber'];
        Biocontrol.text= userData['biodata'];
        // You might need to update the field names above to match your Firestore document structure
      }

    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery
    //     .of(context)
    //     .size
    //     .width;
    double height = MediaQuery.of(context).size.height;
    var mediaQuery = MediaQuery.of(context).size;
    return Center(
      child: Stack(
        children: [
          SingleChildScrollView(
            // physics: BouncingScrollPhysics(),
            child: Container(
              height: height * 0.9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double innerHeight = constraints.maxHeight;
                  double innerWidth = constraints.maxWidth;
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: height * 0.12,
                              ),
                              Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [

                                        Color.fromRGBO(
                                            41, 41, 106, 0.49411764705882355),
                                        Color.fromRGBO(107, 212, 222, 1.0),
                                      ],
                                      begin: FractionalOffset.bottomCenter,
                                      end: FractionalOffset.topCenter,
                                    ),

                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20))),
                                height: height * 0.7,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: height * 0.2,
                                ),
                                const Text(
                                  'Profile', //name
                                  style: TextStyle(

                                      fontFamily: 'Nunito',
                                      fontSize: 37,
                                      fontWeight: FontWeight.bold),
                                ),
                                Form(
                                  key: _key,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text("Full Name",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            )),
                                        TextFormField(
                                            style:  TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            readOnly: !isEditing.value,
                                            controller: namecontroller,
                                            decoration: const InputDecoration(
                                              hintStyle: TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),

                                            ),
                                          ),

                                        SizedBox(height: mediaQuery.height * 0.01),

                                        const Text('Email Address',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            )),
                                         TextFormField(
                                            style:  TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            readOnly: true,
                                            controller: emailcontroller,
                                            decoration: const InputDecoration(
                                              hintText: 'Email',
                                              hintStyle: TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),

                                            ),
                                          ),

                                        SizedBox(height: mediaQuery.height * 0.01),

                                        const Text('Phone',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            )),


                                          TextFormField(
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            readOnly: !isEditing.value,
                                            controller: phonecontroller,
                                            decoration: const InputDecoration(
                                              hintText: '+91',
                                              hintStyle: TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),

                                            ),
                                          ),


                                        SizedBox(height: mediaQuery.height * 0.02),

                                        const Text('Bio',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            )),
                                       TextFormField(

                                            readOnly: !isEditing.value,
                                            maxLength: 30,
                                            controller: Biocontrol,
                                            style:  TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            decoration: const InputDecoration(

                                              hintText: 'Bio',
                                              hintStyle: TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,

                                              ),

                                            ),
                                          ),

                                        // SizedBox(height: mediaQuery.height * 0.01),

                                        SizedBox(
                                            height: mediaQuery.height * 0.01),
                                        Obx(

                                          () =>  GestureDetector(
                                            onTap: () {
                                              if (isEditing.value) {
                                                updateProfileData(); // Call the update function when in edit mode
                                              } else {
                                                isEditing.value = true; // Enter edit mode
                                              }
                  },

                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Container(
                                                alignment: Alignment.center,
                                                height:
                                                    mediaQuery.height * 0.05,
                                                width: mediaQuery.width * 0.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: const Color.fromRGBO(
                                                      46, 184, 197, 1.0),
                                                ),
                                                child:  Text(
                                                    isEditing.value ? 'Done' : 'Add on',
                                                    style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ),
                                            ),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 80,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => Get.to(SettingPage()),
                              child: const Icon(
                                AntDesign.setting,
                                // color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          Positioned(
                            top: innerHeight * 0.01,
                            left: 0,
                            right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              child:Obx(() {
                                final imageUrl = ProfileImageUrl.value;
                                if (imageUrl != null && imageUrl.isNotEmpty) {
                                  return CircleAvatar(
                                    backgroundColor: Colors.black,
                                    maxRadius: innerHeight * 0.1,
                                    backgroundImage: NetworkImage(imageUrl),
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundImage: const NetworkImage(
                                        'https://cdn.vectorstock.com/i/preview-1x/05/25/user-profile-shadow-symbol-icon-isolated-vector-46940525.jpg'),
                                    backgroundColor: Colors.black,
                                    maxRadius: innerHeight * 0.1,
                                  );
                                }
                              }),

                            ),
                          ),
                          Positioned(
                            top: innerHeight * 0.18,
                            left: innerWidth * 0.4,
                            child: FilledButton(
                              onPressed: () {
                                profileController.pickImage().whenComplete(() =>    saveImageAndUpdateProfile());
                              },
                              child: const Icon(Icons.camera_enhance),
                              style: ButtonStyle(
                                backgroundColor: const MaterialStatePropertyAll( Color.fromRGBO(
                                    41, 41, 106, 1.0),),
                                fixedSize: const MaterialStatePropertyAll(Size(10,10)),
                                iconSize: MaterialStateProperty.all(25),
                                shape: MaterialStateProperty.all(
                                  const CircleBorder(
                                      side: BorderSide(
                                          style: BorderStyle.none)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}



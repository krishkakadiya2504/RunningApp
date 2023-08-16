// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../controller/firebase.dart';
// import '../../model/navigation/nb.dart';
//
// class UserDetail extends StatefulWidget {
//   const UserDetail({super.key});
//
//   @override
//   State<UserDetail> createState() => _UserDetailState();
// }
//
// class _UserDetailState extends State<UserDetail> {
//   var Controller = Get.put(UserDetailController());
//
//   var _key = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     MediaQueryData mediaQueryData = MediaQuery.of(context);
//     var _width = mediaQueryData.size.width;
//     var _height = mediaQueryData.size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue[900],
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               ('Running'),
//               style: GoogleFonts.frankRuhlLibre(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Image.asset(
//               'assets/images/iconcuv1.png',
//               height: _height * 0.5,
//               width: _width * 0.13,
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _key,
//           child: Column(
//             children: [
//               SizedBox(
//                 height: _height * 0.03,
//               ),
//               Text(
//                 'Please Enter User Details',
//                 style: TextStyle(
//                   fontSize: _height * 0.03,
//                 ),
//               ),
//               SizedBox(
//                 height: _height * 0.03,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(labelText: 'First Name'),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please Enter Your First Name';
//                     }
//                   },
//                   controller: Controller.FirstNameController,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(labelText: 'Last Name'),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please Enter Your Last Name';
//                     }
//                   },
//                   controller: Controller.LastNameController,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(labelText: 'Mobile Number'),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please Enter Your Mobile Number';
//                     }
//                   },
//                   controller: Controller.MobileNumberController,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(labelText: 'Email ID'),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please Enter Your Email Id';
//                     }
//                   },
//                   controller: Controller.EmailIdController,
//                 ),
//               ),
//               SizedBox(
//                 height: _height * 0.05,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStatePropertyAll(
//                           Colors.blue[900],
//                         ),
//                         fixedSize: MaterialStatePropertyAll(
//                             Size(_width * 0.35, _height * 0.05))),
//                     onPressed: () async {
//                       if (_key.currentState!.validate()) {
//                         SharedPreferences prefs =
//                         await SharedPreferences.getInstance();
//                         await prefs.setString('phone', Controller.MobileNumberController.text);
//                         Get.offAll(
//                           BottomNavBar(),
//                         );
//                       }
//                       return Controller.storeUserData(
//                         FirstName: Controller.FirstNameController.text,
//                         LastName: Controller.LastNameController.text,
//                         EmailID: Controller.EmailIdController.text,
//                         MobileNumber: Controller.MobileNumberController.text,
//                       );
//                     },
//                     child: Text(
//                       'Submit',
//                       style: TextStyle(
//                         fontSize: _height * 0.018,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor: MaterialStatePropertyAll(
//                           Colors.blue[900],
//                         ),
//                         fixedSize: MaterialStatePropertyAll(
//                             Size(_width * 0.35, _height * 0.05))),
//                     onPressed: () {
//                       Get.offAll(
//                         BottomNavBar(),
//                       );
//                     },
//                     child: Text(
//                       'Maybe Later',
//                       style: TextStyle(
//                         fontSize: _height * 0.018,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

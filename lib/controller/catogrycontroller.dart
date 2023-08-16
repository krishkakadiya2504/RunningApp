//
// import 'package:get/get.dart';
// import 'package:running/Services/nike/nikservis.dart';
// import 'package:running/model/nikemodel/nikeapi.dart';
//
// class catogrycontroller extends GetxController {
//   var shoes = <Shoe>[].obs;
//
//   @override
//   void onInit() {
//     fetchShoes();
//     super.onInit();
//   }
//
//   void fetchShoes() async {
//     try {
//       var shoeService = ShoeService();
//       shoes.value = await shoeService.getShoes();
//     } catch (e) {
//       // Handle error, if any.
//       print('Error: $e');
//     }
//   }
// }
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  RxString bio = ''.obs;
  RxString phone = ''.obs;
  var ProfileImageUrl = ''.obs;
  Rx<File?> pickedImage = Rx<File?>(null);

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (picked != null) {
      pickedImage.value = File(picked.path); // Use File class here
    }
  }
}


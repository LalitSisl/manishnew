import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController title = TextEditingController();
  RxBool uploaded = false.obs;

  Future<XFile?> uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image!.path.isNotEmpty) {
      uploaded.value = true;
    }
    return image;
  }
}

import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../common/utils/utils.dart';

class SelectImageProvider extends ChangeNotifier {
  File? image;

  Future<void> selectImage(context) async {
    image = await pickImageFromGallery(context);
    notifyListeners();
  }

  void clearImage() async {
    image = null;
    notifyListeners();
  }

  Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        image = File(pickedImage.path);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return image;
  }
}

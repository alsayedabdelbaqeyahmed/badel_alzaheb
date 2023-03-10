import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File? image;
Future<void> getImage({required ImageSource imageSource}) async {
  PickedFile? pickedFile = await ImagePicker().getImage(source: imageSource);
  if (pickedFile != null) {
    image = File(pickedFile.path);
  }
}

Future<void> myDialogueBox(context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => Builder(builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("كاميرا"),
                onTap: () {
                  getImage(
                    imageSource: ImageSource.camera,
                  );
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.album),
                title: Text("الاستديو"),
                onTap: () {
                  getImage(
                    imageSource: ImageSource.gallery,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    }),
    // builder: (BuildContext context) {},
  );
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

// import 'package:form_field_validator/form_field_validator.dart';
final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
void showSnackBar({required BuildContext context, required String content}) {
  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  } catch (e) {
    print('showSnackBar----------: $e');
  }
}

Future<void> msgBox(BuildContext context, String content) async {
  try {
    await ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  } catch (e) {
    print('msgBox----------: $e');
  }
}

// final passwordValidator = MultiValidator(
//   [
//     RequiredValidator(errorText: "كلمة المرور مطلوبة"),
//     MinLengthValidator(8, errorText: "يجب ان تكون كلمة المرور أكبر من 8 أرقام"),
//     // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
//     PatternValidator(r'([A-z]|[0-9])\w+',
//         errorText: "يجب ان تحتوي كلمة المرور على ارقام واحرف")
//   ],
// );

Widget get spaceH10 {
  return SizedBox(
    height: 10,
  );
}

Widget get spaceH {
  return SizedBox(
    height: 20,
  );
}

Widget get spaceW {
  return SizedBox(
    width: 20,
  );
}

Widget get spaceW10 {
  return SizedBox(
    width: 10,
  );
}

Future<void> launchInBrowser(String url) async {
  try {
    if (!await launch(
      url,
      // forceSafariVC: false,
      // forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
      enableJavaScript: true,
    )) {
      throw 'Could not launch $url';
    }
    // Uri uri = Uri.parse(url);
    // if (!await launchUrl(
    //   uri,
    //   // mode: LaunchMode.platformDefault,
    //   // forceSafariVC: false,
    //   // forceWebView: false,
    //   // headers: <String, String>{'my_header_key': 'my_header_value'},
    // )) {
    //   throw 'Could not launch $url';
    // }
  } catch (e) {
    print(e);
  }
}

Future<void> launchInBrowserNew(String headers, String url) async {
  try {
    url = url.replaceAll('http://', '').replaceAll('https://', '');
    Uri uri = Uri.https(
      headers,
      url,
    ); //path: 'headers/');
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  } catch (e) {
    print(e);
  }
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

Future<File?> pickVideoFromGallery(BuildContext context) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}

// Future<GiphyGif?> pickGIF(BuildContext context) async {
//   GiphyGif? gif;
//   try {
//     gif = await Giphy.getGif(
//       context: context,
//       apiKey: 'pwXu0t7iuNVm8VO5bgND2NzwCpVH9S0F',
//     );
//   } catch (e) {
//     showSnackBar(context: context, content: e.toString());
//   }
//   return gif;
// }

Future<bool?> msgShow(
  msg,
) async {
  try {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: appBarColor,
      textColor: backgroundColor,
      fontSize: 16.0,
    );
  } catch (e) {
    print('showToast----:$e');
    return Future.error(e);
  }
}

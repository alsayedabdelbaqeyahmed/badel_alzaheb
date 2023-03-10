// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../controller/auth_controller.dart';

final _formKey = GlobalKey<FormState>();
void showDailogPasswordChange(context, WidgetRef ref) {
  String? txtPassword = '';
  String? txtPasswordOld = '';
  String? conform_password;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('تغيير كلمة المرور'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => txtPasswordOld = newValue,
                onChanged: (value) {
                  txtPasswordOld = value;
                },
                // validator: passwordValidator,
                decoration: InputDecoration(
                  labelText: "كلمة المرورالقديمة",
                  hintText: "************",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              spaceH10,
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => txtPassword = newValue,
                onChanged: (value) {
                  txtPassword = value;
                },
                // validator: passwordValidator,
                decoration: InputDecoration(
                  labelText: "كلمة المرور الجديدة",
                  hintText: "************",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              spaceH,
              TextFormField(
                obscureText: true,
                onSaved: (newValue) => conform_password = newValue,
                onChanged: (value) {
                  conform_password = value;
                },
                // validator: (pass) =>
                //     MatchValidator(errorText: "كلمة المرور مختلفة")
                //         .validateMatch(pass!, txtPassword!),
                decoration: InputDecoration(
                  labelText: "تحقق كلمة المرور",
                  hintText: "************",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              child: Text(
                'تغييــــــر',
              ),
              onPressed: () async {
                try {
                  if (txtPasswordOld!.isEmpty) {
                    showSnackBar(
                        context: context,
                        content: 'حقل كلمة المرور السابقة فارغ');
                    return;
                  }
                  if (txtPassword != null && conform_password != null) {
                    if (txtPassword!.trim() == conform_password!.trim() &&
                        txtPassword!.isNotEmpty &&
                        conform_password!.isNotEmpty) {
                      ref.read(authControllerProvider).changePassword(
                          context, txtPasswordOld!, txtPassword);

                      Navigator.pop(context);
                      showSnackBar(
                          context: context, content: 'تم التعديل بنجاح');
                    } else {
                      showSnackBar(
                          context: context,
                          content: 'كلمة المرور غير متطابقتين');
                    }

                    //
                  } else {
                    showSnackBar(
                        context: context, content: 'لا يوجد كلمة مرور مدخلة');
                  }
                } catch (e) {
                  print('error---$e');
                  showSnackBar(context: context, content: '$e');
                }
              },
            ),
          ),
        ],
      );
    },
  );
}

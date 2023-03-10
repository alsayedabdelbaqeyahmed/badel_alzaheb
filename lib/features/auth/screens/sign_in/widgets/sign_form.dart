import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/components/custom_surfix_icon.dart';
import 'package:myproject/helper/tools.dart';
import '../../../../../routes.dart';
import '/common/utils/utils.dart';
import '/size_config.dart';
import '/widgets/btn_loading_widget.dart';
import '../../../controller/auth_controller.dart';

class SignForm extends ConsumerStatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends ConsumerState<SignForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool? remember = false;
  bool isLoading = false;
  bool isLoadingGoogle = false;
  bool isLoadingApple = false;
  //
  @override
  Widget build(BuildContext context) {
    //fillUser();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUserFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          // Row(
          //   children: [
          //     Checkbox(
          //       value: remember,
          //       activeColor: primaryColor,
          //       onChanged: (value) {
          //         setState(() {
          //           remember = value;
          //         });
          //       },
          //     ),
          //     Text("سياسة الخصوصية"),
          //     Spacer(),
          //     GestureDetector(
          //       onTap: () =>
          //           Navigator.pushNamed(context, forgot_password_screen),
          //       child: Text(
          //         "نسيت كلمة المرور؟",
          //         style: TextStyle(decoration: TextDecoration.underline),
          //       ),
          //     ),
          //   ],
          // ),
          SizedBox(height: (20)),
          BtnLoadingWidget(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                try {
                  setState(() {
                    isLoading = true;
                  });
                  var email = username.text.trim();

                  if (username.text.isNotEmpty && password.text.isNotEmpty) {
                    bool isDone =
                        await ref.read(authControllerProvider).signInWithEmail(
                              context,
                              '${email}',
                              password.text,
                            );
                    await ref.refresh(userDataAuthProvider);
                    setState(() {
                      isLoading = false;
                    });
                  } else {
                    showSnackBar(
                        context: context,
                        content:
                            'رجاء املأ جميع الحقول'); //Fill out all the fields

                    setState(() {
                      isLoading = false;
                    });
                  }

                  //
                } catch (e) {
                  print(e);
                  if (e.toString().trim() ==
                      "RangeError (index): Invalid value: Valid value range is empty: 0") {
                    showPanleMsg(context, 'المستخدم غير موجود');
                  }
                  setState(() {
                    isLoading = false;
                  });
                  Msgcatch(context, e);
                }
              }
            },
            isLoading: isLoading,
            title: 'تسجيل الدخول',
          ),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, forgot_password_screen),
                child: Text(
                  "نسيت كلمة المرور؟",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          BtnLoadingWidget(
            isLoading: isLoadingGoogle,
            title: 'متابعة عبر جوجل',
            icon: 'google.png',
            onPressed: () async {
              try {
                setState(() {
                  isLoadingGoogle = true;
                });
                await ref
                    .read(authControllerProvider)
                    .signInWithGoogle(context);
                setState(() {
                  isLoadingGoogle = false;
                });
              } catch (e) {
                print(e);
              }
            },
          ),
          SizedBox(height: getProportionateScreenHeight(20)),
          if (Platform.isIOS)
            BtnLoadingWidget(
              isLoading: isLoadingGoogle,
              title: 'متابعة عبر Apple',
              icon: 'apple.png',
              onPressed: () async {
                try {
                  setState(() {
                    isLoadingApple = true;
                  });
                  await ref
                      .read(authControllerProvider)
                      .signInWithApple(context);
                  // await ref.refresh(userDataAuthProvider);
                  setState(() {
                    isLoadingApple = false;
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      // onSaved: (newValue) => password = newValue,
      // onChanged: (value) {
      //   password = value;
      // },
      controller: password,
      validator: passwordValidator,
      // ignore: prefer_const_constructors
      decoration: InputDecoration(
        labelText: "كلمة المرور",
        hintText: "***********",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: CustomSurffixIconWidget(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildUserFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => username.text = newValue!,
      // onChanged: (value) {},
      controller: username,
      validator: EmailValidator(errorText: 'البريد الإلكتروني غير صحيح'),
      decoration: InputDecoration(
        labelText: "البريد",
        hintText: "example@gmail.com",
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: CustomSurffixIconWidget(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

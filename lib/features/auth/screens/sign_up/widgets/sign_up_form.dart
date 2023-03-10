// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myproject/components/custom_surfix_icon.dart';
import 'package:myproject/components/default_button.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/helper/tools.dart';

// import '../../../../../common/utils/utils.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../models/user_model.dart';
import '../../../../../widgets/btn_loading_widget.dart';
import '../../../controller/auth_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final txtCtrEmail = TextEditingController();
  final phoneNumberControll = TextEditingController();
  final passwordController = TextEditingController();
  String? txtUsername;
  String? txtPassword;
  String? conform_password;
  bool remember = false;
  bool isLoading = false;

  String? txtPhoneNumber;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          spaceH,
          buildPhoneFormField(),
          spaceH,
          buildPasswordFormField(),
          spaceH,
          buildConformPassFormField(),
          //FormError(errors: errors),
          spaceH,
          BtnLoadingWidget(
            title: "تسجيـــل",
            isLoading: isLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                if ((!txtPhoneNumber.toString().contains('05') &&
                        !txtPhoneNumber.toString().contains('5')) ||
                    txtPhoneNumber.toString().length < 9) {
                  showSnackBar(
                      context: context, content: 'رقم الهاتف ليس صحيح');
                  return;
                }

                try {
                  Map<String, dynamic> m = {
                    colUsName: txtPhoneNumber,
                    colphoneNumber: txtPhoneNumber,
                    colAddress: '',
                    colEmaile: txtCtrEmail.text,
                    colIsActive: true,
                    colCityId: '',
                  };
                  setState(() {
                    isLoading = true;
                  });

                  Future.delayed(Duration(seconds: 1)).then((value) {});
                  String email = txtCtrEmail.text.trim();
                  // String password = passwordController.text.trim();

                  if (email.isNotEmpty && passwordController.text.isNotEmpty) {
                    bool isDone =
                        await ref.read(authControllerProvider).signupWithEmail(
                              context,
                              m,
                              '$email',
                              passwordController.text,
                            );
                    await ref.refresh(userDataAuthProvider);
                    setState(() {
                      isLoading = isDone;
                    });
                  } else {
                    showSnackBar(
                        context: context,
                        content: 'املأ جميع الحقول'); //Fill out all the fields

                    setState(() {
                      isLoading = false;
                    });
                  }

                  setState(() {
                    isLoading = false;
                  });
                  // msgBox(context, 'تم التسجيل بنجاح');
                  //---
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                  Msgcatch(context, e);
                }
              }
            },
          ),

          spaceH10,
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        conform_password = value;
      },
      validator: (pass) => MatchValidator(errorText: "كلمة المرور مختلفة")
          .validateMatch(pass!, txtPassword ?? ''),
      decoration: InputDecoration(
        labelText: "تحقق كلمة المرور",
        hintText: "************",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIconWidget(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      controller: passwordController,
      onSaved: (newValue) => txtPassword = newValue,
      onChanged: (value) {
        txtPassword = value;
      },
      validator: passwordValidator,
      decoration: InputDecoration(
        labelText: "كلمة المرور",
        hintText: "************",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIconWidget(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: txtCtrEmail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => txtUsername = newValue,
      onChanged: (value) {
        txtUsername = value;
      },
      validator: EmailValidator(errorText: 'البريد الإلكتروني خطا'),
      decoration: InputDecoration(
        labelText: "البريد",
        hintText: "example@gmail.com",
        // helperText: 'يجب أن يكون انجليزي لايحتوي على مسافات',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIconWidget(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      controller: phoneNumberControll,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        txtPhoneNumber = value;
      },
      validator: msgValidator(),
      decoration: InputDecoration(
        labelText: "رقم الجوال",
        hintText: "567891234",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(left: 11, top: 13),
          child: Text('+966'),
        ),
        // suffixIcon: CustomSurffixIconWidget(svgIcon: "assets/icons/Call.svg"),
      ),
      onSaved: (phoneNumber) => txtPhoneNumber = phoneNumber!,
    );
  }
}

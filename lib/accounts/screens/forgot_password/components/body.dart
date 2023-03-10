import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/components/custom_surfix_icon.dart';
import 'package:myproject/components/default_button.dart';
import 'package:myproject/components/no_account_text_widget.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';
import 'package:myproject/widgets/btn_loading_widget.dart';

import '/size_config.dart';

class Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Text(
              "هل نسيت كلمة السر",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(28),
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            spaceH10,
            Text(
              "يرجى إدخال البريد الخاص بك \nوسنرسل لك رمز التحقق ",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.1),
            ForgotPassForm(),
            // spaceH,
            // spaceH,
            Spacer(),
            // TextButton(
            //   onPressed: () {
            //     // launchInBrowser('https://www.facebook.com/ysrapps1');
            //   },
            //   child: Text('الإبلاغ عن مشلكة'),
            // ),
            // TextButton(
            //   onPressed: () {
            //     // launchInBrowser('https://www.facebook.com/ysrapps1');
            //   },
            //   child: Image.asset(
            //     'assets/images/logo.png',
            //     fit: BoxFit.cover,
            //     height: 30,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ForgotPassForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();

  String? email;
  bool isLoading = false;
  @override
  Widget build(BuildContext context, ref) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              email = value;
              /*if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kEmailNullError);
                });
              } else if (emailValidatorRegExp.hasMatch(value) &&
                  errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.remove(kInvalidEmailError);
                });
              }*/
            },
            validator: EmailValidator(
              errorText: 'البريد الإلكتروني غير صحيح',
            ), // (value) {
            /*if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }*/
            //   return null;
            // },
            decoration: InputDecoration(
              labelText: "البريد",
              hintText: "email@gmail.com",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon:
                  CustomSurffixIconWidget(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          spaceH,
          //FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          BtnLoadingWidget(
            isLoading: isLoading,
            title: "ارســال",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Do what you want to do
                if (email != null && email!.isNotEmpty)
                  await ref
                      .read(authControllerProvider)
                      .resetWhiEmail(context, email!);
                else
                  msgBox(context, 'تاكد من كتابة البريد الإلكتروني');
              }
            },
          ),
          spaceH10,
          NoAccountTextWidget(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '/size_config.dart';

// const kPrimaryColor = Color(0xFF17A4BA);
Color primaryColor = Color(0xFF210B0B);
const kPrimaryLightColor = Color(0xFFF4F4F4);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFF17A4BA)],
);
const secondaryColor = Color(0xFF979797);
const textColor = Color(0xFF757575);
const greyColor = Color(0xFF979797);

const kDefaultPaddin = 20.0;

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: textColor),
  );
}

// التحقق من كلمة المرور
final passwordValidator = MultiValidator(
  [
    RequiredValidator(errorText: "كلمة المرور مطلوبة"),
    MinLengthValidator(8, errorText: "يجب ان تكون كلمة المرور أكبر من 8 أرقام"),
    // PatternValidator(r'/^[a-z-0-9]{8,}$/', // old reg r(?=.*?[#?!@$%^&*-])
    //     errorText: "يجب ان تحتوي كلمة المرور على ارقام واحرف")
  ],
);
// '/^
//   (?=.*\d)          // should contain at least one digit
//   (?=.*[a-z])       // should contain at least one lower case
//   (?=.*[A-Z])       // should contain at least one upper case
//   [a-zA-Z0-9]{8,}   // should contain at least 8 from the mentioned characters
// $/'
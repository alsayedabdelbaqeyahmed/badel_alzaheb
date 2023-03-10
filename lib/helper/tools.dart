import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

RequiredValidator msgValidator() {
  return RequiredValidator(errorText: 'خطأ: هذا الحقل مطلوب');
}

RequiredValidator requiredVal(msg) {
  return RequiredValidator(errorText: 'خطأ: هذا الحقل مطلوب');
}

// SizedBox spaceH() {
//   return SizedBox(height: 25);
// }

// SizedBox spaceH10() {
//   return SizedBox(height: 10);
// }

SizedBox spaceW() {
  return SizedBox(width: 20);
}

/// اظهار نافذة صغيره اسفل الشاشة للرسائل التوضيحية
void showPanleMsg(context, Msg) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: Text('$Msg'),
        );
      });
}

const ivalidEmail =
    "[firebase_auth/invalid-email] The email address is badly formatted.";
const noUserName =
    "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.";
const errorNetWork =
    " [firebase_auth/network-request-failed] A network error (such as timeout, interrupted connection or unreachable host) has occurred.";

void Msgcatch(context, e) {
  e = e.toString().trim();
  if (e == ivalidEmail.trim()) showPanleMsg(context, 'البريد غير صالح');
  if (e == noUserName.trim())
    showPanleMsg(context, 'لا يوجد مستخدم بهذا الاسم');
  if (e == errorNetWork.trim())
    showPanleMsg(context, 'حدث خطأ في الشبكة');
  else
    showPanleMsg(context, 'خطأ: $e');
  print('$e');
}

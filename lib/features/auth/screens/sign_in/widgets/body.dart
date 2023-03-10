import 'package:flutter/material.dart';
import 'package:myproject/accounts/screens/profile/components/company_pic.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/components/no_account_text_widget.dart';
import 'package:myproject/helper/tools.dart';

import '../../../../../size_config.dart';
import 'sign_form.dart';

class BodySignInWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                spaceH,
                CompanyPic(),
                // Text(
                //   "مرحبا بعودتك",
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: getProportionateScreenWidth(28),
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // Text(
                //   "سجّل الدخول باستخدام رقم الهاتف وكلمة المرور.",
                //   textAlign: TextAlign.center,
                // ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                spaceH,
                NoAccountTextWidget(),
                spaceH,
                spaceH,
                // spaceH,
                // FollowusWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

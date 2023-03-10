import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/infoapp.dart';

import '/constants.dart';
import '/size_config.dart';

import 'sign_up_form.dart';

class Body extends StatelessWidget {
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
                SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("تسجيل حساب", style: headingStyle),

                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignUpForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),

                SizedBox(height: getProportionateScreenHeight(20)),

                Text(
                  'من خلال الاستمرار فإنك تأكد موافقتك على سياسة الخصوصية الخاصة بنا',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
                TextButton(
                  onPressed: () {
                    launchInBrowser(privet_policy_url);
                  },
                  child: Text('سياسة الخصوصية'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

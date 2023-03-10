import 'package:flutter/material.dart';
import 'package:myproject/routes.dart';

import '../constants.dart';
import '../size_config.dart';

class NoAccountTextWidget extends StatelessWidget {
  const NoAccountTextWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "ليس لديك حساب؟ ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, sign_up_screen),
          child: Text(
            "سجل مجانا",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16), color: primaryColor),
          ),
        ),
      ],
    );
  }
}

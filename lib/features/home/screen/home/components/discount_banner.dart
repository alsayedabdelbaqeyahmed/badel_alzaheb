import 'package:flutter/material.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/helper/tools.dart';

import '../../../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(10)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(30),
      ),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "خدمة الشحن",
            style: TextStyle(color: Colors.white),
          ),
          spaceH10,
          Text(
            "إلى كافة مدن المملكة العربية السعودية.",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(14.5),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myproject/features/home/screen/home/components/icon_btn_with_counter.dart';
import 'package:myproject/features/orders/screens/cart/cart_order_details_screen.dart';

import '../constants.dart';
import '../routes.dart';

AppBar appbarBackWidget(BuildContext context, [String title = '']) {
  return AppBar(
    backgroundColor: kPrimaryLightColor,
    elevation: 0,
    title: Text(
      '$title',
      style: TextStyle(color: textColor),
    ),
    leading: IconButton(
      icon: SvgPicture.asset(
        'assets/icons/back.svg',
        color: primaryColor,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    actions: <Widget>[
      IconBtnWithCounter(
        svgSrc: "assets/icons/Cart Icon.svg",
        onTap: () =>
            Navigator.pushNamed(context, CartOrderDetailsScreen.routeName),
      ),
      SizedBox(width: kDefaultPaddin / 4)
    ],
  );
}

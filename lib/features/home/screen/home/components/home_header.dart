import 'package:flutter/material.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/features/orders/screens/cart/cart_order_details_screen.dart';
import 'package:myproject/infoapp.dart';
import 'package:myproject/routes.dart';
import 'package:myproject/widgets/search_bar_widget.dart';

import '../../../../../size_config.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: SizeConfig.screenWidth * 0.6,
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 9),
                  child: CircleAvatar(
                    backgroundImage: Image.asset(
                      "assets/images/logo.png",
                      cacheHeight: 50,
                      cacheWidth: 50,
                    ).image,
                    radius: 23,
                  ),
                ),
                Text(
                  '$appName',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Cart Icon.svg",
            onTap: () =>
                Navigator.pushNamed(context, CartOrderDetailsScreen.routeName),
          ),
          IconBtnWithCounter(
            svgSrc: "assets/icons/Search Icon.svg",
            // numOfitem: 0,
            onTap: () {
              msgShow(
                'البحث متقدم: يمكنك البحث بالاسم او الوصف او السعر او نسبة الخصم ...',
              );
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(),
              );
            },
          ),
        ],
      ),
    );
  }
}

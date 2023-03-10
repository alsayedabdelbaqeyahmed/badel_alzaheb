import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myproject/common/utils/colors.dart';

class AddToCartWidget extends StatelessWidget {
  void Function()? onPressed;
  AddToCartWidget({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Container(
        margin: EdgeInsets.only(right: kDefaultPaddin - 5),
        // width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          // border: Border.all(
          //     // color: ,
          //     ),
        ),
        child: TextButton.icon(
          icon: SvgPicture.asset(
            "assets/icons/add_to_cart.svg",
          ),
          onPressed: onPressed,
          label: Text('إضافة للسلة'),
        ),
      ),
    );
  }
}

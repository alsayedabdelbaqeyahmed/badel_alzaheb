import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../size_config.dart';

class AddCartWidget extends StatelessWidget {
  AddCartWidget({
    Key? key,
    this.onAddCart,
    required this.isLoading,
    // this.isFavourite,
  }) : super(key: key);
  final Function()? onAddCart;
  final bool isFavourite = false;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onAddCart,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.all(getProportionateScreenWidth(7)),
        height: getProportionateScreenWidth(28),
        width: getProportionateScreenWidth(28),
        decoration: BoxDecoration(
          color: isFavourite
              ? primaryColor.withOpacity(0.15)
              : secondaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: isLoading == false
            ? SvgPicture.asset(
                "assets/icons/add_to_cart.svg",
                color: isFavourite ? primaryColor : Color(0xFFFF4848),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

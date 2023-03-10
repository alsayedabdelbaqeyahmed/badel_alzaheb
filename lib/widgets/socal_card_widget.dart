import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myproject/constants.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class SocalCardWidget extends StatelessWidget {
  const SocalCardWidget({
    Key? key,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final String? icon;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: (10)),
        padding: EdgeInsets.all((12)),
        height: (40),
        width: (40),
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(icon!),
      ),
    );
  }
}

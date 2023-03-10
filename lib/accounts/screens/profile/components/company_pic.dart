import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/helper/tools.dart';

import '../../../../infoapp.dart';
import '../../../../main.dart';

class CompanyPic extends StatelessWidget {
  const CompanyPic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 115,
          width: 115,
          child: CircleAvatar(
            // backgroundImage: AssetImage("assets/images/logo.png"),
            backgroundImage: Image.asset(
              "assets/images/logo.png",
              cacheHeight: 100,
              cacheWidth: 100,
            ).image,
          ),
        ),
        spaceH10,
        Text(
          '$appName',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        spaceH10,
        Text(
          '$addressStore',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        spaceH10,
      ],
    );
  }
}

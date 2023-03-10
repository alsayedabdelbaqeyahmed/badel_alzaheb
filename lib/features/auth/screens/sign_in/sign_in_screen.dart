import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import 'widgets/body.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    CircularProgressIndicator();
    return Scaffold(
      body: BodySignInWidget(),
    );
  }
}

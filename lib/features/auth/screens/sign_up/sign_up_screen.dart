import 'package:flutter/material.dart';

import 'widgets/body.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التسجيل"),
      ),
      body: Body(),
    );
  }
}

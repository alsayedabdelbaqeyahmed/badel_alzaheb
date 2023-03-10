import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  DefaultImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
        'assets/images/logo.png',
        cacheHeight: 300,
        cacheWidth: 300,
        fit: BoxFit.fill,
      ),
    );
  }
}

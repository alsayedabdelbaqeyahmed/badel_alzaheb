import 'package:flutter/material.dart';
import 'package:myproject/common/utils/colors.dart';

class Description extends StatelessWidget {
  final txtDescription;
  const Description({
    required this.txtDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // product1s is out demo list
            'الوصف:',
            style: TextStyle(
              color: greyColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            txtDescription,
            style: TextStyle(
              height: 1.5,
              color: greyColor,
            ),
          ),
        ],
      ),
    );
  }
}

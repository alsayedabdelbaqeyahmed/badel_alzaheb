import 'package:flutter/material.dart';
import 'package:myproject/constants.dart';
import '/common/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  bool isLoading;
  CustomButton({
    Key? key,
    this.isLoading = false,
    required this.text,
    required this.onPressed,
    // this.bgColo = primaryColor,
  }) : super(key: key);
  Color? bgColor = primaryColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: isLoading == true
          ? CircularProgressIndicator()
          : Text(
              text,
              style: TextStyle(
                color: backgroundColor,
              ),
            ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        minimumSize: const Size(double.infinity, 50),
      ),
    );
  }
}

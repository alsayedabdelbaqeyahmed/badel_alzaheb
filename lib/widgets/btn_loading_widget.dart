import 'package:flutter/material.dart';
import 'package:myproject/constants.dart';

class BtnLoadingWidget extends StatelessWidget {
  final onPressed;
  bool isLoading;
  String title;
  String? icon;
  Color? backgroundColor;
  BtnLoadingWidget({
    required this.onPressed,
    required this.isLoading,
    required this.title,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: (56),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor ?? primaryColor,
        ),
        onPressed: onPressed,
        icon: icon != null ? Image.asset('assets/icons/$icon') : Container(),
        label: isLoading
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                title,
                style: TextStyle(
                  fontSize: (18),
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

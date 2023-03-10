import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'لا يتوفر بيانات',
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
  }
}

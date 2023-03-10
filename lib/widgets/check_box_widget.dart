import 'package:flutter/material.dart';
import 'package:myproject/helper/tools.dart';

class CheckBoxWidget extends StatefulWidget {
  String title;
  bool Isvalue;
  Function(bool?)? onChanged;
  CheckBoxWidget({
    required this.title,
    required this.Isvalue,
    required this.onChanged,
  });
  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    // final myprovider = Provider.of<MyProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Checkbox(
          value: widget.Isvalue,
          //activeColor: kPrimaryColor,
          onChanged: widget.onChanged,
        ),
        Text("${widget.title}"),
      ],
    );
  }
}


/**
 *  (value) {
            setState(() {
              IsDebited = value!;
            });
          },
 */
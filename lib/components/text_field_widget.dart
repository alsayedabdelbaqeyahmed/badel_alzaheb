import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';

class TextFieldWidget extends StatelessWidget {
  //const TextFieldWidget({Key? key}) : super(key: key);
  final String title;
  String? subtitle, helperText;
  bool autofocus, readOnly, obscureText;
  TextInputType? keyboardType;
  final Function(String)? onChanged;
  TextAlign textAlign;
  final TextEditingController? controller;
  Function(String?)? onSaved;
  Widget? suffixIcon;
  TextFieldWidget({
    Key? key,
    this.onChanged,
    this.onSaved,
    required this.title,
    this.subtitle,
    this.helperText,
    this.controller,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.readOnly = false,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: title,
          hintText: subtitle ?? title,
          suffixIcon: suffixIcon,
          helperText: helperText,
        ),
        textAlign: textAlign,
        keyboardType: keyboardType == null ? TextInputType.text : keyboardType,
        onChanged: onChanged,
        onSaved: onSaved,
        controller: controller,
        validator: RequiredValidator(errorText: 'خطأ: هذا الحقل مطلوب'),
        autofocus: autofocus,
        readOnly: readOnly,
        obscureText: obscureText,
      ),
    );
  }
}

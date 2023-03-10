import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myproject/common/utils/colors.dart';

var selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

class DateTimeFieldWidget extends StatelessWidget {
  final labelText;
  void Function()? onPressed;
  TextEditingController controller = TextEditingController();
  DateTimeFieldWidget({
    required this.labelText,
    required this.onPressed,
    required this.controller,
  });
  // DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      // onTap: onPressed,
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: '$labelText',
          hintText: '$labelText',
          // suffixIcon: ,
          prefixIcon: IconButton(
            icon: Icon(
              Icons.date_range_outlined,
              color: appBarColor,
            ),
            onPressed: onPressed,
          ),
        ),
        controller: controller,
      ),
    );
  }
}

String toDateFormatStr(DateTime date) {
  return DateFormat("yyyy-MM-dd").format(date);
}

//
Future<String> selectDate(context) async {
  try {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2013, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != DateTime.now()) {
      return toDateFormatStr(picked);
    } else
      return toDateFormatStr(DateTime.now());
    //notifyListeners();
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}

Future<DateTime> toDateTime(String date) async {
  try {
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd").parse(date); //yyyy-MM-dd hh:mm:ss
    return tempDate;
  } catch (e) {
    print(e);
    return Future.error(e);
  }
}
//Timestamp.now()


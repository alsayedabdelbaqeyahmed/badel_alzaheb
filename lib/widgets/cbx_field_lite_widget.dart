import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';

class CbxFieldLiteWidget extends ConsumerWidget {
  String title;
  // StreamProvider<List> getDataListProvider;
  List listData;
  String controlItem;
  Function(String? newSelected)? onChanged;
  CbxFieldLiteWidget({
    // required this.getDataListProvider,
    required this.listData,
    required this.title,
    required this.controlItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DropdownSearch<String>(
      validator: (value) {
        if (value == null || value.toString().trim() == '')
          return 'خطأ: يجب تحديد $title';
      },
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: TextStyle(
          color: appBarColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        dropdownSearchDecoration: InputDecoration(
          labelText: title,
          hintText: title,
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.only(left: 5.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appBarColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: greyColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        showSearchBox: true,
        // textStyle: TextStyle(
        //   color: backgroundColor,
        // ),
      ),
      items: loadListNames,
      onChanged: onChanged,
      selectedItem: controlItem,
    );
  }

  List<String> get loadListNames {
    List<String> lst = [];

    for (var row in listData) {
      lst.add(row.name);
    }
    return lst;
  }
}

// class CbxFieldLiteWidget<T> extends ConsumerWidget {
//   String title;
//   final watchProvider;
//   List listData;
//   String controlItem;
//   Function(String? newSelected)? onChanged;
//   CbxFieldLiteWidget({
//     required this.watchProvider,
//     required this.listData,
//     required this.title,
//     required this.controlItem,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return watchProvider.when(
//       data: (dataList) {
//         if (dataList == [] || dataList.isEmpty) {
//           return Text('لا يوجد $title.');
//         }
//         return DropdownSearch<String>(
//           validator: (value) {
//             if (value == null || value.toString().trim() == '')
//               return 'خطأ: يجب تحديد $title';
//           },
//           dropdownDecoratorProps: DropDownDecoratorProps(
//             baseStyle: TextStyle(
//               color: appBarColor,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//             dropdownSearchDecoration: InputDecoration(
//               labelText: title,
//               hintText: title,
//               border: InputBorder.none,
//               filled: true,
//               fillColor: backgroundColor,
//               contentPadding:
//                   const EdgeInsets.only(left: 5.0, bottom: 6.0, top: 8.0),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: appBarColor),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: greyColor),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//             ),
//           ),
//           popupProps: PopupProps.menu(
//               showSelectedItems: true,
//               showSearchBox: true,
//               textStyle: TextStyle(
//                 color: backgroundColor,
//               )),
//           items: loadListNames,
//           onChanged: onChanged,
//           selectedItem: controlItem,
//         );
//       },
//       error: (err, trace) {
//         return ErrorScreen(
//           error: err.toString(),
//         );
//       },
//       loading: () => const Loader(),
//     );
//   }

//   List<String> get loadListNames {
//     List<String> lst = [];

//     for (var row in listData) {
//       lst.add(row.name);
//     }
//     return lst;
//   }
// }
 
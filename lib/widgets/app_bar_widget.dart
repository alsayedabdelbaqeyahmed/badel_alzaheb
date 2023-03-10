import 'package:flutter/material.dart';
import 'package:myproject/common/utils/colors.dart';

import '../common/utils/utils.dart';

class AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  AppBarWidget(
    this.title, {
    this.delegate,
    this.widgetActions,
  });
  String title;
  SearchDelegate<dynamic>? delegate;
  Widget? widgetActions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: SelectableText(
        '$title',
        style: TextStyle(color: textColor),
      ),
      actions: [
        if (delegate != null)
          IconButton(
              onPressed: () {
                msgShow(
                  'البحث متقدم',
                );
                showSearch(
                  context: context,
                  delegate: delegate!,
                );
              },
              icon: Icon(
                Icons.search,
              )),
        if (widgetActions != null) widgetActions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

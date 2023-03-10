import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/product/controller/category_provider.dart';
import 'package:myproject/features/product/models/category.dart';
import 'package:myproject/widgets/nodata_widget.dart';

import '../../../common/utils/colors.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../controller/category_controller.dart';

// We need satefull widget for our CategoriesWidget

int selectedIndex = 0;

class CategoriesWidget extends ConsumerStatefulWidget {
  // static String routeName = ''
  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends ConsumerState<CategoriesWidget> {
  // List<String> categoriesTabs = [];
  // By default our first item will be selected
  //  int selectedIndex= PageStorageKey<int>(1),

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 60,
        child: ref.watch(getCategoryFutureProvider).when(
              data: (dataList) {
                if (dataList == null || dataList == [] || dataList.isEmpty) {
                  return NoDataWidget();
                }
                if (categoryProvider.category == null && dataList != null) {
                  Future.delayed(Duration(microseconds: 20), () async {
                    await categoryProvider.selectCategory(
                        context, dataList.first);
                    await ref
                        .refresh(categoryControllerProvider)
                        .getProductsWhereCatIdFuture(
                            categoryProvider.category!.id);
                  });
                  // return const LandingScreen();
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    var row = dataList[index];
                    // categoriesTabs.add(dataList[index].name);

                    return buildCategory(row, index);
                  },
                );
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            ),
      ),
    );
  }

  Widget buildCategory(Category row, int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(40),
      onTap: () async {
        setState(() {
          selectedIndex = index;
        });
        await categoryProvider.selectCategory(
          context,
          row,
        );
        await ref
            .refresh(categoryControllerProvider)
            .getProductsWhereCatIdFuture(categoryProvider.category!.id);
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
        decoration: BoxDecoration(
            color: selectedIndex == index ? appBarColor : greyColor,
            borderRadius: BorderRadius.circular(40)),
        child: Text(
          row.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: backgroundColor,
            // color: selectedIndex == index ? textColor : greyColor,
          ),
        ),
      ),
    );
    /* return InkWell(
      onTap: () async {
        try {
          await categoryProvider.selectCategory(context, row);
          await ref
              .refresh(categoryControllerProvider)
              .getProductsWhereCatIdFuture(categoryProvider.category!.id);
          setState(() {
            selectedIndex = index;
          });
        } catch (e) {
          print(e);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPaddin, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              row.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selectedIndex == index ? textColor : greyColor,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: kDefaultPaddin / 4), //top padding 5
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );*/
  }
}

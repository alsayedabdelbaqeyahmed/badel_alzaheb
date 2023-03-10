import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/features/product/controller/category_provider.dart';
import 'package:myproject/widgets/app_bar_back_widget.dart';
import 'package:myproject/widgets/list_tile_animation_widget.dart';
import 'package:myproject/widgets/nodata_widget.dart';

import '../../../common/utils/colors.dart';
import '../../../components/product_card.dart';
import '../controller/category_controller.dart';
import '../models/product.dart';
import '../widgets/categories_widget.dart';

class ProductsListScreen extends ConsumerWidget {
  static const String routeName = '/products-screen';
  ScrollController scrollController1 = ScrollController();
  ProductsListScreen({this.catId, this.catName});
  String? catId;
  String? catName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: catId != null
            ? appbarBackWidget(
                context,
                catName ?? '',
              )
            : null,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              catId == null ? CategoriesWidget() : spaceH,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin - 5),
                  child: FutureBuilder<List<Product>>(
                    future: ref
                        .watch(categoryControllerProvider)
                        .getProductsWhereCatIdFuture(catId != null
                            ? catId!
                            : (categoryProvider.category == null
                                ? ''
                                : categoryProvider.category!.id)),
                    builder: (context, snapshot) {
                      List<Product>? rows = snapshot.data;

                      if (rows == null ||
                          rows == [] ||
                          rows.isEmpty ||
                          !snapshot.hasData) {
                        return NoDataWidget();
                      } else
                        return Scrollbar(
                          thickness: 5,
                          scrollbarOrientation: ScrollbarOrientation.right,
                          interactive: true,
                          radius: Radius.circular(30),
                          controller: scrollController1,
                          thumbVisibility: true,
                          child: Container(
                            // ListTileAnimation
                            child: GridView.builder(
                              itemCount: rows.length,
                              controller: scrollController1,
                              key: PageStorageKey<String>('productPg'),

                              // ignore: prefer_const_constructors
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: kDefaultPaddin - 4,
                                crossAxisSpacing: kDefaultPaddin - 5,
                                childAspectRatio: 0.75,
                              ),
                              itemBuilder: (context, index) => Container(
                                //ListTileAnimation
                                // index: index,
                                child: ProductCardWidget(product: rows[index]),
                              ),
                            ),
                          ),
                        );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

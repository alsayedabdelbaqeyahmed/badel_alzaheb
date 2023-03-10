import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/carousel/controller/carousel_controller.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/features/product/screen/products_list_screen.dart';
import '../../../../../common/widgets/error.dart';
import '../../../../../common/widgets/loader.dart';
import '../../../../../size_config.dart';
import '../../../../product/models/product.dart';
import '/components/product_card.dart';
import 'section_title.dart';

class PopularProducts extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
              title: "المنتجات الرائدة",
              onPressed: () {
                Navigator.pushNamed(context, ProductsListScreen.routeName);
              }),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        ref.watch(getProductPopularFutureProvider).when(
              data: (dataList) {
                if (dataList == null || dataList.isEmpty) {
                  return Text('لا يوجد منتجات رائدة');
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        dataList.length,
                        (index) {
                          if (dataList[index].isPopular == true)
                            return ProductCardWidget(product: dataList[index]);

                          return SizedBox
                              .shrink(); // here by default width and height is 0
                        },
                      ),
                      SizedBox(width: getProportionateScreenWidth(20)),
                    ],
                  ),
                );
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
              // loading: () => SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       ...List.generate(
              //         1,
              //         (index) {
              //           return ProductCardWidget(product: productDefalt);

              //           return SizedBox
              //               .shrink(); // here by default width and height is 0
              //         },
              //       ),
              //       SizedBox(width: getProportionateScreenWidth(20)),
              //     ],
              //   ),
              // ),
            ),
      ],
    );
  }
}

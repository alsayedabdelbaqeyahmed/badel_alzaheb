import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/carousel/controller/carousel_controller.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/features/product/screen/category_screen.dart';
import 'package:myproject/features/product/screen/products_list_screen.dart';
import 'package:myproject/size_config.dart';
import 'package:myproject/widgets/image_gallery_widget.dart';
import 'package:myproject/widgets/image_network_widget.dart';

import '../../../../../common/widgets/error.dart';
import '../../../../../common/widgets/loader.dart';
import 'section_title.dart';

class SpecialOffers extends ConsumerWidget {
  SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "التصنيفات",
            // title: "خصيصا لك",
            onPressed: () {
              Navigator.pushNamed(context, CategoryScreen.routeName);
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        ref.watch(getCategoryFutureProvider).when(
              data: (dataList) {
                if (dataList == null || dataList.isEmpty) {
                  return Text('لا يوجد تصنيفات');
                }
                if (dataList.length > 15) {
                  dataList = dataList.sublist(0, 11);
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        dataList.length,
                        (index) {
                          if (dataList[index] != null)
                            return SpecialOfferCard(
                              // image: "assets/images/Image Banner 2.png",
                              image: dataList[index].image,
                              category: dataList[index].name,
                              numOfItems: 18,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductsListScreen(
                                        catId: dataList[index].id,
                                        catName: dataList[index].name,
                                      ),
                                    ));
                              },
                            );

                          return SizedBox
                              .shrink(); // here by default width and height is 0
                        },
                      ),
                    ],
                  ),
                );
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => Loader(),

              // loading: () => SpecialOfferCard(
              //   // image: "assets/images/Image Banner 2.png",
              //   image: "assets/images/logo.png",
              //   category: "",
              //   numOfItems: 18,
              //   onPressed: () {},
              // ),
            ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfItems,
    required this.onPressed,
  }) : super(key: key);

  final String category, image;
  final int numOfItems;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: getProportionateScreenWidth(260),
          height: getProportionateScreenWidth(130),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: getProportionateScreenWidth(130),
                  child: ImageNetWorkWidget(image: image),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // TextSpan(text: "$numOfItems صنف")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

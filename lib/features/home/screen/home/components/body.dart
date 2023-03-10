import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';
import 'package:myproject/features/auth/screens/user_profile_screen.dart';
import 'package:myproject/routes.dart';
import 'package:myproject/widgets/btn_loading_widget.dart';

import '../../../../../constants.dart';
import '../../../../../size_config.dart';
import '../../../../carousel/widgets/carousel_slider_data.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class BodyHome extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 395),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                SizedBox(height: getProportionateScreenHeight(20)),
                HomeHeader(),
                SizedBox(height: getProportionateScreenWidth(10)),
                CarouselSliderDataFound(),
                // Categories(),
                spaceH,
                SpecialOffers(),
                SizedBox(height: getProportionateScreenWidth(30)),
                PopularProducts(),
                SizedBox(height: getProportionateScreenWidth(30)),
                DiscountBanner(),
                ref.read(userDataAuthProvider).when(
                      data: (data) {
                        if (data == null)
                          return noticeMethod(
                            context,
                            'تسجيل الدخول',
                            "سجل الدخول للاستفادة من جميع الخدمات",
                            onPressed: () {
                              try {
                                Navigator.of(context).pushNamed(sign_in_screen);
                              } catch (e) {
                                print('----: $e');
                              }
                            },
                          );

                        if (data != null && data.cityId.trim() == '')
                          return noticeMethod(
                            context,
                            'تحديد المدينة',
                            "حدد المدينة للاستفادة من كافة المميزات",
                            onPressed: () {
                              try {
                                Navigator.of(context)
                                    .pushNamed(UserProfileScreen.routeName);
                              } catch (e) {
                                print('----: $e');
                              }
                            },
                          );

                        return Container();
                      },
                      error: (error, stackTrace) => Container(
                        padding: EdgeInsets.all(20),
                        child: Text('أنت غير متصل بالإنترنت'),
                      ),
                      loading: () => Loader(),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget noticeMethod(
    BuildContext context,
    String title,
    String subtitle, {
    required void Function()? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(getProportionateScreenWidth(10)),
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(20),
          vertical: getProportionateScreenWidth(30),
        ),
        decoration: BoxDecoration(
            gradient: kPrimaryGradientColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color: appBarColor,
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: onPressed,
              child: Text(
                "$title",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(20),
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            spaceH10,
            Text(
              subtitle,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                // fontWeight: FontWeight.bold,
                color: appBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/**
 *       return Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(getProportionateScreenWidth(10)),
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(20),
                        vertical: getProportionateScreenWidth(30),
                      ),
                      decoration: BoxDecoration(
                          color: kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 2,
                              color: primaryColor,
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              try {
                                Navigator.of(context).pushNamed(sign_in_screen);
                              } catch (e) {
                                print('----: $e');
                              }
                            },
                            child: Text(
                              "تسجيل الدخول",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(20),
                                // fontWeight: FontWeight.bold,
                                // color: Colors.white,
                              ),
                            ),
                          ),
                          spaceH10,
                          Text(
                            "سجل الدخول للاستفادة من جميع الخدمات",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(15),
                              // fontWeight: FontWeight.bold,
                              // color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );

 */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/features/auth/screens/user_profile_screen.dart';
import 'package:myproject/features/orders/screens/orders_finishe_screen.dart';
import 'package:myproject/infoapp.dart';
import 'package:myproject/routes.dart';
import 'package:myproject/widgets/user_watch_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../size_config.dart';
import '/features/auth/controller/auth_controller.dart';
import 'profile_menu.dart';
import 'company_pic.dart';

class Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
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
                CompanyPic(),

                SizedBox(height: 20),
                ProfileMenu(
                    text: "الملف الشخصي",
                    icon: "assets/icons/User Icon.svg",
                    onPressed: () {
                      try {
                        if (ref.watch(userDataAuthProvider).value != null)
                          Navigator.of(context).pushNamed(
                            UserProfileScreen.routeName,
                          );
                        else {
                          Navigator.of(context).pushNamed(sign_in_screen);
                          msgBox(context, 'قم بتسجيل الدخول  اولا');
                        }
                      } catch (e) {
                        print('----: $e');
                        msgBox(context, 'قد يكون الانترنت غير متاح');
                      }
                    }),
                // ProfileMenu(
                //   text: "الإشعارات",
                //   icon: "assets/icons/Bell.svg",
                //   onPressed: () {},
                // ),
                ProfileMenu(
                  text: "الطلبات",
                  icon: "assets/icons/Bell.svg",
                  onPressed: () {
                    Navigator.pushNamed(context, OrdersFinisheScreen.routeName);
                  },
                ),
                ProfileMenu(
                  text: "تواصل معنا",
                  iconData: Icons.chat,
                  onPressed: () {
                    launchInBrowser(connectYou);
                  },
                ),

                ProfileMenu(
                  text: "سياسة الخصوصية",
                  iconData: Icons.privacy_tip_outlined,
                  onPressed: () {
                    launchInBrowser(privet_policy_url);
                  },
                ),
                ProfileMenu(
                  text: "مشاركة التطبيق",
                  iconData: Icons.share,
                  onPressed: () {
                    Share.share(shareText);
                  },
                ),

                UserWatchWidget(
                  widget: ProfileMenu(
                    text: "تسجيل الخروج",
                    icon: "assets/icons/Log out.svg",
                    onPressed: () => Future(
                      () async {
                        GoogleSignIn _authGoogle = await GoogleSignIn();

                        await auth.signOut();
                        // Sign out with google
                        await _authGoogle.signOut();
                        await ref.refresh(userDataAuthProvider);
                        Navigator.pushNamedAndRemoveUntil(
                            context, go_main, (route) => false);
                      },
                    ),
                  ),
                ),
                // ref.watch(userDataAuthProvider).when(
                //       data: (user) {
                //         if (user == null) return Container();
                //         return
                //       },
                //       error: (err, trace) {
                //         return ErrorScreen(
                //           error: err.toString(),
                //         );
                //       },
                //       loading: () => const Loader(),
                //     ),

                // spaceH,
                SizedBox(
                  height: SizeConfig.screenHeight * 0.08,
                ),
                TextButton(
                  onPressed: () {
                    launchInBrowser('$sendYsr');
                  },
                  child: Text(
                    'تطوير:ياسر',
                    style: TextStyle(fontSize: 14),
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

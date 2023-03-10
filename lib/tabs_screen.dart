import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';
import 'package:myproject/features/auth/screens/sign_in/sign_in_screen.dart';
import 'package:myproject/features/orders/screens/cart/cart_order_details_screen.dart';
import 'package:myproject/features/product/screen/products_list_screen.dart';
import 'package:myproject/theme.dart';
import '../constants.dart';
import 'accounts/screens/profile/profile_screen.dart';
import 'features/home/screen/home/home_screen.dart';

class TabsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int index = 0;

  final screens = [
    HomeScreen(),
    ProductsListScreen(),
    CartOrderDetailsScreen(),
    // SignUpScreen(),
    SettingScreen(),
  ];
  final Color inActiveIconColor = Color(0xFFB6B6B6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(userDataAuthProvider).when(
            data: (user) {
              return screens[index];
            },
            error: (err, trace) {
              return screens[index];

              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
      // body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: navigationBarTheme(),
        child: NavigationBar(
          selectedIndex: index,
          height: 65,
          onDestinationSelected: (_index) {
            setState(() {
              this.index = _index;
            });
            //mypro.notifyListeners();
          },
          destinations: [
            buildNavBar('الرئيسية', "assets/icons/Shop Icon.svg", 0),
            buildNavBar('المنتجات', "assets/icons/Parcel.svg", 1),
            buildNavBar('سلتي', "assets/icons/cart.svg", 2),
            // buildNavBar('المفضلة', "assets/icons/favourit_Icon.svg", 3),
            buildNavBar('الإعدادات', "assets/icons/Settings.svg", 4),
            // buildNavBar('الفئات', "assets/icons/Chat bubble Icon.svg", 4),
          ],
        ),
      ),
    );
  }

  NavigationDestination buildNavBar(title, pathIcon, indx) {
    return NavigationDestination(
        icon: SvgPicture.asset(
          "$pathIcon",
          // color: MenuState.profile == index ? kPrimaryColor : inActiveIconColor,
          color: indx == index ? primaryColor : inActiveIconColor,
        ),
        label: '$title');
  }
}

/* SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MenuState.home == index
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, HomeScreen.routeName),
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/Heart Icon.svg"),
                  onPressed: () {},
                ),
                IconButton(
                  icon: SvgPicture.asset("assets/icons/Chat bubble Icon.svg"),
                  onPressed: () {},
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: MenuState.profile == index
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, ProfileScreen.routeName),
                ),
              ],
            )),*/

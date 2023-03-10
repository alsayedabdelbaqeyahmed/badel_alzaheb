import 'package:flutter/widgets.dart';
import 'package:myproject/features/auth/screens/sign_in/sign_in_screen.dart';
import 'package:myproject/features/auth/screens/sign_up/sign_up_screen.dart';
import 'package:myproject/features/home/screen/home/home_screen.dart';
import 'package:myproject/features/orders/screens/cart/cart_order_details_screen.dart';
import 'package:myproject/features/orders/screens/orders_finishe_screen.dart';
import 'package:myproject/features/product/screen/category_screen.dart';
import 'package:myproject/features/product/screen/product_details/product_details_screen.dart';
import 'package:myproject/features/product/screen/products_list_screen.dart';
import 'package:myproject/tabs_screen.dart';

import 'accounts/screens/forgot_password/forgot_password_screen.dart';
import 'accounts/screens/profile/profile_screen.dart';
import 'accounts/screens/splash/splash_screen.dart';
import 'features/auth/screens/user_profile_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  splash: (context) => SplashScreen(),
  sign_in_screen: (context) => SignInScreen(),
  sign_up_screen: (context) => SignUpScreen(),
  forgot_password_screen: (context) => ForgotPasswordScreen(),
  go_main: (context) => TabsScreen(),
  UserProfileScreen.routeName: (context) => UserProfileScreen(),
  CategoryScreen.routeName: (context) => CategoryScreen(),
  ProductsListScreen.routeName: (context) => ProductsListScreen(),
  home_screen: (context) => HomeScreen(),
  product_details_screen: (context) => ProductDetailsScreen(),
  CartOrderDetailsScreen.routeName: (context) => CartOrderDetailsScreen(),
  // PaymentScreen.routeName: (context) => PaymentScreen(),
  profile: (context) => SettingScreen(),
  OrdersFinisheScreen.routeName: (context) => OrdersFinisheScreen(),
  // OrdersDetailsScreen.routeName: (context) => OrdersDetailsScreen(),
};

String go_main = "/tabs_screen";
String splash = "/splash";
String entries_list = "/entries_list";
String sign_in_screen = "/sign_in_screen";
String sign_up_screen = "/sign_up_screen";
String forgot_password_screen = "/forgot_password_screen";
String profile = "/profile";
String home_screen = "/home";

const String settings = '/settings';
const String info_app = '/info_app';

// category
String product_details_screen = '/product_details_screen';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/routes.dart';
import 'package:myproject/widgets/btn_loading_widget.dart';
import '../../../../common/widgets/error.dart';
import '../../../../common/widgets/loader.dart';
import '../../../auth/controller/auth_controller.dart';
import '/size_config.dart';
import 'components/body.dart';

class CartOrderDetailsScreen extends ConsumerStatefulWidget {
  static const routeName = '/cart-screen';

  @override
  ConsumerState<CartOrderDetailsScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartOrderDetailsScreen> {
  bool isLoading = false;
  bool isLoadingApple = false;
  bool isLoadingGoogle = false;
  @override
  Widget build(BuildContext context) {
    return ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null)
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.1,
                          ),
                          Container(
                              width: 250,
                              height: 260,
                              child: Image.asset(
                                  'assets/images/requsetlogin.png')),
                          Text(
                            'سجل دخول للاستفادة من السلة',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          spaceH,
                          spaceH,
                          BtnLoadingWidget(
                            isLoading: false,
                            title: 'تسجيل الدخول',
                            onPressed: () {
                              Navigator.pushNamed(context, sign_in_screen);
                            },
                          ),
                          spaceH,
                          spaceH10,
                          BtnLoadingWidget(
                            isLoading: isLoading,
                            title: 'متابعة عبر جوجل',
                            icon: 'google.png',
                            onPressed: () async {
                              try {
                                setState(() {
                                  isLoadingGoogle = true;
                                });

                                await ref
                                    .read(authControllerProvider)
                                    .signInWithGoogle(context);
                                //   await ref.refresh(userDataAuthProvider);
                                setState(() {
                                  isLoadingGoogle = false;
                                });
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                          spaceH,
                          if (Platform.isIOS)
                            BtnLoadingWidget(
                              isLoading: isLoadingApple,
                              title: 'متابعة عبر Apple',
                              icon: 'apple.png',
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isLoadingApple = true;
                                  });
                                  await ref
                                      .read(authControllerProvider)
                                      .signInWithApple(context);
                                  // await ref.refresh(userDataAuthProvider);
                                  setState(() {
                                    isLoadingApple = false;
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            return Scaffold(
              appBar: buildAppBar(context),
              body: Body(),
            );
          },
          error: (err, trace) {
            return ErrorScreen(
              error: err.toString(),
            );
          },
          loading: () => const Loader(),
        );
  }

  AppBar buildAppBar(BuildContext context) {
    // var resaultOrdersPro = ref.read(resaultOrdersProvider.notifier).state;

    return AppBar(
      // leading: //Icon(Icons.ac_unit),r
      title: Text(
        " سلتي ", //${resaultOrdersPro.lenghtOrderdetails}
        style: TextStyle(color: textColor),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await ref.refresh(getOrderDetailsUserStreamProvider);

              msgBox(context, 'جاري التحديث');
            },
            icon: Icon(
              Icons.refresh,
            )),
      ],
    );
  }
}


//CircularProgressIndicator(),
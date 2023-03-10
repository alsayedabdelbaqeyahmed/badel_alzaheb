import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myproject/features/orders/controller/cart_provider.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/orders/screens/payment_screen.dart';
import 'package:myproject/var_public.dart';
import '/components/default_button.dart';
import '/size_config.dart';

class CheckoutCard extends ConsumerStatefulWidget {
  CheckoutCard({
    Key? key,
    required this.order,
    required this.sumCartsTotale,
  }) : super(key: key);
  Order? order;
  num sumCartsTotale;

  @override
  ConsumerState<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends ConsumerState<CheckoutCard> {
  num? sumSubTotalOrder = 0.0;

  num? sumTotalQtyOrder = 0.0;

  num? sumTotalPriceAndQtyOrder = 0.0;

  @override
  Widget build(BuildContext context) {
    var sumOrderDetailsProvider = ref.read(resaultOrdersProvider.notifier);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: getProportionateScreenHeight(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "الإجمالي:\n",
                    children: [
                      TextSpan(
                        text: "${widget.sumCartsTotale} $varCurrCode",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(160),
                  child: DefaultButton(
                    text: "اتمام الطلب",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            order: widget.order,
                            totalCarts:
                                sumOrderDetailsProvider.state.sumTotalOrder,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

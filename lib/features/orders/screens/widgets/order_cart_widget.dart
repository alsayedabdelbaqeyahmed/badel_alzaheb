import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';

import '../../controller/cart_provider.dart';

class OrderCartQtyWidget extends ConsumerWidget {
  OrderCartQtyWidget({
    required this.qty,
    required this.price,
    required this.txtOrderDetailsId,
  });
  num qty;
  num price;
  String txtOrderDetailsId;

  @override
  Widget build(BuildContext context, ref) {
    return Row(
      children: [
        buildOutlineButton(
          icon: Icons.add,
          onPressed: () async {
            await qty++;
            await ref.read(orderControllerProvider).updateCartOrderDetails(
                  context: context,
                  txtOrderDetailsId: txtOrderDetailsId,
                  qty: qty,
                  price: price,
                );
            var sumOrderDetailsProvider =
                await ref.read(resaultOrdersProvider.notifier);
            sumOrderDetailsProvider.state.sumQtyOrder += qty;
            sumOrderDetailsProvider.state.sumTotalOrder += price;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
          child: Text(
            // if our item is less  then 10 then  it shows 01 02 like that
            qty.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        buildOutlineButton(
          icon: Icons.remove,
          onPressed: () async {
            if (qty > 1) {
              await qty--;
              await ref.read(orderControllerProvider).updateCartOrderDetails(
                    context: context,
                    txtOrderDetailsId: txtOrderDetailsId,
                    qty: qty,
                    price: price,
                  );
              var sumOrderDetailsProvider =
                  await ref.read(resaultOrdersProvider.notifier);
              sumOrderDetailsProvider.state.sumQtyOrder -= qty;
              sumOrderDetailsProvider.state.sumTotalOrder -= price;
            }
          },
        ),
      ],
    );
  }

  SizedBox buildOutlineButton(
      {required IconData icon, required Function() onPressed}) {
    return SizedBox(
      width: 32,
      height: 29,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}

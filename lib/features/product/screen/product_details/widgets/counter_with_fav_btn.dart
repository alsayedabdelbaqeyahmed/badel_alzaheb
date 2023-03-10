import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/features/product/screen/product_details/widgets/body_product_widget.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../auth/controller/auth_controller.dart';
import 'add_to_cart_widget.dart';
import 'cart_counter.dart';

class CounterWithFavBtn extends ConsumerWidget {
  Product row;
  num qty;
  CounterWithFavBtn({
    required this.row,
    required this.qty,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      margin: EdgeInsets.only(top: 18),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          AddToCartWidget(
            onPressed: () {
              try {
                if (ref.watch(userDataAuthProvider).value != null &&
                    auth.currentUser != null) {
                  // ------
                  var data = {
                    colProductId: row.id,
                    colPrice: checkNumber(discountProduct(row)),
                    colQty: qty,
                    colTotalPrice: getTotal,
                  };

                  ref.read(orderControllerProvider).addedProductToCart(
                      context: context,
                      txtUserId: auth.currentUser!.uid,
                      data: data);
                } else {
                  msgBox(context, 'يجب تسجيل الدخول ');
                }
              } catch (e) {
                print('----: $e');
              }
            },
          ),
          // FavouriteWidget(onTap: () {
          //   // try {
          //   //   favuaret_Data.add({
          //   //     colId:  row.id.toString(),
          //   //     colItmName: row.title,
          //   //     colDescription:  row.description,
          //   //     colPrice: num.parse(row.price.toString()),
          //   //     colQty: numOfItems,
          //   //     colImage: row.images.first,
          //   //   });
          //   // } catch (e) {
          //   //   print(e);
          //   // }
          // }),
          Spacer(),
          CartCounterWidget(),
        ],
      ),
    );
  }

  num get getTotal {
    num price = checkNumber(discountProduct(row));
    if (price > qty)
      return price * qty;
    else
      return qty * price;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/orders/screens/widgets/order_cart_widget.dart';
import 'package:myproject/features/product/screen/product_details/widgets/body_product_widget.dart';
import 'package:myproject/helper/tools.dart';
import 'package:myproject/var_public.dart';
import 'package:myproject/widgets/image_gallery_widget.dart';
import 'package:myproject/widgets/image_network_widget.dart';
import '/constants.dart';

class CardOrderDetailsWidget extends ConsumerWidget {
  //  StatelessWidget
  const CardOrderDetailsWidget({
    Key? key,
    required this.cartDetails,
  }) : super(key: key);

  final OrderDetails cartDetails;
  @override
  Widget build(BuildContext context, ref) {
    String name = cartDetails.product!.name;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Color(0xFFECBDBD),
            width: 2,
          ),
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // image
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  width: 88,
                  child: AspectRatio(
                    aspectRatio: 0.88,
                    child: Container(
                      // padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                      decoration: BoxDecoration(
                        color: kPrimaryLightColor,
                        // color: Color(0xFFF5F6F9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          openImage(context, cartDetails.product!.images[0]);
                        },
                        child: ImageNetWorkWidget(
                          image: cartDetails.product!.images[0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              spaceW(),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${name.length >= 25 ? (name.substring(0, 25) + ' ...') : name}',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${cartDetails.totalPrice.toString()} $varCurrCode",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            bottom: 10,
            child: OrderCartQtyWidget(
              txtOrderDetailsId: cartDetails.id,
              qty: cartDetails.qty,
              price: checkNumber(discountProduct(cartDetails.product!)),
            ),
          ),
        ],
      ),
    );
  }
}

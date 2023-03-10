import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/features/orders/controller/count_provider.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/features/product/screen/product_details/widgets/cart_counter.dart';
import 'package:myproject/infoapp.dart';
import 'package:myproject/var_public.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../size_config.dart';
import '/constants.dart';
import 'counter_with_fav_btn.dart';
import 'description.dart';
import 'product_image_widget.dart';

class BodyProductWidget extends ConsumerWidget {
  final Product product;

  BodyProductWidget({required this.product});
  @override
  Widget build(BuildContext context, ref) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      maintainBottomViewPadding: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ProductImageWidget(
                    image: product.images.first, colId: product.id),
                Positioned(
                  left: 11,
                  bottom: 11,
                  child: InkWell(
                    onTap: () {
                      String str = "بديل الذهب افضل المنتجات\n";
                      str += "المنتج: ${product.name}\n";
                      str += "الوصف: ${product.description}\n";
                      str += "السعر: ${discountProduct(product)}\n";
                      str += "تسوق الان وشاهد كافة العروض بسهول\n";
                      str += "نزل التطبق الان \n $linkApp";
                      Share.share(str);
                    },
                    child: Icon(
                      Icons.share,
                      color: kPrimaryLightColor,
                      size: 27,
                      shadows: [
                        Shadow(
                          color: primaryColor,
                          blurRadius: 18,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                top: size.height * 0.03,
                left: kDefaultPaddin,
                right: kDefaultPaddin,
              ),
              height: size.height - 380,
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(30),
                //   topRight: Radius.circular(20),
                // ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // product1s is out demo list
                      '${product.name}',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    spaceH,
                    buildTextPrice(),
                    spaceH10,
                    Description(
                      txtDescription: '${product.description}',
                      // txtDescription: '${product[colCategory]}',
                    ),
                    spaceH10,
                    // ColorAndSize(product: product),
                    SizedBox(height: size.height * 0.1),
                    CounterWithFavBtn(
                      row: product,
                      qty: ref.watch(countProvider).counter, //numOfItems,
                    ),

                    spaceH,
                    spaceH,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextPrice() {
    return discountProduct(product).trim() == '0'
        ? Row(children: [
            Text(
              'السعر : ',
              style: TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${product.price} $varCurrCode',
              style: TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ])
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text(
                  'السعر قبل الخصم: ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  '${product.price} $varCurrCode',
                  style: TextStyle(
                    fontSize: (15),
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Spacer(),
              ]),
              Row(children: [
                Text(
                  'السعر الجديد: ',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${discountProduct(product)} $varCurrCode',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
              ]),
            ],
          );
  }
}

String discountProduct(Product product) {
  num resault = 0;

  if (product.discount != 0) {
    if (product.price > product.discount) {
      resault = (product.price - product.discount);
    }
    if (product.price < product.discount) {
      resault = (product.discount - product.price);
    }

    return resault.abs().toStringAsFixed(1);
  } else
    return product.price.toStringAsFixed(2);

  // num resaultAmount = 0;
  // if (product.discount != 0) {
  //   if (product.price > product.discount) {
  //     resault = ((product.price * product.discount) / 100);
  //   }
  //   if (product.price < product.discount) {
  //     resault = ((product.discount * product.price) / 100);
  //   }
  //   resaultAmount = product.price - resault;
  //   return resaultAmount.abs().toStringAsFixed(1);
  // } else
  //   return '0';
}

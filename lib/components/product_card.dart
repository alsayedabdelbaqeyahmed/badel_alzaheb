import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/features/home/screen/home/components/discount_banner.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/routes.dart';
import 'package:myproject/var_public.dart';
import 'package:myproject/widgets/image_network_widget.dart';
import '../common/utils/utils.dart';
import '../constants.dart';
import '../features/auth/controller/auth_controller.dart';
import '../features/orders/controller/order_controller.dart';
import '../features/orders/models/orders.dart';
import '../size_config.dart';
import 'add_cart_widget.dart';

class ProductCardWidget extends ConsumerStatefulWidget {
  ProductCardWidget({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double width, aspectRetio;
  final Product product;

  @override
  ConsumerState<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends ConsumerState<ProductCardWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      child: SizedBox(
        width: getProportionateScreenWidth(widget.width),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            product_details_screen,
            arguments: widget.product,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  // padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: appBarColor.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Hero(
                    tag: widget.product.id,
                    // child: Image.asset(product[colImage]),
                    child: ClipRRect(
                      child: ImageNetWorkWidget(
                          image: widget
                              .product.images.first), // product.images.first),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.product.name,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
                overflow: TextOverflow.fade,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.product.discount == 0.0
                      ? Text(
                          "${widget.product.price} $varCurrCode",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(14),
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        )
                      : Column(
                          children: [
                            Text(
                              "${widget.product.price} $varCurrCode",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(12),
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              "   ${discountProduct()} $varCurrCode",
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(13),
                                fontWeight: FontWeight.w400,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                  /**/
                  // المفضلة
                  // FavouriteWidget(isFavourite: true),
                  AddCartWidget(
                    isLoading: _isLoading,
                    onAddCart: () async {
                      try {
                        setState(() {
                          _isLoading = true;
                        });
                        // --
                        if (ref.watch(userDataAuthProvider).value != null &&
                            auth.currentUser != null) {
                          // ------
                          var data = {
                            colProductId: widget.product.id,
                            colPrice: checkNumber(discountProduct()),
                            colQty: 1,
                            colTotalPrice: checkNumber(discountProduct()),
                          };
                          await ref
                              .read(orderControllerProvider)
                              .addedProductToCart(
                                  context: context,
                                  txtUserId: auth.currentUser!.uid,
                                  data: data);
                          // var sumOrderDetailsProvider = await ref
                          //     .read(sumProductOrdersDetailsProvider.notifier);
                          // sumOrderDetailsProvider.state.sumQtyOrder += 1;
                          // sumOrderDetailsProvider.state.sumTotalOrder +=
                          //     checkNumber(discountProduct());
                        } else {
                          msgBox(context, 'قم بتسجيل الدخول  اولا');
                        }
                        //  setState(() {
                        //   _isLoading = false;
                        // });
                      } catch (e) {
                        print('----: $e');
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String discountProduct() {
    num resault = 0;

    if (widget.product.discount != 0) {
      if (widget.product.price > widget.product.discount) {
        resault = (widget.product.price - widget.product.discount);
      }
      if (widget.product.price < widget.product.discount) {
        resault = (widget.product.discount - widget.product.price);
      }

      return resault.abs().toStringAsFixed(1);
    } else
      return widget.product.price.toStringAsFixed(2);

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
}


/**
 * child: CachedNetworkImage(
                        imageUrl: product.images.first,
                        width: getProportionateScreenWidth(width),
                        // fit: BoxFit.cover,
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
 */
import 'package:flutter/material.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/widgets/app_bar_back_widget.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../../../../common/utils/utils.dart';
import '../../models/product.dart';
import '/constants.dart';
import 'widgets/body_product_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  // final Product1 product;

  // const ProductDetailsScreen({Key? key, required this.product})
  // : super(key: key);
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
      // each product have a color
      backgroundColor: kPrimaryLightColor,
      appBar: appbarBackWidget(context),
      body: BodyProductWidget(product: product),
      floatingActionButton: AvatarGlow(
        glowColor: Colors.red,
        endRadius: 50,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        curve: Curves.easeOutQuad,
        child: FloatingActionButton(
          backgroundColor: appBarColor,
          onPressed: () => launchInBrowser(
            // 'wa.me',
            ///'/966533285583/?text=مرحبا%20بديل%20الذهب%20اريد%20الحصول%20على%20هذا%0Aالمنتج%20${product.name}',
            'http://wa.me/966533285583/?text=مرحبا%20بديل%20الذهب%20اريد%20الحصول%20على%20هذا%0Aالمنتج%20${product.name}',
          ),
          child: Icon(
            Icons.chat,
            // size: 40,
          ),
        ),
      ),
    );
  }
}

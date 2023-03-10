import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myproject/features/orders/controller/cart_provider.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/orders/screens/cart/components/check_out_card.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/widgets/list_tile_animation_widget.dart';
import '../../../../../common/widgets/error.dart';
import '../../../../../common/widgets/loader.dart';

import '../../../../product/models/product.dart';
import '/size_config.dart';
import 'card_order_details_widget.dart';

class Body extends ConsumerStatefulWidget {
  Body();
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends ConsumerState<Body> {
  ScrollController? scrollController1 = ScrollController();
  num sumTotalOrder = 0.0;
  @override
  Widget build(BuildContext context) {
    var sumOrdrsPro = ref.read(resaultOrdersProvider.notifier);
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: ref.watch(getOrderDetailsUserStreamProvider).when(
              data: (dataList) {
                if (dataList == null || dataList.isEmpty || dataList == []) {
                  return cartEmptyMethod();
                }
                sumTotalOrder = 0.0;

                return Scaffold(
                  body: Scrollbar(
                    thickness: 5,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    interactive: true,
                    radius: Radius.circular(30),
                    controller: scrollController1,
                    thumbVisibility: true,
                    child: AnimationLimiter(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        key: PageStorageKey<String>('cartPg'),
                        itemCount: dataList.length,
                        controller: scrollController1,
                        itemBuilder: (context, index) {
                          sumTotalOrder += dataList[index].totalPrice;

                          if (dataList[index] == dataList.last) {
                            sumOrdrsPro.state.sumTotalOrder = sumTotalOrder;
                          }
                          return ListTileAnimation(
                            index: index,
                            child: cartDetailsMethod(dataList, dataList[index]),
                          );
                        },
                      ),
                    ),
                  ),
                  bottomNavigationBar: CheckoutCard(
                    order: dataList.first.order,
                    sumCartsTotale: sumOrdrsPro.state.sumTotalOrder,
                  ),
                );
              },
              error: (err, trace) {
                if (err.toString().trim() == 'Bad state: No element'.trim())
                  return cartEmptyMethod();
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            ),
      ),
    );
  }

  Center cartEmptyMethod() {
    return Center(
      child: Text(
        'السلة فارغة',
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget cartDetailsMethod(List<OrderDetails> rows, OrderDetails row) {
    // Product? _product;
    return ref.watch(getProductFutureProvider).when(
          data: (dataList) {
            if (dataList == null || dataList.isEmpty || dataList == []) {
              ref.refresh(getProductFutureProvider);
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('لا يوجد بيانات'),
                    Text('جرب إعداة تحميل الصفحة'),
                  ],
                ),
              );
            }
            if (dataList != null) {
              row.product = loadProduct(dataList, row.productId);
              if (row.product == null)
                row.product = loadProduct(dataList, row.productId);
            }
            if (row.product == null) {
              ref.read(orderControllerProvider).deleteRowOrderDetails(
                    context: context,
                    txtOrderDetailsId: row.id,
                  );
              return Container();
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  // key: ObjectKey(row),
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {},
                  confirmDismiss: (DismissDirection direction) async {
                    if (row.id != '') {
                      ref.read(orderControllerProvider).deleteRowOrderDetails(
                          context: context, txtOrderDetailsId: row.id);
                      var sumOrderDetailsProvider =
                          await ref.read(resaultOrdersProvider.notifier);
                      sumOrderDetailsProvider.state.sumQtyOrder -= row.qty;
                      sumOrderDetailsProvider.state.sumTotalOrder -=
                          row.totalPrice;
                      return true;
                    } else
                      return false;
                  },
                  background: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE6E6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset("assets/icons/Trash.svg"),
                      ],
                    ),
                  ),
                  child: CardOrderDetailsWidget(cartDetails: row),
                ),
              ),
            );
          },
          error: (err, trace) {
            return ErrorScreen(
              error: err.toString(),
            );
          },
          loading: () => Loader(),
        );
  }

  Product? loadProduct(List<Product> products, productId) {
    var row = products.where((element) => element.id.trim() == productId);
    if (row.isNotEmpty)
      return row.first;
    else
      return null;
  }
}

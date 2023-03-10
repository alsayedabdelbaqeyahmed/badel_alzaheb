import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/var_public.dart';
import 'package:myproject/widgets/app_bar_widget.dart';
import 'package:myproject/widgets/divider_widget.dart';
import 'package:myproject/widgets/image_gallery_widget.dart';
import 'package:myproject/widgets/image_network_widget.dart';
import 'package:myproject/widgets/nodata_widget.dart';

import '../controller/cart_provider.dart';

class OrdersDetailsScreen extends ConsumerStatefulWidget {
  static const String routeName = '/orders-details-screen';

  OrdersDetailsScreen({
    required this.order,
    required this.txtOrderId,
  });
  Order order;
  String txtOrderId;
  @override
  ConsumerState<OrdersDetailsScreen> createState() =>
      _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends ConsumerState<OrdersDetailsScreen> {
  ScrollController? scrollController1 = ScrollController();
  num sumTotalOrder = 0.0;
  num sumQtyOrder = 0.0;
  @override
  Widget build(BuildContext context) {
    // sumOrderDetailsProvider.sumTotalOrder
    var sumOrdrsPro = ref.read(resaultOrdersProvider.notifier);

    return Scaffold(
      appBar: AppBarWidget(
        'تفاصيل الطلب',
        widgetActions: Container(
          padding: const EdgeInsets.only(left: 15, top: 17),
          child: Text(
            '${sumOrdrsPro.state.lenghtOrderdetails_finished}',
            style: TextStyle(
              color: appBarColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<OrderDetails>>(
        future: ref.watch(orderControllerProvider).getOrderDetailsWhereFuture(
              order: widget.order,
              orderId: widget.txtOrderId,
            ),
        builder: (context, snapshot) {
          List<OrderDetails>? dataList = snapshot.data;
          sumTotalOrder = 0.0;
          sumQtyOrder = 0.0;
          if (dataList == null || dataList.isEmpty || dataList == []) {
            return NoDataWidget();
          }
          if (snapshot.hasError) {
            return ErrorScreen(
              error: snapshot.error.toString(),
            );
          }
          if (snapshot.hasError) {
            return const Loader();
          }
          sumTotalOrder = 0.0;
          sumQtyOrder = 0.0;
          return Scaffold(
            body: Scrollbar(
              thickness: 5,
              scrollbarOrientation: ScrollbarOrientation.right,
              interactive: true,
              radius: Radius.circular(30),
              controller: scrollController1,
              thumbVisibility: true,
              child: ListView.separated(
                separatorBuilder: (context, index) => DividerWidget(),
                itemCount: dataList.length,
                // shrinkWrap: true,
                controller: scrollController1,
                itemBuilder: (context, index) {
                  var row = dataList[index];

                  sumQtyOrder += dataList[index].qty;
                  sumTotalOrder += dataList[index].totalPrice;

                  if (dataList[index] == dataList.last) {
                    sumOrdrsPro.state.sumTotalOrder_finished = sumTotalOrder;
                    sumOrdrsPro.state.sumQtyOrder_finished = sumQtyOrder;
                  }
                  return cartDetailsMethod(row);
                },
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                vertical: (20),
                horizontal: (30),
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
                    color: shadowColor.withOpacity(0.15),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'الاجمالي:${sumOrdrsPro.state.sumTotalOrder_finished}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'الكمية:${sumOrdrsPro.state.sumQtyOrder_finished}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget cartDetailsMethod(OrderDetails row) {
    // Product? _product;
    return ref.watch(getProductFutureProvider).when(
          data: (dataList) {
            if (dataList == null || dataList.isEmpty || dataList == []) {
              ref.refresh(getProductFutureProvider);
              return NoDataWidget();
            }
            if (dataList != null) {
              row.product = loadProduct(dataList, row.productId);
              if (row.product == null)
                row.product = loadProduct(dataList, row.productId);
            }
            return Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 13),
              child: Row(
                children: [
                  // image
                  GestureDetector(
                    onTap: () {
                      openImage(context, row.product!.images.first);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: 88,
                        child: AspectRatio(
                          aspectRatio: 0.88,
                          child: Container(
                            // padding: EdgeInsets.all(getProportionateScreenWidth(10)),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              // color: Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ImageNetWorkWidget(
                              image: row.product!.images[0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  spaceW,

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${row.product!.name}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'سعر الحبة: ${row.price}',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        maxLines: 2,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${row.totalPrice.toString()} $varCurrCode",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                          spaceW,
                          spaceW,
                          Text(
                            "الكمية:${row.qty.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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

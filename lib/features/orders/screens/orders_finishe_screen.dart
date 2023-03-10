import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/screens/widgets/card_order_widget.dart';
import 'package:myproject/widgets/app_bar_widget.dart';
import 'package:myproject/widgets/list_tile_animation_widget.dart';
import 'package:myproject/widgets/nodata_widget.dart';

import '../../../widgets/datetime_field_widget.dart';

Timestamp fromDate = Timestamp.fromDate(
  DateTime.now().subtract(const Duration(days: 5)),
);
Timestamp ToDate = Timestamp.fromDate(DateTime.now());

class OrdersFinisheScreen extends ConsumerStatefulWidget {
  static const String routeName = '/orders-finishe-screen';

  // StreamProvider<List<Order>> getOrderStreamProvider
  @override
  ConsumerState<OrdersFinisheScreen> createState() => _OrdersNewScreenState();
}

class _OrdersNewScreenState extends ConsumerState<OrdersFinisheScreen> {
  ScrollController? scrollController1 = ScrollController();
  TextEditingController txtFromDate = TextEditingController(
      text: DateTime.now().subtract(const Duration(days: 5)).toString());
  TextEditingController txtToDate =
      TextEditingController(text: DateTime.now().toString());

  @override
  Widget build(BuildContext context) {
    // من تاريخ الى تاريخ
    return Scaffold(
      appBar: AppBarWidget('الطلبات'),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            spaceH10,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: DateTimeFieldWidget(
                      labelText: 'من تاريخ',
                      onPressed: () async {
                        try {
                          txtFromDate.text = await selectDate(context);
                          fromDate = Timestamp.fromDate(
                              await toDateTime(txtFromDate.text));
                        } catch (e) {
                          print('Ex--$e');
                        }
                      },
                      controller: txtFromDate,
                    ),
                  ),
                  spaceW10,
                  Expanded(
                    flex: 3,
                    child: DateTimeFieldWidget(
                      labelText: 'إلى تاريخ',
                      controller: txtToDate,
                      onPressed: () async {
                        try {
                          txtToDate.text = await selectDate(context);
                          ToDate = Timestamp.fromDate(
                              await toDateTime(txtToDate.text));
                          ref.refresh(getOrdersUserFutureProvider);
                        } catch (e) {
                          print('Ex--$e');
                        }
                      },
                    ),
                  ),
                  /*   Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(right: 3),
                        padding: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: IconButton(
                          icon: Icon(
                            Icons.receipt_outlined,
                            color: appBarColor,
                          ),
                          onPressed: () {
                            if (subscripList.isNotEmpty) {
                              showSnackBar(
                                  context: context, content: 'جاري التحميل...');
                              Future.delayed(Duration(seconds: 1), () async {
                                var pdfFile =
                                    await PdfEstsharay.generate(subscripList, '');

                                PdfApi.openFile(pdfFile);
                              });
                            } else
                              showSnackBar(
                                context: context,
                                content: 'لا يوجد اشتراكات محدده',
                              );
                          },
                        ),
                      ),
                    ),
               */
                ],
              ),
            ),
            spaceH10,
            Container(
              child: ref.watch(getOrdersUserFutureProvider).when(
                    data: (dataList) {
                      if (dataList == null ||
                          dataList.isEmpty ||
                          dataList == []) {
                        return NoDataWidget();
                      }
                      return Scrollbar(
                        thickness: 7,
                        scrollbarOrientation: ScrollbarOrientation.right,
                        interactive: true,
                        radius: Radius.circular(30),
                        controller: scrollController1,
                        thumbVisibility: true,
                        child: AnimationLimiter(
                          child: ListView.builder(
                            // physics: BouncingScrollPhysics(
                            //   parent: AlwaysScrollableScrollPhysics(),
                            // ),
                            key: PageStorageKey<String>('ordeFinishedrPg'),
                            itemCount: dataList.length,
                            shrinkWrap: true,
                            controller: scrollController1,
                            itemBuilder: (context, index) {
                              var row = dataList[index];
                              return ListTileAnimation(
                                  index: index,
                                  child: CardOrderWidget(row: row));
                            },
                          ),
                        ),
                      );
                    },
                    error: (err, trace) {
                      if (err.toString().trim() ==
                          'Bad state: No element'.trim()) return NoDataWidget();
                      return ErrorScreen(
                        error: err.toString(),
                      );
                    },
                    loading: () => const Loader(),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

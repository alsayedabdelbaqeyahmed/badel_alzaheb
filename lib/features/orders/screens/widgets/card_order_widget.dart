import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/orders/screens/orders_details_screen.dart';
import 'package:myproject/models/user_model.dart';
import 'package:myproject/widgets/divider_widget.dart';

class CardOrderWidget extends ConsumerWidget {
  const CardOrderWidget({
    Key? key,
    required this.row,
  }) : super(key: key);

  final Order row;

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(userDataAuthProvider).when(
          data: (dataList) {
            if (dataList == null || dataList == []) {
              ref.refresh(userDataAuthProvider);
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

            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      OrdersDetailsScreen(order: row, txtOrderId: row.id),
                ),
              ),
              child: Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      spaceH,
                      Text(
                        'رقم الطلب:  ${row.theNumber}',
                        style: TextStyle(fontSize: 18),
                      ),
                      DividerWidget(),
                      Text(
                        'تاريخ الطلب:  ${row.enterDate}',
                        style: TextStyle(fontSize: 18),
                      ),
                      if (row.isFinished == true) DividerWidget(),
                      if (row.isFinished == true) spaceH10,
                      if (row.isFinished == true)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'التوصيل: ${row.amountDelivery}',
                            ),
                            spaceW10,
                            Text(
                              'الإجمالي: ${row.total}',
                            ),
                          ],
                        ),
                      DividerWidget(),
                      spaceH10,

                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                            color: row.isFinished == true
                                ? shadowColor
                                : appBarColor,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          '${row.isFinished == true ? 'اكتمل الطلب' : 'لم يكتمل الطلب بعد'}',
                          style: TextStyle(
                            color: backgroundColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      DividerWidget(),
                      spaceH10,
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                            color: row.isReceived == true
                                ? shadowColor
                                : Colors.red.shade900,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          '${row.isReceived == true ? 'تم الارسال' : 'لم يتم الارسال بعد'}',
                          style: TextStyle(
                            color: backgroundColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Text(
                      //       'الكمية: ${row.count}',
                      //     ),
                      //     spaceW10,
                      //     Text(
                      //       'الإجمالي: ${row.total}',
                      //     ),
                      //   ],
                      // ),
                      DividerWidget(),
                      /*  Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            decoration: BoxDecoration(
                                color: appBarColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              '${row.user!.name}',
                              style: TextStyle(
                                color: backgroundColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.phone),
                          //   color: Colors.red,
                          //   onPressed: () =>
                          //       launchCaller(row.user!.phoneNumber.trim()),
                          // ),
                        ],
                      ),*/
                    ],
                  ),
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

  UserModel? loadUser(List<UserModel> users, userId) {
    var row = users.where((element) => element.uid.trim() == userId);
    if (row.isNotEmpty)
      return row.first;
    else
      return null;
  }
}

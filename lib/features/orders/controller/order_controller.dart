import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/features/orders/controller/cart_provider.dart';
import 'package:myproject/features/orders/controller/count_provider.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/models/user_model.dart';
import 'package:myproject/routes.dart';

final getOrdersUserFutureProvider = FutureProvider(
  (ref) => OrderController.getOrdersUserFuture(),
);
final getOrderDetailsUserStreamProvider = StreamProvider<List<OrderDetails>>(
  (ref) {
    final controllerProvider = ref.watch(orderControllerProvider);
    return controllerProvider.getOrderDetailsStream();
  },
);
// final getOrderActiveteFutureProvider = FutureProvider(
//   (ref) => OrderController.getOrderActiveteFuture(),
// );
// final getOrderStreamProvider = StreamProvider<List<Order>>(
//   (ref) => OrderController.getOrderStream(),
// );

final orderControllerProvider = Provider(
  (ref) {
    return OrderController(ref: ref);
  },
);

class OrderController {
  final ProviderRef ref;
  OrderController({
    required this.ref,
  });

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final cloud_firestore.FirebaseFirestore firestore =
      cloud_firestore.FirebaseFirestore.instance;

  static Future<List<Order>> getOrdersUserFuture() {
    try {
      return firestore
          .collection(tblOrder)
          .where(colUserId, isEqualTo: auth.currentUser!.uid)
          // .where(colIsFinished, isEqualTo: false)
          .get()
          .then((event) {
        List<Order> orders = [];
        for (var document in event.docs) {
          orders.add(Order.fromJson(document.id, document.data()));
        }
        return orders;
      });
    } on FirebaseAuthException catch (e) {
      // msgBox(context, e.message!); // Displaying the error message
      return Future.error(e);
    }
  }

  Future<List<OrderDetails>> getOrderDetailsWhereFuture({
    required Order order,
    required String orderId,
  }) {
    try {
      return firestore
          .collection(tblOrderDetails)
          .where(colOrderId, isEqualTo: orderId)
          .get()
          .then((event) {
        List<OrderDetails> newList = [];

        var sumOrdrsPro = ref.read(resaultOrdersProvider.notifier);
        sumOrdrsPro.state.sumTotalOrder_finished = 0.0;
        sumOrdrsPro.state.sumQtyOrder_finished = 0.0;
        for (var document in event.docs) {
          // fill list data
          var newRow = OrderDetails.fromJson(
            document.id,
            document.data(),
            order,
          );
          newList.add(newRow);
          sumOrdrsPro.state.sumTotalOrder_finished += newRow.totalPrice;
          sumOrdrsPro.state.sumQtyOrder_finished += newRow.qty;
        }
        sumOrdrsPro.state.lenghtOrderdetails_finished = newList.length;

        return newList;
      });
    } on FirebaseAuthException catch (e) {
      return Future.error(e);
    }
  }

  // static Future<List<Order>> getOrderActiveteFuture() {
  //   try {
  //     return firestore
  //         .collection(tblOrder)
  //         .where(colUserId, isEqualTo: auth.currentUser!.uid)
  //         .where(colIsFinished, isEqualTo: false)
  //         .get()
  //         .then((event) {
  //       List<Order> orders = [];
  //       for (var document in event.docs) {
  //         orders.add(Order.fromJson(document.id, document.data()));
  //       }
  //       return orders;
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     // msgBox(context, e.message!); // Displaying the error message
  //     return Future.error(e);
  //   }
  // }

  // static Stream<List<Order>> getOrderActiveteStream() {
  //   try {
  //     return firestore
  //         .collection(tblOrder)
  //         .where(colUserId, isEqualTo: auth.currentUser!.uid)
  //         .where(colIsFinished, isEqualTo: false)
  //         .snapshots()
  //         .map((event) {
  //       List<Order> orders = [];
  //       for (var document in event.docs) {
  //         orders.add(Order.fromJson(document.id, document.data()));
  //       }
  //       return orders;
  //     });
  //   } on FirebaseAuthException catch (e) {
  //     // msgBox(context, e.message!); // Displaying the error message
  //     return Stream.error(e);
  //   }
  // }

//   static Stream<List<OrderDetails>>? getOrderDetailsStreamOld() {
//     try {
//       var rowOrder = getOrderActiveteFuture();
//       // print('===============${rowOrder}');
//       // print('===============${rowOrder.first.}');
//       rowOrder.then((element) {
//         print('===============${element.isNotEmpty}');
//         print('===============${element.first.id}');

//         if (element.isNotEmpty) {
//           return firestore
//               .collection(tblOrderDetails)
//               .where(colOrderId, isEqualTo: element.first.id)
//               .snapshots()
//               .map((event) {

//             List<OrderDetails> newList = [];
//             for (var document in event.docs) {
// // fill list data
//               newList.add(
//                   OrderDetails.fromJson(document.id, document.data(), null));
//             }

//             return newList;
//           });
//         } else
//           return [];
//       });
//     } on FirebaseAuthException catch (e) {
//       return Stream.error(e);
//     }
//   }

  Stream<List<OrderDetails>> getOrderDetailsStream() {
    try {
      var rowOrder = firestore
          .collection(tblOrder)
          .where(colUserId, isEqualTo: auth.currentUser!.uid)
          .where(colIsFinished, isEqualTo: false)
          .snapshots()
          .map((event) {
        List<Order> orders = [];
        for (var document in event.docs) {
          orders.add(Order.fromJson(document.id, document.data()));
        }
        return orders;
      });

      return rowOrder.asyncMap((element) async {
        // if (element.isNotEmpty) {

        return firestore
            .collection(tblOrderDetails)
            .where(colOrderId, isEqualTo: element.first.id)
            .snapshots()
            .first
            .then((event) {
          List<OrderDetails> newList = [];
          num sumTotalOrder = 0.0;

          var sumOrdrsPro = ref.read(resaultOrdersProvider.notifier);
          sumOrdrsPro.state.sumTotalOrder = 0.0;
          sumOrdrsPro.state.sumQtyOrder = 0.0;
          sumOrdrsPro.state.lenghtOrderdetails = 0.0;
          for (var document in event.docs) {
            // fill list data
            var newRow = OrderDetails.fromJson(
              document.id,
              document.data(),
              element.first,
            );
            newList.add(newRow);
            sumOrdrsPro.state.sumTotalOrder += newRow.totalPrice;
            sumOrdrsPro.state.sumQtyOrder += newRow.qty;
          }
          sumOrdrsPro.state.lenghtOrderdetails = newList.length;
          return newList;
        });
      });
    } on FirebaseAuthException catch (e) {
      return Stream.error(e);
    }
  }

  // Future<void> getDataaa({
  //   required BuildContext context,
  //   required String txtUserId,
  //   required Map<String, dynamic> data,
  //   // required Map<String, dynamic> product,
  // }) async {
  //   compute(addedProductToCart(context: context, txtUserId: txtUserId, data: data), {context, txtUserId, data});
  // }

  Future<void> addedProductToCart({
    required BuildContext context,
    required String txtUserId,
    required Map<String, dynamic> data,
    // required Map<String, dynamic> product,
  }) async {
    // Future<void> addedProductToCart( BuildContext context,
    //     String txtUserId,
    //     Map<String, dynamic> data,
    //   // required Map<String, dynamic> product,
    // ) async {
    try {
      // =======================
      var sumOrdersProvider = await ref.read(resaultOrdersProvider.notifier);
      sumOrdersProvider.state.sumQtyOrder += data[colQty];
      sumOrdersProvider.state.sumTotalOrder += data[colTotalPrice];

      // =======================
      var checkOrderOld = await firestore
          .collection(tblOrder)
          .where(colUserId, isEqualTo: auth.currentUser!.uid) // or txtUserId
          .where(colIsFinished, isEqualTo: false)
          .get();

      msgBox(context, 'تمت الإضافة إلى السلة');

      // added product to order New
      // طلب جديد
      if (checkOrderOld.docs.isEmpty) {
        String theNumber = new DateTime.now().millisecondsSinceEpoch.toString();
        var rowOrderNew = await firestore.collection(tblOrder).add({
          colTheNumber: theNumber,
          colUserId: txtUserId,
          colEnterDate: DateTime.now(),
          colIsFinished: false,
          colIsReceived: false,
          colSubTotal: checkNumber(data[colPrice]),
          colCountProduct: checkNumber(data[colQty]),
          colTotal: checkNumber(data[colTotalPrice]),
          colAmountDelivery: 0,
        });
        // ------------- order details added
        if ((await rowOrderNew.get()).exists) {
          data[colOrderId] = await (await rowOrderNew.get()).id;
          data[colOrderNumber] = theNumber;

          var orderDetailsNew =
              await firestore.collection(tblOrderDetails).add(data);
          await ref.read(countProvider).restartCounter();
          // msgBox(context, 'تمت الإضافة إلى السلة');
          await ref.refresh(getOrderDetailsUserStreamProvider);
        }
      }

      // ==========================
      // added product to order old
      // طلب سابق
      if (checkOrderOld.docs.isNotEmpty) {
        if (checkOrderOld.docs.first.data() != null) {
          data[colOrderId] = await checkOrderOld.docs.first.id;
          data[colOrderNumber] =
              await checkOrderOld.docs.first.data()[colTheNumber];
          // تحقق من ان المنتج موجود مسبقا
          var checkProductOld = await firestore
              .collection(tblOrderDetails)
              .where(colOrderId, isEqualTo: checkOrderOld.docs.first.id.trim())
              .where(colProductId, isEqualTo: data[colProductId].trim())
              .get();
          // اذا كان المنتج موجود مسبقا
          if (checkProductOld.docs.isNotEmpty) {
            var rowOrderDetailsOld = await checkProductOld.docs.first.data();
            // update product old
            var dataUpdate = {
              // colProductId:data[colProductId],
              colPrice: data[colPrice], // rowOrderDetailsOld[colPrice] +
              colQty: data[colQty] + rowOrderDetailsOld[colQty],
              colTotalPrice:
                  data[colTotalPrice] + rowOrderDetailsOld[colTotalPrice],
            };
            var updateOrderDetails = await firestore
                .collection(tblOrderDetails)
                .doc(checkProductOld.docs.first.id.trim())
                .update(dataUpdate);
          }
          // اذا كان المنتج غير موجود مسبقا
          if (checkProductOld.docs.isEmpty) {
            data[colOrderNumber] =
                checkOrderOld.docs.first.data()[colTheNumber];
            // added new product
            var newOrderDetails =
                await firestore.collection(tblOrderDetails).add(data);
          }

          await ref.read(countProvider).restartCounter();
          // msgBox(context, 'تمت الإضافة إلى السلة');
          await ref.refresh(getOrderDetailsUserStreamProvider);
        }
      }
      // orderRow.docs.forEach((element) {});
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
      return Future.error(e);
    }
  }

  Future<void> updateCartOrderDetails({
    required BuildContext context,
    required String txtOrderDetailsId,
    required num qty,
    required num price,
  }) async {
    try {
      if (qty > 0 && txtOrderDetailsId.trim() != '') {
        var updateOrderDetails = await firestore
            .collection(tblOrderDetails)
            .doc(txtOrderDetailsId.trim())
            .update({
          colPrice: price,
          colQty: qty,
          colTotalPrice: price * qty,
        });
        msgBox(context,
            'السعر: $price  | الكمية: $qty | الإجمالي: ${price * qty}');
        await ref.refresh(getOrderDetailsUserStreamProvider);
      }
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
      return Future.error(e);
    }
  }

  Future<void> deleteRowOrderDetails({
    required BuildContext context,
    required String txtOrderDetailsId,
    // required num qty,
    // required num price,
  }) async {
    try {
      if (txtOrderDetailsId.trim() != '') {
        var updateOrderDetails = await firestore
            .collection(tblOrderDetails)
            .doc(txtOrderDetailsId.trim())
            .delete();

        ref.refresh(getOrderDetailsUserStreamProvider);
      }
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
      return Future.error(e);
    }
  }

  Future<bool?> finishedOrder({
    required BuildContext context,
    required String txtOrderId,
    required Map<String, dynamic> dataOrder,
    required Map<String, dynamic> dataPayment,
    // required num sumQty,
    // required num amountDevliver,
    // required num sumSubTotal,
    // required num sumTotal,
  }) async {
    try {
      if (txtOrderId.trim() != '' && dataOrder.isNotEmpty) {
        await firestore
            .collection(tblOrder)
            .doc(txtOrderId)
            .update(dataOrder)
            .onError((error, stackTrace) {
          msgBox(context, 'يوجد مشكلة في اكمال الطلب');
          msgBox(context, 'ان استمرت هذه المشكلة تواصل معنا');
          return false;
        });
        await firestore.collection(tblPayment).add(dataPayment);
        await msgBox(context, 'تم اكمال الطلب بنجاح');

        await ref.refresh(getOrderDetailsUserStreamProvider);
        Navigator.pushNamedAndRemoveUntil(context, go_main, (route) => false);

        await msgBox(context, 'سيتم التواصل معك في اقرب وقت لتسليم البضاعة');
        await msgBox(context, 'يمكنك متابعة حالة طلبك في قائمة الطلبات.');
        await ref.refresh(getOrdersUserFutureProvider);
        return true;
      } else
        return false;
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
      return Future.error(e);
    }
  }
}

num checkNumber(text) {
  String txt = text.toString();
  num.tryParse(txt);

  if (num.tryParse(txt) == null) {
    txt = "0";
    // ((TextBox)sender).SelectAll();
    return 0.0;
  } else
    return num.tryParse(txt)!;
}

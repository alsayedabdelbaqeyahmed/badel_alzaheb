import 'package:flutter_riverpod/flutter_riverpod.dart';

// مجموع الطلبات السابقة والسلة
final resaultOrdersProvider = StateProvider(
  (ref) => SumOrderDetailsProvider(),
);

class SumOrderDetailsProvider {
  // extends StateNotifier
  num sumTotalOrder = 0;
  num sumQtyOrder = 0;
  num sumSubTotalOrder = 0;
  num lenghtOrderdetails = 0;
  // where
  num sumTotalOrder_finished = 0;
  num sumQtyOrder_finished = 0;
  num sumSubTotalOrder_finished = 0;
  num lenghtOrderdetails_finished = 0;
}

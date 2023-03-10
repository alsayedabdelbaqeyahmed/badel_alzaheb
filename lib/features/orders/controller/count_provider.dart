import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ==============
// عداد المنتجات الخاص بالسلة
final countProvider = ChangeNotifierProvider<CountProvider>(
  (ref) {
    return CountProvider();
  },
);

class CountProvider extends ChangeNotifier {
  num counter = 1;

  incrmentCounter() {
    counter++;
    notifyListeners();
  }

  decrmentCounter() {
    if (counter > 1) {
      counter--;
      notifyListeners();
    }
  }

  restartCounter() {
    counter = 1;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

// ========================
// final productProvider = ChangeNotifierProvider.autoDispose<ProductProvider>(
//   (ref) {
//     return ProductProvider();
//   },
// );

// class ProductProvider extends ChangeNotifier {
//   Product? product;

//   selectProduct(row) {
//     product = row;
//     notifyListeners();
//   }

//   restartCounter() {
//     product = null;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//   }
// }

// final countProvider = StateProvider(
//   (ref) {
//     return CountProvider();
//   },
// );

// class CountProvider {
//   int counter = 1;

//   incrmentCounter() {
//     counter++;
//   }

//   decrmentCounter() {
//     counter++;
//   }
// }
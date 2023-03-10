import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/orders/models/shipping_and_payment.dart';
import 'package:myproject/models/city.dart';

final getShippingFutureProvider = FutureProvider(
  (ref) => SettingController.getShippingFuture(),
);

final getCityFutureProvider = FutureProvider(
  (ref) => SettingController.getCityFuture(),
);

final settingControllerProvider = Provider(
  (ref) {
    return SettingController(ref: ref);
  },
);

class SettingController {
  final ProviderRef ref;
  SettingController({
    required this.ref,
  });

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<City>> getCityFuture() {
    return firestore.collection(tblCity).get().then((event) {
      List<City> newList = [];
      for (var document in event.docs) {
        newList.add(City.fromJson(document.id, document.data()));
        print(newList);
      }
      return newList;
    });
  }

  static Future<List<Shipping>> getShippingFuture() {
    return firestore.collection(tblShipping).get().then((event) {
      List<Shipping> newList = [];
      for (var document in event.docs) {
        newList.add(Shipping.fromJson(document.id, document.data()));
        print(newList);
      }
      return newList;
    });
  }
}

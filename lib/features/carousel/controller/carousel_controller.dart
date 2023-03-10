import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/carousel/models/carousel.dart';

final getCarouselFutureProvider = FutureProvider(
  (ref) => CarouselController.getCarouselFuture(),
);
final getCarouselStreamProvider = StreamProvider(
  (ref) => CarouselController.getCarouselStream(),
);

final carouselControllerProvider = Provider(
  (ref) {
    return CarouselController(ref: ref);
  },
);

class CarouselController {
  final ProviderRef ref;
  CarouselController({
    required this.ref,
  });

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<List<Carousel>> getCarouselFuture() {
    return firestore.collection(tblCarousel).get().then((event) {
      List<Carousel> carousels = [];
      for (var document in event.docs) {
        carousels.add(Carousel.fromJson(document.id, document.data()));
      }
      return carousels;
    });
  }

  static Stream<List<Carousel>> getCarouselStream() {
    return firestore.collection(tblCarousel).snapshots().map((event) {
      List<Carousel> carousels = [];
      for (var document in event.docs) {
        carousels.add(Carousel.fromJson(document.id, document.data()));
      }
      return carousels;
    });
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/carousel/models/carousel.dart';
import 'package:myproject/features/product/models/category.dart';
import 'package:myproject/features/product/models/product.dart';

final getProductFutureProvider = FutureProvider(
  (ref) => CategoryController.getProductsFuture(),
);
final getProductPopularFutureProvider = FutureProvider(
  (ref) => CategoryController.getProductPopularFuture(),
);

// ================================================

final getCategoryFutureProvider = FutureProvider(
  (ref) => CategoryController.getCategoryFuture(),
);

final categoryControllerProvider = Provider(
  (ref) {
    return CategoryController(ref: ref);
  },
);

class CategoryController {
  final ProviderRef ref;
  CategoryController({
    required this.ref,
  });

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // ====================================================== Category

  static Future<List<Category>> getCategoryFuture() {
    return firestore.collection(tblCategory).get().then((event) {
      List<Category> newList = [];
      for (var document in event.docs) {
        newList.add(Category.fromJson(document.id, document.data()));
      }
      return newList;
    });
  }

  static Future<List<Product>> getProductWhereFuture({
    required String field,
    required dynamic search,
  }) {
    return firestore
        .collection(tblProduct)
        .where(colIsActive, isEqualTo: true)
        .where(field, isEqualTo: search)
        .get()
        .then((event) {
      List<Product> newList = [];
      for (var document in event.docs) {
        newList.add(Product.fromJson(document.id, document.data()));
      }
      return newList;
    });
  }

  static Future<List<Product>> getProductPopularFuture() {
    return firestore
        .collection(tblProduct)
        .where(colIsActive, isEqualTo: true)
        .where(colisPopular, isEqualTo: true)
        .get()
        .then((event) {
      List<Product> newList = [];
      for (var document in event.docs) {
        newList.add(Product.fromJson(document.id, document.data()));
      }
      return newList;
    });
  }

  static Future<List<Product>> getProductsFuture() {
    return firestore
        .collection(tblProduct)
        .where(colIsActive, isEqualTo: true)
        .get()
        .then((event) {
      List<Product> productsNewList = [];
      for (var document in event.docs) {
        productsNewList.add(Product.fromJson(document.id, document.data()));
      }
      return productsNewList;
    });
  }

  Future<List<Product>> getProductsWhereCatIdFuture(
    String categoryId,
  ) {
    return firestore
        .collection(tblProduct)
        .where(colIsActive, isEqualTo: true)
        .where(colCategoryId, isEqualTo: categoryId.trim())
        .get()
        .then((event) {
      List<Product> productsNewList = [];
      for (var document in event.docs) {
        productsNewList.add(Product.fromJson(document.id, document.data()));
      }
      return productsNewList;
    });
  }
}

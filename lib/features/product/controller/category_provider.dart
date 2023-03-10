import 'package:flutter/cupertino.dart';

import '../models/category.dart';

class CategoryProvider extends ChangeNotifier {
  Category? category;

  // CategoryProvider() {}
  Future<void> selectCategory(context, Category row) async {
    category = row;
    notifyListeners();
  }

  void clearCategory() {
    category = null;
    notifyListeners();
  }
}

CategoryProvider categoryProvider = CategoryProvider();

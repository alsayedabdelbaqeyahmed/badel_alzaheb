import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/models/account.dart';

// variable order
const colorderDate = 'order_date',
    colorderData_list = 'details',
    colIsFinished = 'is_finished',
    colTotal = 'total',
    colProductCount = 'product_count';
// variable order Details
const colQty = 'quantity',
    colSubTotal = 'subtotal',
    colPrice_Order = 'price',
    colDiscount = 'discount',
    colProductOrderID = 'product';

class Cart {
  final Product product;
  final int numOfItem;

  Cart({required this.product, required this.numOfItem});
}

// Demo data for our cart

List<dynamic> Order_list = [];
List<dynamic> orderData_list = [];

List<Cart> demoCarts = [
  // Cart(product: productsList[0], numOfItem: 2),
  // Cart(product: productsList[1], numOfItem: 4),
  // Cart(product: productsList[3], numOfItem: 1),
];

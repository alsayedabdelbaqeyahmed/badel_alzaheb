import 'package:myproject/features/carousel/models/carousel.dart';
import 'package:myproject/features/product/models/product.dart';

const tblShipping = 'Shipping';

class Shipping {
  String id, name;
  num price;
  // num price;

  Shipping({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Shipping.fromJson(String colId, Map<String, dynamic> json) =>
      Shipping(
        id: colId,
        name: json[colName] ?? '',
        price: json[colPrice] ?? 0.0,
      );
}

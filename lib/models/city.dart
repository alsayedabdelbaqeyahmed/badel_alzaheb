import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/models/user_model.dart';

const tblCity = 'City';

class City {
  String id, name;
  num price;

  City({
    required this.id,
    required this.name,
    required this.price,
  });

  factory City.fromJson(String colId, Map<String, dynamic> json) => City(
        id: colId,
        price: json[colPrice] ?? 0.0,
        name: json['name'] ?? '',
      );
}

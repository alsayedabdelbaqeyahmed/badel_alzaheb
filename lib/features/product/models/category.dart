import 'package:myproject/features/carousel/models/carousel.dart';
import 'package:myproject/models/user_model.dart';

class Category {
  final String id;
  final String name, description;
  final String image;
  final double discount;

  Category({
    required this.id,
    required this.image,
    required this.name,
    this.discount = 0.0,
    this.description = '',
  });

  factory Category.fromJson(String colId, Map<String, dynamic> json) =>
      Category(
        id: colId,
        image: json[colImagesUrl] ?? '',
        name: json[colName] ?? '',
      );

  Map<String, dynamic> toJson() => {
        colId: id == null ? null : id,
        colImagesUrl: image == null ? null : image,
      };
}

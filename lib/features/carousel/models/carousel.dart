import 'dart:convert';

import 'package:myproject/models/user_model.dart';

// List<Carousel> carouselFromJson(String str) =>
//     List<Carousel>.from(json.decode(str).map((x) => Carousel.fromJson(x)));

String carouselToJson(List<Carousel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

const tblCarousel = 'Carousel',
    colId = 'id',
    colImagesUrl = 'imageUrl',
    colName = 'name';

class Carousel {
  Carousel({
    required this.id,
    required this.image,
    required this.name,
  });

  final String id;
  final String image;
  String name;

  factory Carousel.fromJson(String colId, Map<String, dynamic> json) =>
      Carousel(
        id: colId,
        image: json[colImagesUrl] ?? '',
        name: json[colName] ?? '',
      );

  Map<String, dynamic> toJson() => {
        colId: id == null ? null : id,
        colImagesUrl: image == null ? null : image,
      };
}

final defaultSlider = Carousel(
    id: '1', image: 'assets/images/logo.png', name: 'في حالة لم يتوفر عروض');

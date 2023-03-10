import '../../carousel/models/carousel.dart';
import 'category.dart';

const tblCategory = 'Category', tblProduct = 'Product';
const colId = 'id',
    colItmName = 'name',
    colPrice = 'price',
    coldescription = 'description',
    colNotes = 'notes',
    colImages = 'images';

const coldiscount = 'discount',
    colCategoryId = 'categoryId',
    colIsDiscount = 'isDiscount',
    colColors = 'colors';

const colisFavourite = 'isFavourite',
    colisPopular = 'isPopular',
    colIsActive = 'isActive',
    coltheDateTime = 'theDateTime';

class Product {
  final String id;
  final Category? category;
  final String categoryId;
  final String name, description;
  final String? notes;
  final List<String> images;
  final num price, discount;
  final bool isFavourite, isPopular;
  final bool isActive;

  Product({
    required this.id,
    required this.images,
    this.category,
    this.categoryId = '',
    required this.name,
    required this.price,
    required this.description,
    required this.isActive,
    this.isFavourite = false,
    this.isPopular = true,
    this.discount = 0.0,
    this.notes,
  });

  factory Product.fromJson(String pId, Map<String, dynamic> json) => Product(
        id: pId,
        images: [json[colImagesUrl] ?? ''],
        name: json[colItmName] ?? '',
        categoryId: json[colCategoryId] ?? '',
        description: json[coldescription] ?? '',
        price: json[colPrice] ?? 0.0,
        isActive: json[colIsActive] ?? true,
        isPopular: json[colisPopular] ?? false,
        discount: json[coldiscount] ?? 0.0,
      );
}

String dummyText =
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since. When an unknown printer took a galley.";
Category categoryRow =
    Category(id: '1', image: 'assets/images/1-1.jpg', name: 'فضيات');

Product productDefalt = Product(
    id: '95866',
    images: ['assets/images/logo.png'],
    name: '',
    price: 1,
    description: '',
    isActive: true);

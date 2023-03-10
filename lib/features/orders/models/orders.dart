import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/models/Cart.dart';
import 'package:myproject/models/user_model.dart';

const colTotalQty = 'totalQty';
const tblOrder = 'Oredr',
    colUserId = 'userId',
    colEnterDate = 'enterDate',
    colIsFinished = 'isFinished',
    colIsReceived = 'isReceived',
    colSubTotal = 'subTotal',
    colCountProduct = 'count',
    colAmountDelivery = 'amountDelivery',
    colTotal = 'total';

const tblOrderDetails = 'OredrDetails',
    colProductId = 'productId',
    colOrderId = 'orderId',
    colOrderNumber = 'orderNumber',
    // colPrice = 'price',
    colTotalPrice = 'totalPrice',
    colQty = 'quantity';

class Order {
  String id, theNumber;
  bool isFinished, isReceived;
  String address, userId;
  UserModel? user;

  num subTotal, total, count, amountDelivery;
  DateTime enterDate;
  Order({
    required this.id,
    required this.theNumber,
    required this.userId,
    this.user,
    this.address = '',
    required this.enterDate,
    required this.subTotal,
    required this.count,
    required this.amountDelivery,
    required this.total,
    required this.isFinished,
    required this.isReceived,
  });

  factory Order.fromJson(String Id, Map<String, dynamic> json) => Order(
        id: Id,
        theNumber: json[colTheNumber],
        userId: json[colUserId] ?? '',
        enterDate: json[colEnterDate].toDate(),
        subTotal: json[colSubTotal] ?? 0.0,
        count: json[colCountProduct] ?? 0.0,
        amountDelivery: json[colAmountDelivery] ?? 0.0,
        total: json[colTotal] ?? 0.0,
        isFinished: json[colIsFinished] ?? false,
        isReceived: json[colIsReceived] ?? false,
      );
}

class OrderDetails {
  String id, orderNumber;

  Product? product;
  String productId;
  num price, totalPrice, qty;
  String orderId;
  Order? order;

  OrderDetails({
    required this.id,
    required this.orderNumber,
    required this.orderId,
    this.order,
    required this.productId,
    this.product,
    required this.price,
    required this.qty,
    required this.totalPrice,
  });
  factory OrderDetails.fromJson(
          String Id, Map<String, dynamic> json, Order? order,
          [Product? product]) =>
      OrderDetails(
        id: Id,
        orderNumber: json[colOrderNumber] ?? '',
        orderId: json[colOrderId] ?? '',
        order: order ?? null,
        productId: json[colProductId] ?? '',
        product: product ?? null,
        price: json[colPrice] ?? 0.0,
        qty: json[colQty] ?? 0.0,
        totalPrice: json[colTotalPrice] ?? 0.0,
      );
}

const tblPayment = 'Payment';

class Payment {
  String id, shipmentAddress, shipmentPhone, userId;
  UserModel? user;
  String notes;

  num amount;
  String orderId, orderNumber;
  Order? order;
  DateTime enterDate;
  Payment({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.enterDate,
    required this.userId,
    this.order,
    this.user,
    required this.shipmentAddress,
    required this.shipmentPhone,
    required this.amount,
    required this.notes,
  });
}

class PaymentTools {
  PaymentTools({
    required this.id,
    required this.name,
  });

  final String id;
  String name;

  factory PaymentTools.fromJson(String colId, Map<String, dynamic> json) =>
      PaymentTools(
        id: colId,
        name: json['name'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        colId: id == null ? null : id,
      };
}

List<PaymentTools> paymentMethodList = [
  PaymentTools(id: 'الرياض فقط', name: 'الدفع عند الاستلام'),
  PaymentTools(
      id: 'بنك الأنماء \n رقم الحساب : SA0905000068202509621000',
      name: 'حوالة - بنك الانماء'),
  PaymentTools(id: 'بطاقة', name: 'بطاقة ائتمان'),
  // PaymentTools(id: '', name: 'بطاقة أئتمان'),
];
// List<PaymentTools> typeDeliveryList = [
//   PaymentTools(id: '15', name: 'إلى مقر الشحن'),
//   PaymentTools(id: '30', name: 'إلى المنزل'),
// ];

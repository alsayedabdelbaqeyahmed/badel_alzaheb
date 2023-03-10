import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/components/text_field_widget.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';
import 'package:myproject/features/orders/controller/cart_provider.dart';
import 'package:myproject/features/orders/controller/order_controller.dart';
import 'package:myproject/features/orders/models/orders.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/features/setting/controller/setting_controller.dart';
import 'package:myproject/models/user_model.dart';
import 'package:myproject/routes.dart';
import 'package:myproject/var_public.dart';
import 'package:myproject/widgets/btn_loading_widget.dart';
import 'package:myproject/widgets/cbx_field_lite_widget.dart';
import '../../../size_config.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  static const String routeName = '/order-payment-screen';

  PaymentScreen({
    required this.totalCarts,
    required this.order,
  });
  num totalCarts;
  Order? order;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final txtAmountSubTotalControll = TextEditingController();
  final txtAmountDeliveryControll = TextEditingController(text: '0');
  final txtAmountTotalControll = TextEditingController(text: '0');
  // ----
  final txtpeymenMethodControll = TextEditingController();
  // final txtpeymenMethodControllId = TextEditingController();
  String typeMethodPaymentId = '';
  final txtTypeDeliveryControll = TextEditingController();
  String typeDeliveryId = '';
  final txtAddressControll = TextEditingController();
  final txtPhoneControll = TextEditingController();
  String cityId = '';
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final resaultOrdersPro = ref.read(resaultOrdersProvider.notifier).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'اتمام الطلب',
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: ref.watch(userDataAuthProvider).when(
                data: (user) {
                  if (user == null) return Container();
                  if (txtAddressControll.text.trim().isEmpty) {
                    loadData(user);
                  }

                  return Form(
                    key: _formKey,
                    child: AnimationLimiter(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 375),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            horizontalOffset: 50.0,
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: [
                            SizedBox(),
                            CbxFieldLiteWidget(
                              listData: paymentMethodList,
                              title: 'طرق الدفع',
                              controlItem: txtpeymenMethodControll.text,
                              onChanged: (newSelected) {
                                var row = paymentMethodList.where((element) =>
                                    element.name.trim() == newSelected!.trim());
                                if (row.isNotEmpty) {
                                  txtpeymenMethodControll.text = row.first.name;
                                  typeMethodPaymentId = row.first.id;
                                  setState(() {});
                                }
                              },
                            ),

                            cbxShipping(),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    title: 'المبلغ',
                                    controller: txtAmountSubTotalControll,
                                    readOnly: true,
                                  ),
                                ),
                                spaceW,
                                Expanded(
                                  child: TextFieldWidget(
                                    title: 'مبلغ التوصيل',
                                    controller: txtAmountDeliveryControll,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            TextFieldWidget(
                              title: 'الإجمالي الكلي',
                              controller: txtAmountTotalControll,
                              textAlign: TextAlign.center,
                              readOnly: true,
                            ),
                            TextFieldWidget(
                              title: 'رقم الهاتف',
                              controller: txtPhoneControll,
                              keyboardType: TextInputType.number,
                              helperText: 'حدث رقم الهاتف ان كان مختلف',
                            ),
                            TextFieldWidget(
                              title: 'وصف المنزل',
                              controller: txtAddressControll,
                              helperText: 'حدث وصف المنزل ان كان مختلف',
                            ),
                            spaceH10,
                            // شرط اذا كان المنزل عادي
                            BtnLoadingWidget(
                              isLoading: isLoading,
                              title: 'اكمال الطلب',
                              onPressed: () async {
                                if (txtpeymenMethodControll.text.isEmpty) {
                                  msgBox(context, 'يجب اكمال كافة الحقول');
                                  return;
                                }
                                if (typeMethodPaymentId.trim().isEmpty) {
                                  msgBox(context, 'يجب تحديد طريقة الدفع');
                                  return;
                                }
                                if (typeDeliveryId.trim().isEmpty) {
                                  msgBox(context, 'يجب تحديد طريقة الشحن');
                                  return;
                                }
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    num sumQty = 0.0;

                                    sumQty = resaultOrdersPro.sumQtyOrder;
                                    Map<String, dynamic> dataOrder = {
                                      colIsFinished: true,
                                      colCountProduct: sumQty,
                                      colAmountDelivery: num.tryParse(
                                              txtAmountDeliveryControll.text) ??
                                          0,
                                      colSubTotal: num.tryParse(
                                              txtAmountSubTotalControll.text) ??
                                          0,
                                      colTotal: num.tryParse(
                                              txtAmountTotalControll.text) ??
                                          0,
                                    };

                                    Map<String, dynamic> dataPayment = {
                                      colOrderId: widget.order!.id,
                                      colOrderNumber: widget.order!.theNumber,
                                      colUserId: user.uid,
                                      colAddress: txtAddressControll.text,
                                      colphoneNumber: txtPhoneControll.text,
                                      colAmount: num.tryParse(
                                              txtAmountTotalControll.text) ??
                                          0,
                                      colNotes: txtpeymenMethodControll.text,
                                      colEnterDate: DateTime.now(),
                                    };
                                    bool? isDone = await ref
                                        .read(orderControllerProvider)
                                        .finishedOrder(
                                          context: context,
                                          txtOrderId: widget.order!.id,
                                          dataOrder: dataOrder,
                                          dataPayment: dataPayment,
                                        );
                                    setState(() {
                                      isLoading = false;
                                    });
                                    // if (isDone == true) {
                                    //   await ref.refresh(
                                    //       getOrderDetailsUserStreamProvider);
                                    //   await ref
                                    //       .refresh(getOrdersUserFutureProvider);
                                    //   Navigator.pushNamedAndRemoveUntil(
                                    //       context, go_main, (route) => false);
                                    // }
                                  } catch (e) {
                                    msgBox(context,
                                        'يوجد مشكلة في اكمال الطلب, تواصل مع الدعم الفني لحلها');
                                    print('======$e');
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                            ),
                            // CardPymentWidget(),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                error: (err, trace) {
                  return Container();
                },
                loading: () => const Loader(),
              ),
        ),
      ),
      bottomNavigationBar:
          typeMethodPaymentId.isNotEmpty ? bottomSheetPaymentMethod() : null,
    );
  }

  Container bottomSheetPaymentMethod() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            // offset: Offset(0, -15),
            blurRadius: 20,
            color: Colors.blue,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: getProportionateScreenHeight(10)),
          if (!typeMethodPaymentId.contains('الرياض') &&
              !typeMethodPaymentId.contains('بطاقة'))
            TextButton.icon(
              onPressed: () => launchInBrowser(
                  'http://wa.me/966533285583/?text=مرحبا%20بديل%20الذهب%0Aرقم%20الطلب%20${widget.order!.theNumber}%0Aوهذا%20اشعار%20الحواله%20'),
              icon: Icon(Icons.chat_bubble_outline_outlined),
              label: Text(
                'ارسال اشعار الحواله',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          if (!typeMethodPaymentId.contains('بطاقة'))
            Container(
              width: double.infinity,
              child: SelectableText(
                typeMethodPaymentId,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          if (typeMethodPaymentId.contains('بطاقة'))
            Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('غير متوفر حاليا'),
                  spaceH,
                  Image.asset('assets/images/payments_sa.png'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  loadData(UserModel data) {
    txtAmountSubTotalControll.text = widget.totalCarts.toString();
    txtAmountTotalControll.text = widget.totalCarts.toString();
    txtPhoneControll.text = data.phoneNumber;
    // nameController.text = data.name;
    txtAddressControll.text = data.address;
    cityId = data.cityId;
  }

  resaultTotalAmount() {
    num amount = num.tryParse(txtAmountSubTotalControll.text) ?? 0;
    num amountDelivery = 0.0;
    if (txtAmountDeliveryControll.text.trim() != 'مجاني')
      amountDelivery = num.tryParse(txtAmountDeliveryControll.text) ?? 0;
    txtAmountTotalControll.text = (amount + amountDelivery).toStringAsFixed(3);
  }

  cbxShipping() {
    return ref.read(getShippingFutureProvider).when(
          data: (data) {
            if (data == null || data.isEmpty) return Container();
            return CbxFieldLiteWidget(
              listData: data,
              title: 'طريقة الشحن',
              controlItem: txtTypeDeliveryControll.text, // = data[0].name
              onChanged: (newSelected) {
                var row = data.where(
                    (element) => element.name.trim() == newSelected!.trim());
                if (row.isNotEmpty) {
                  typeDeliveryId = row.first.price.toString();
                  txtTypeDeliveryControll.text = row.first.name;
                  if (cityId.trim() == cityRiadId.trim()) {
                    if (widget.totalCarts > 200) {
                      txtAmountDeliveryControll.text = 'مجاني';
                    } else {
                      txtAmountDeliveryControll.text = typeDeliveryId;
                    }
                  } else
                    txtAmountDeliveryControll.text = typeDeliveryId;
                  resaultTotalAmount();
                }
              },
            );
          },
          error: (err, trace) {
            return Container();
          },
          loading: () => const Loader(),
        );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/features/setting/controller/setting_controller.dart';
import 'package:myproject/models/user_model.dart';
import 'package:myproject/var_public.dart';
import 'package:myproject/widgets/btn_loading_widget.dart';
import 'package:myproject/widgets/cbx_field_lite_widget.dart';
import 'package:myproject/widgets/check_box_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../../components/text_field_widget.dart';
import '../widgets/password_widget.dart';
import '../controller/auth_controller.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-profile';

  UserProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final phoneController = TextEditingController();
  final theCityController = TextEditingController();
  final txtEmailControll = TextEditingController();
  final txtAddressController = TextEditingController(text: '');
  final _formKey = GlobalKey<FormState>();

  String cityId = '';
  bool isLoading = false;
  bool isActive = false;
  File? image;
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneController.dispose();
    theCityController.dispose();
    txtEmailControll.dispose();
    txtAddressController.dispose();
  }

  void saveUserData() async {
    if ((!phoneController.text.toString().contains('05') &&
            !phoneController.text.toString().contains('5')) ||
        phoneController.text.toString().length < 9) {
      showSnackBar(context: context, content: 'رقم الهاتف ليس صحيح');
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });
        String name = nameController.text.trim();

        if (name.isNotEmpty && phoneController.text.isNotEmpty) {
          await firestore.collection(tblUser).doc(auth.currentUser!.uid).update(
            {
              colUsName: name,
              colAddress: txtAddressController.text,
              colphoneNumber: phoneController.text,
              colCityId: cityId,
            },
          );
        }
      } catch (e) {
        print('----:$e');
      } finally {
        await ref.refresh(userDataAuthProvider);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  loadData(UserModel data) {
    phoneController.text = data.phoneNumber;
    nameController.text = data.name;
    txtAddressController.text = data.address;
    cityId = data.cityId;
    // theCityController.text = data.cityId;
    txtEmailControll.text = data.emaile;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'الملف الشخصي',
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: ref.watch(userDataAuthProvider).when(
              data: (data) {
                if (data == null) {
                  Future.delayed(Duration(seconds: 2), () {
                    ref.refresh(userDataAuthProvider);
                  });
                  return Container();
                }
                if (txtEmailControll.text.trim().isEmpty) {
                  loadData(data);
                }
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        spaceH,
                        spaceH,
                        TextFieldWidget(
                          controller: txtEmailControll,
                          title: 'البريد',
                          readOnly: true,
                        ),
                        spaceH,
                        TextFieldWidget(
                          controller: nameController,
                          title: 'الاسم',
                        ),
                        spaceH,
                        TextFieldWidget(
                          title: 'رقم الهاتف',
                          subtitle: "567891234",
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(left: 11, top: 13),
                            child: Text('+966'),
                          ),
                        ),
                        spaceH,
                        cityMethod(),
                        spaceH,
                        TextFormField(
                          maxLines: 2,
                          maxLength: 200,
                          controller: txtAddressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'العنوان',
                            labelText: 'العنوان',
                          ),
                          validator: RequiredValidator(
                              errorText: 'خطأ: هذا الحقل مطلوب'),
                        ),
                        SizedBox(
                          height: size.height * 0.1,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: BtnLoadingWidget(
                            title: 'حفظ التعديل',
                            isLoading: isLoading,
                            onPressed: saveUserData,
                          ),
                        ),
                        spaceH,
                        SizedBox(
                          width: double.infinity,
                          child: BtnLoadingWidget(
                            isLoading: false,
                            onPressed: () => Future(
                              () => showDailogPasswordChange(context, ref),
                            ),
                            title: 'تغيير كلمة المرور',
                          ),
                        ),
                        spaceH,
                        if (Platform.isIOS)
                          SizedBox(
                            width: double.infinity,
                            child: BtnLoadingWidget(
                              isLoading: false,
                              // onPressed: () => launchInBrowser(
                              //   'http://wa.me/966533285583/?text=مرحبا%20بديل%20الذهب%20اريد%20حذف%20الحساب%20الخاص بي',
                              // ),
                              onPressed: () async {
                                if ((await showWarning(context)) == true) {
                                  ref
                                      .read(authControllerProvider)
                                      .deleteAccount(context);
                                }
                              },
                              title: 'حذف الحساب',
                              backgroundColor: Colors.red.shade200,
                            ),
                          ),
                        spaceH10,
                      ],
                    ),
                  ),
                );
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            ),
      ),
    );
  }

  Padding cityMethod() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ref.watch(getCityFutureProvider).when(
            data: (listData) {
              var rowCity = listData
                  .where((element) => element.id.trim() == cityId.trim());

              if (rowCity.isNotEmpty) {
                theCityController.text = rowCity.first.name;
                setState(() {});
              }
              if (listData == null) {
                return Container(
                  child: Text('لا يوجد مدن حاليا'),
                );
              }
              return CbxFieldLiteWidget(
                listData: listData,
                title: 'المدينة',
                controlItem: theCityController.text,
                onChanged: (newSelected) async {
                  try {
                    if (listData == null && listData.isEmpty) {
                      setState(() {});
                      msgBox(context, 'لا يوجد مدن');
                      return;
                    }
                    if (listData.isNotEmpty) {
                      var row = listData.where((element) =>
                          element.name.trim() == newSelected!.trim());
                      if (row != null) {
                        cityId = row.first.id.toString();
                        theCityController.text = row.first.name;
                      }
                    }
                  } catch (e) {
                    print('----Ex$e');
                  }
                },
              );
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}

Future<bool?> showWarning(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('تنبية'),
      content: Text('سيتم حذف الحساب, هل انت متاكد من ذلك؟.'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, true), child: Text('نعم')),
        TextButton(
            onPressed: () => Navigator.pop(context, false), child: Text('لا')),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';

import '../../widgets/btn_loading_widget.dart';

class ErrorScreen extends ConsumerWidget {
  final String error;
  const ErrorScreen({
    Key? key,
    required this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
          height: size.height - 100,
          width: size.width - 70,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                Center(
                  child: Text(
                    error.contains(enterNetError)
                        ? 'لا يتوفر اتصال بالشبكة, قم بتوصيل الانترنت واعد تشغيل التطبيق'
                        : error,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Spacer(),
                if (error.contains(enterNetError))
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: BtnLoadingWidget(
                      title: "اعادة المحاولة",
                      isLoading: false,
                      onPressed: () async {
                        ref.refresh(userDataAuthProvider);
                      },
                    ),
                  ),
              ],
            ),
          )),
    );
  }
}

const enterNetError =
    '[cloud_firestore/unavailable] The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.';

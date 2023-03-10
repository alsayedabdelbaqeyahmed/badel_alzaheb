import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/auth/controller/auth_controller.dart';

class UserWatchWidget extends ConsumerWidget {
  UserWatchWidget({
    required this.widget,
  });
  Widget widget;
  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(userDataAuthProvider).when(
          data: (user) {
            if (user == null) return Container();

            return widget;
          },
          error: (err, trace) {
            return Container();
          },
          loading: () => const Loader(),
        );
  }
}

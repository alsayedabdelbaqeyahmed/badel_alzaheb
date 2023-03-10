import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/utils.dart';
import 'package:myproject/routes.dart';

import '/features/auth/repository/auth_repository.dart';
import '/models/user_model.dart';

final getUsersFutureProvider = FutureProvider(
  (ref) {
    return ref.watch(authRepositoryProvider).getUsersFuture();
  },
);

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getCurrentUserData() async {
    try {
      UserModel? user = await authRepository.getCurrentUserData();

      return user;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) {
    return authRepository.signInWithEmail(context, email, password);
  }

  Future<void> resetWhiEmail(BuildContext context, String email) async {
    authRepository.resetPassword(
      context,
      email,
    );
  }

  Future<bool> signupWithEmail(BuildContext context, Map<String, dynamic> data,
      String phoneNumber, String password) {
    return authRepository.signUpWithEmail(
      context,
      data,
      phoneNumber,
      password,
    );
  }

  void changePassword(context, String password, newPassword) {
    authRepository.changePassword(context, password, newPassword);
  }

  Future<void> signInWithGoogle(
    BuildContext context,
  ) async {
    await authRepository.signInWithGoogle(context);
  }

  Future<void> signInWithApple(
    BuildContext context,
  ) async {
    await authRepository.signInWithApple(context);
  }

  Future<void> deleteAccount(context) async {
    if (auth != null && auth.currentUser != null) {
      await auth.currentUser!.delete();
      msgShow('تم حذف الحساب بنجاح');
      await Navigator.pushNamedAndRemoveUntil(
          context, go_main, (route) => false);
      await ref.refresh(userDataAuthProvider);
    }
  }
}


/**
 *  await FirebaseFirestore.instance.disableNetwork();
      await FirebaseFirestore.instance.enableNetwork();
 */
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myproject/routes.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../var_public.dart';
import '../controller/auth_controller.dart';
import '/common/utils/utils.dart';
import '/models/user_model.dart';
import 'package:flutter/foundation.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    // ref: ref,
  ),
);

class AuthRepository {
  final FirebaseAuth auth;
  // final ProviderRef<AuthRepository> ref;
  final FirebaseFirestore firestore;
  AuthRepository({
    required this.auth,
    // required this.ref,
    required this.firestore,
  });
  Future<List<UserModel>> getUsersFuture() {
    return firestore.collection(tblUser).get().then((event) {
      List<UserModel> productsNewList = [];
      for (var document in event.docs) {
        productsNewList.add(UserModel.fromMap(document.id, document.data()));
      }
      return productsNewList;
    });
  }

  Future<UserModel?> getCurrentUserData() async {
    try {
      var userData =
          await firestore.collection(tblUser).doc(auth.currentUser?.uid).get();
      // print('----------------------------------------');
      // print(auth.currentUser?.uid);
      // print(auth.currentUser);
      if (userData.exists) {
        // if (userData.data() != null) {
        UserModel? user = UserModel.fromMap(userData.id, userData.data()!);

        return user;
        // }
      }
    } catch (e) {
      print('CurrentUser-------$e');
      return Future.error(e);
    }
  }

  Future<bool> signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      var user = await firestore
          .collection(tblUser)
          .where(colEmaile, isEqualTo: email.trim())
          .get();
      if (user.docs.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);

        Navigator.pushNamedAndRemoveUntil(
          context,
          go_main,
          (route) => false,
        );
        return true;
      } else {
        showSnackBar(context: context, content: 'البريد او كلمة المرور خطاء');
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('---------------EX: ${e.message}');
      if (e.message!.trim() ==
          'The password is invalid or the user does not have a password.'
              .trim())
        showSnackBar(context: context, content: 'كلمة المرور خطأ');
      if (e.message!.trim() == errorTryAgain.trim())
        showSnackBar(context: context, content: errorTryAgainMsg);
      if (e.message!.trim() == errorNetWork.trim())
        showSnackBar(context: context, content: errorNetWorkMsg);
      else
        showSnackBar(context: context, content: e.message!);
      return false;
    }
  }

//We have blocked all requests from this device due to unusual activity. Try again later.
  Future<bool> signUpWithEmail(
    BuildContext context,
    Map<String, dynamic> data,
    String email,
    String password,
  ) async {
    try {
      var checkUser = await firestore
          .collection(tblUser)
          .where(colEmaile, isEqualTo: email.trim())
          .get();
      if (checkUser.docs.isEmpty) {
        final authUser = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(authUser.user);
        // print(authUser.user);
        if (authUser.user != null) {
          await firestore.collection(tblUser).doc(authUser.user!.uid).set(data);

          Navigator.pushNamedAndRemoveUntil(
            context,
            go_main,
            (route) => false,
          );
          msgBox(context, 'تم التسجيل بنجاح');
          return false;
        } else {
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   sign_up_screen,
          //   (route) => false,
          // );
          msgBox(context, 'خطأ: لم تكتمل عملية التسجيل حاول مرة أخرى');
          return false;
        }
      } else {
        showSnackBar(
          context: context,
          content: 'تم التسجيل من قبل في هذا البريد الإلكتروني.',
        );
        return false;
      }
    } on FirebaseAuthException catch (e) {
      print('---------------EX: $e');
      if (e.message!.trim() == errorTryAgain.trim())
        showSnackBar(context: context, content: errorTryAgainMsg);
      if (e.message!.trim() == errorNetWork.trim())
        showSnackBar(context: context, content: errorNetWorkMsg);
      else
        showSnackBar(context: context, content: e.message!);
      return false;
    }
  }

  void changePassword(context, String password, newPassword) async {
    try {
      var user = await FirebaseAuth.instance.currentUser;
      String email = user!.email!;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      user.updatePassword(newPassword).then((_) {
        print("Successfully changed password");
        showSnackBar(context: context, content: 'تم تغيير كلمة المرور بنجاح');
      }).catchError((error) {
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('------:No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('------:Wrong password provided for that user.');
      }
      showSnackBar(context: context, content: '${e.message}');
    }
  }

// GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      print('==========');
      if (kIsWeb) {
        // GoogleAuthProvider googleProvider = GoogleAuthProvider();

        // googleProvider
        //     .addScope('https://www.googleapis.com/auth/contacts.readonly');

        // await auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        print('==========');

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:
          print('==========');

          if (userCredential.user != null) {
            if (userCredential.additionalUserInfo!.isNewUser) {
              Map<String, dynamic> data = {
                colUsName: userCredential.user!.displayName ?? '',
                colphoneNumber: userCredential.user!.phoneNumber ?? '',
                colAddress: '',
                colEmaile: userCredential.user!.email ?? '',
                colIsActive: true,
                colCityId: '',
              };
              await firestore
                  .collection(tblUser)
                  .doc(userCredential.user!.uid)
                  .set(data);
            }
            await msgBox(context, 'تم تسجيل الدخول بنجاح ');
            // await ref.refresh(userDataAuthProvider);

            Navigator.of(context).pushNamedAndRemoveUntil(
              go_main,
              (route) => false,
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
    }
  }

  Future<Null> signOutWithGoogle() async {
    final GoogleSignIn googleSignIn = new GoogleSignIn();

    // Sign out with firebase
    await auth.signOut();
    // Sign out with google
    await googleSignIn.signOut();
  }

  //
  Future<void> resetPassword(
    BuildContext context,
    String email,
  ) async {
    try {
      if (kIsWeb) {
      } else {
        auth.sendPasswordResetEmail(email: email).then(
          (value) {
            msgBox(context, 'تم ارسال الرمز بنجاح');
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
    }
  }

  // ===================== APPLE ==============================

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple(BuildContext context) async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print(appleCredential.authorizationCode);

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential =
          await auth.signInWithCredential(oauthCredential);

      if (userCredential.user != null) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          Map<String, dynamic> data = {
            colUsName: userCredential.user!.displayName ?? '',
            colphoneNumber: userCredential.user!.phoneNumber ?? '',
            colAddress: '',
            colEmaile: userCredential.user!.email ?? '',
            colIsActive: true,
            colCityId: '',
          };
          await firestore
              .collection(tblUser)
              .doc(userCredential.user!.uid)
              .set(data);
        }
        await msgBox(context, 'تم تسجيل الدخول بنجاح ');
        // await ref.refresh(userDataAuthProvider);

        Navigator.of(context).pushNamedAndRemoveUntil(
          go_main,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      msgBox(context, e.message!); // Displaying the error message
    }
  }
}

const noUser =
    '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.';

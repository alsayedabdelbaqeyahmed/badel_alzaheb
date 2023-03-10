import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
  (ref) => CommonFirebaseStorageRepository(
    firebaseStorage: FirebaseStorage.instance,
  ),
);

class CommonFirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseStorageRepository({
    required this.firebaseStorage,
  });

  Future<String> storeFileToFirebase(String ref, File file) async {
    try {
      UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
      TaskSnapshot snap = await uploadTask;

      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('storeFileToFirebase----: $e');
      return '';
    }
  }

  Future<bool> deleteFileFromFirebase(
    String url,
  ) async {
    try {
      firebaseStorage.refFromURL(url).delete();
      return true;
    } catch (e) {
      print('deleteFileFromFirebase----: $e');
      return false;
    }
  }

  Future<String> updateFileFromFirebase(
    String url,
    File file,
  ) async {
    try {
      UploadTask uploadTask = firebaseStorage.refFromURL(url).putFile(file);
      TaskSnapshot snap = await uploadTask;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('uodateFileFromFirebase----: $e');
      return '';
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

var defaultEmail = 'main@gmail.app';
//
final auth = FirebaseAuth.instance;

final fireStore = FirebaseFirestore.instance;

class DB {
  // get document id
  static Future<String?> getIdDocument(collectionPath, column, value) async {
    var strID;
    await fireStore
        .collection(collectionPath)
        .where(column, isEqualTo: value)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.id != null) {
          strID = element.id;
        }
      });
    });

    return strID;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataStreams(
      collectionName) {
    var snapshots = fireStore.collection(collectionName).snapshots();
    return snapshots;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getDataStreamsWhere(
      collectionName, field, txtSearch) {
    txtSearch = txtSearch.toString().trim();
    var snapshots = fireStore
        .collection(collectionName)
        .where(field, isEqualTo: txtSearch)
        .snapshots();
    return snapshots;
  }

  static Future<List<Map>> getData(collectionName) async {
    var snapshots = await fireStore.collection(collectionName).get();
    List<Map> mapData = [];
    for (var snapshot in snapshots.docs) {
      mapData.add(snapshot.data());
      //
    }

    return mapData;
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getDataFutur(
      collectionName) async {
    var snapshots = await fireStore.collection(collectionName).get();

    return snapshots;
  }

  // get row data
  static Future<Map> getRowData(collectionPath, documentID) async {
    var mapRow;
    fireStore.collection(collectionPath).doc(documentID).get().then((value) {
      if (value.exists) if (value.data() != null) mapRow = value.data();
    });

    return mapRow;
  }

  // insert row
  static Future<DocumentSnapshot<Map<String, dynamic>>> insertRow(
      collectionName, Map<String, dynamic> data) async {
    DocumentReference<Map<String, dynamic>>? resault;
    try {
      //
      resault = await fireStore.collection(collectionName).add(data);
      // if (resault != null) progressWaiting(context);

      return resault.get();
    } catch (e) {
      // Msgcatch(context, e);
      return Future.error(e);
    }
  }

// insert row
  static Future<void> updateRow(
      context, collectionName, docID, Map<String, dynamic> data) async {
    try {
      //
      await fireStore.collection(collectionName).doc(docID).update(data);
    } catch (e) {
      // Msgcatch(context, e);
      print('error Update ----- $e');
    }
  }

  static Future<void> deteleRow(context, collectionName, txtID) async {
    try {
      //

      await fireStore.collection(collectionName).doc(txtID).delete();
      print('success');
    } catch (e) {
      // Msgcatch(context, e);
      print(e);
    }
  }

  static void addNewField(collectionPath, fieldName) {
    // fireStore.collection(collectionPath).doc().update({fieldName: '..'});
    try {
      fireStore.collection(collectionPath).get().then((snapshot) {
        snapshot.docs.forEach((element) {
          //--
          fireStore
              .collection(collectionPath)
              .doc(element.id)
              .update({fieldName: '..'});
        });
      });
    } catch (e) {
      print('---Error AddNewField: $e');
    }
  }

  static Future<void> deteleData(
      context, collectionName, field, txtDeleted) async {
    try {
      //
      var collection = await fireStore
          .collection(collectionName)
          .where(field, isEqualTo: txtDeleted);
      collection.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          fireStore
              .collection(collectionName)
              .doc(element.id)
              .delete()
              .then((value) {
            print("Success!");
          });
        });
      });

      // https://stackoverflow.com/questions/63897130/deleting-document-from-cloud-firestore-in-flutter
    } catch (e) {
      // Msgcatch(context, e);
      print(e);
    }
  }

  // get data where field
  static Future<QuerySnapshot<Map<String, dynamic>>> getDataWhere(
      collectionName, field, txtSearch) async {
    var collData = await fireStore
        .collection(collectionName)
        .where(
          field,
          isEqualTo: txtSearch,
        )
        .get();

    // List<Map> listData = [];

    // for (var row in collData.docs) {
    //   listData.add(row.data());
    // }
    return collData;
  }

  // get data where field
  static Future<QueryDocumentSnapshot<Map<String, dynamic>>> getDataRowWhere(
      collectionName, field, txtSearch) async {
    var collData = await fireStore
        .collection(collectionName)
        .where(
          field,
          isEqualTo: txtSearch,
        )
        .get();

    // List<Map> listData = [];

    // for (var row in collData.docs) {
    //   listData.add(row.data());
    // }
    return collData.docs[0];
  }
}

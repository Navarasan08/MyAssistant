import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CategoryFirestoreService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static const String collectionName = "categories";
  static const String subCollectionName = "product";
  static const String itemCollectionName = "items";

  static Future<void> addCategory(
      {required name, required String templateType}) async {
    CollectionReference productCollection =
        firestore.collection(collectionName);

    try {
      await productCollection.add({
        "name": name,
        "status": "1",
        "templateType": templateType,
      });
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Stream<QuerySnapshot> getCategories() async* {
    CollectionReference productCollection =
        firestore.collection(collectionName);
    try {
      yield* productCollection.snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> addProduct(
    String docId, {
    required String name,
    required String icon,
    required String templateType,
  }) async {
    CollectionReference productCollection =
        firestore.collection(collectionName);
    User user = FirebaseAuth.instance.currentUser!;

    try {
      await productCollection.doc(docId).collection(subCollectionName).add({
        "name": name,
        "icon": icon,
        "status": "1",
        "templateType": templateType,
        "createdBy": user.uid,
        "createdAt": DateTime.now().toString(),
      });
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Stream<QuerySnapshot> getProducts(String docId) async* {
    CollectionReference productCollection =
        firestore.collection(collectionName);
    User user = FirebaseAuth.instance.currentUser!;
    try {
      yield* productCollection
          .doc(docId)
          .collection(subCollectionName)
          .where('createdBy', isEqualTo: user.uid)
          .where('status', isEqualTo: '1')
          .orderBy('createdAt')
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> addProductItem(String categId, String prodId,
      {required String title, String? subtitle, String? targetDate}) async {
    CollectionReference productCollection =
        firestore.collection(collectionName);
    try {
      await productCollection
          .doc(categId)
          .collection(subCollectionName)
          .doc(prodId)
          .collection(itemCollectionName)
          .add({
        "title": title,
        "subtitle": subtitle,
        "targetDate": targetDate,
        "createdAt": DateTime.now().toString(),
        "isChecked": false,
        "status": "1",
        "completedDate": "",
      });
    } catch (e) {
      throw "$e";
    }
  }

  static Stream<QuerySnapshot> getProductItems(
      String categId, String prodId) async* {
    CollectionReference productCollection =
        firestore.collection(collectionName);
    try {
      yield* productCollection
          .doc(categId)
          .collection(subCollectionName)
          .doc(prodId)
          .collection(itemCollectionName)
          .where('status', isEqualTo: '1')
          .orderBy('createdAt')
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> updateProductItem(
      String categId, String prodId, String itemId,
      {required bool isChecked, String? title, String? subtitle, String? targetDate}) async {
    CollectionReference productCollection =
        firestore.collection(collectionName);
    try {
      await productCollection
          .doc(categId)
          .collection(subCollectionName)
          .doc(prodId)
          .collection(itemCollectionName)
          .doc(itemId)
          .update({
        "isChecked": isChecked,
        "completedDate": isChecked ? DateTime.now().toString() : "",
      });
    } catch (e) {
      throw "$e";
    }
  }
}

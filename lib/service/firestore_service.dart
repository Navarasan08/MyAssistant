import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_assistant/models/goal_detail.dart';
import 'package:my_assistant/models/login_user.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/models/product_detail.dart';

class FirestoreService {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // POST
  static Future<void> addUser(LoginUser user) async {
    CollectionReference userCollection = firestore.collection('users');

    try {
      await userCollection.add(user.toJson());
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> addProduct(Product product) async {
    CollectionReference productCollection = firestore.collection('product');

    try {
      await productCollection.add(product.toJson());
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> updateProduct(String docId, Map<String, dynamic> product) async {
    CollectionReference productCollection = firestore.collection('product');

    try {
      await productCollection.doc(docId).set(product, SetOptions(merge: true));
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> deleteProduct(String productId) async {
    CollectionReference productCollection = firestore.collection('product');

    try {
      await productCollection.doc(productId).delete();
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> addProductHeaders(
      String pId, List<TableHeader> headers) async {
    DocumentReference product = firestore.collection('product').doc(pId);

    try {
      await Future.forEach(headers, (header) async {
        await product.collection("headers").add(header.toJson());
      });

      return;
    } catch (e) {
      throw "$e";
    }
  }

  // static Future<void> addRows(String pId, List<Rows> rows) async {
  //   DocumentReference product = firestore.collection('product').doc(pId);
  //   try {
  //     await Future.forEach(rows, (row) async {
  //       DocumentReference rowRef = await product.collection("rows").add({
  //         "createdAt": row.createdAt,
  //         "createdBy": row.createdBy,
  //         "isActive": "1",
  //       });

  //       await Future.forEach(row.field!, (field) async {
  //         await rowRef.collection("fields").add(field.toJson());
  //       });
  //     });

  //     return;
  //   } catch (e) {
  //     throw "$e";
  //   }
  // }

  static Future<void> addFields(String pId, List<Field> fields) async {
    CollectionReference productCollection = firestore.collection('product');
    try {
      DocumentReference rowRef =
          await productCollection.doc(pId).collection("rows").add({
        "createdAt": DateTime.now().toString(),
        "createdBy": FirebaseAuth.instance.currentUser?.uid,
        "isActive": "1",
        "updatedAt": null,
      });

      await Future.forEach(fields, (field) async {
        await rowRef.collection("fields").add(field.toJson());
      });
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> updateHeader(
      String pId, String headerId, TableHeader header) async {
    CollectionReference productCollection = firestore.collection('product');
    try {
      CollectionReference headerRef =
          productCollection.doc(pId).collection("headers");

      headerRef.doc(headerId).set(header.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> updateField(String pId, String rowId, String fieldId,
      Map<String, dynamic> field) async {
    CollectionReference productCollection = firestore.collection('product');
    try {
      DocumentReference rowRef =
          productCollection.doc(pId).collection("rows").doc(rowId);

      rowRef
          .collection("fields")
          .doc(fieldId)
          .set(field, SetOptions(merge: true));
    } catch (e) {
      throw "$e";
    }
  }

  static Future<void> deleteRow(String pId, String rowId) async {
    CollectionReference productCollection = firestore.collection('product');
    try {
      await productCollection.doc(pId).collection("rows").doc(rowId).delete();
    } catch (e) {
      throw "$e";
    }
  }

  // Goal
  static Future<void> addGoalDetail(
      String prodId, GoalDetail goalDetail) async {
    CollectionReference productCollection = firestore.collection('product');

    try {
      await productCollection
          .doc(prodId)
          .set({"goalDetail": goalDetail.toJson()}, SetOptions(merge: true));
      return;
    } catch (e) {
      throw "$e";
    }
  }

  // add Goal Status
  static Future<void> saveGoalStatus(
      String prodId, Map<String, dynamic> statusObj) async {
    CollectionReference productCollection = firestore.collection('product');

    try {
      await productCollection.doc(prodId).collection("fields").add(statusObj);
      return;
    } catch (e) {
      throw "$e";
    }
  }

  // update Existing Goal Status
  static Future<void> updateGoalStatus(
      String prodId, String docId, bool status) async {
    CollectionReference productCollection = firestore.collection('product');

    try {
      await productCollection.doc(prodId).collection("fields").doc(docId).set({
        'status': status ? '1' : '0',
        'updatedAt': DateTime.now().toString()
      }, SetOptions(merge: true));
      return;
    } catch (e) {
      throw "$e";
    }
  }

  static Stream<QuerySnapshot> getIcons() async* {
    CollectionReference iconCollection = firestore.collection('icons');

    try {
      yield* iconCollection.snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // GET

  // all products
  static Stream<QuerySnapshot> getProducts() async* {
    CollectionReference productCollection = firestore.collection('product');
    User user = FirebaseAuth.instance.currentUser!;
    try {
      yield* productCollection
          .where('createdBy', isEqualTo: user.uid)
          .where('isActive', isEqualTo: '1')
          .orderBy('createdAt')
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // single product : productId
  static Stream<DocumentSnapshot> getProduct(String docId) async* {
    CollectionReference productCollection = firestore.collection('product');
    try {
      yield* productCollection.doc(docId).snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // get headers
  static Stream<QuerySnapshot> getProductHeaders(String docId) async* {
    CollectionReference productCollection = firestore.collection('product');
    try {
      yield* productCollection
          .doc(docId)
          .collection("headers")
          .where('isActive', isEqualTo: '1')
          .orderBy('createdAt')
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // get Rows : pId
  static Stream<QuerySnapshot> getRows(String pId,{ bool isDesc = false , String? orderBy}) async* {
    CollectionReference productCollection = firestore.collection('product');
    try {
      yield* productCollection
          .doc(pId)
          .collection("rows")
          // .where('isActive', isEqualTo: '1')
          .orderBy( orderBy ?? 'createdAt', descending: isDesc)
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // get row
  static Stream<DocumentSnapshot> getRow(String pId, String rowId) async* {
    CollectionReference productCollection = firestore.collection('product');
    try {
      yield* productCollection
          .doc(pId)
          .collection("rows")
          .doc(rowId)
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // get fields
  static Stream<QuerySnapshot> getFields(String pId, String rowId) async* {
    CollectionReference productCollection = firestore.collection('product');
    try {
      yield* productCollection
          .doc(pId)
          .collection("rows")
          .doc(rowId)
          .collection("fields")
          .orderBy('createdAt')
          .snapshots();
    } catch (e) {
      throw "$e";
    }
  }

    // get field based on row & header
  static Stream<QuerySnapshot> getField(String pId, String rowId, String headerId) async* {
    CollectionReference productCollection = firestore.collection('product');
    try {
      yield* productCollection
          .doc(pId)
          .collection("rows")
          .doc(rowId)
          .collection("fields")
          .where("headerId", isEqualTo: headerId).snapshots();
    } catch (e) {
      throw "$e";
    }
  }

  // get Goal Status
  static Stream<QuerySnapshot> getGoalStatus(String prodId) async* {
    CollectionReference productCollection = firestore.collection('product');
    User user = FirebaseAuth.instance.currentUser!;
    try {
      yield* productCollection.doc(prodId).collection('fields').snapshots();
    } catch (e) {
      throw "$e";
    }
  }
}

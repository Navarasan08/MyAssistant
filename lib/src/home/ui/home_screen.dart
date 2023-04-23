import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/service/firebase_service.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/src/auth/ui/login_screen.dart';
import 'package:my_assistant/src/home/ui/add_product_page.dart';
import 'package:my_assistant/src/product/product_screen.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/extentions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;

  Stream<QuerySnapshot>? productStream;

  @override
  void initState() {
    super.initState();

    getUser();
    productStream = FirestoreService.getProducts();
  }

  getUser() async {
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    productStream = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Assistant"),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseService.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                icon: Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddProductPage()));
          },
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Text("Welcome "),
                  Text(
                    "${user?.displayName}!",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: productStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 15),
                            children: [
                              for (var item in (snapshot.data!.docs))
                                _buildItem(item)
                            ]);
                      }

                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return Center(child: CircularProgressIndicator());
                    })),
          ],
        ));
  }

  Widget _buildItem(QueryDocumentSnapshot item) {
    Product product =
        Product.fromFirestoreJson(item.id, item.data() as Map<String, dynamic>);
    return GestureDetector(
      onLongPressStart: (details) async {
        final offset = details.globalPosition;

        String? res = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy,
            MediaQuery.of(context).size.width - offset.dx,
            MediaQuery.of(context).size.height - offset.dy,
          ),
          items: [
            PopupMenuItem(
              value: 'edit',
              child: Text("Edit Product"),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text("Delete"),
            ),
          ],
          elevation: 8.0,
        );

        if (res != null) {
          if (res == "delete") {
            // ignore: use_build_context_synchronously
            DialogModel.showSimpleDialog(context,
                title: "Delete",
                msg: "Are you sure to delete the Field", onTap: () {
              FirestoreService.deleteProduct(item.id);
              DialogModel.showSnackBar(context, "App Deleted Successfully!");
            });
          }

          if (res == "edit") {
            context.pushRoute(AddProductPage(existProduct: item));
          }
        }
      },
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => ProductScreen(product: product))));
      },
      child: Column(children: [
        Flexible(child: Icon(MdiIcons.fromString("${product.icon}"))),
        SizedBox(height: 20),
        Text("${product.name}")
      ]),
    );
  }
}

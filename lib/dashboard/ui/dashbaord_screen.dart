import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_assistant/dashboard/checklist/check_list_screen.dart';
import 'package:my_assistant/dashboard/ui/add_category_screen.dart';
import 'package:my_assistant/dashboard/ui/add_product_screen.dart';
import 'package:my_assistant/dashboard/ui/product_detail_page.dart';
import 'package:my_assistant/service/category_firestore_service.dart';
import 'package:my_assistant/service/firebase_service.dart';
import 'package:my_assistant/src/auth/ui/login_screen.dart';
import 'package:my_assistant/utils/extentions.dart';

class DashbaordScreen extends StatefulWidget {
  const DashbaordScreen({super.key});

  @override
  State<DashbaordScreen> createState() => _DashbaordScreenState();
}

class _DashbaordScreenState extends State<DashbaordScreen> {
  late Stream<QuerySnapshot> _categoryStream;

  @override
  void initState() {
    super.initState();

    _categoryStream = CategoryFirestoreService.getCategories();
  }

  // void navigateToDetailScreen(QueryDocumentSnapshot product) {
  //   var _product = product.data() as Map;

  //   if(_product['templateType'] == "automobile") {
  //       context.pushRoute(VehicleDetail(product: product));
  //   } else if(_product['templateType'] == "notes") {
  //       context.pushRoute(VehicleDetail(product: product));
  //   } else if(_product['templateType'] == "checklist") {
  //       context.pushRoute(CheckListScreen(product: product));
  //   } else if(_product['templateType'] == "expense") {
  //       context.pushRoute(VehicleDetail(product: product));
  //   } else {
  //      DialogModel.showSimpleDialog(context,
  //           title: "Sorry!", msg: "Comming Soon..");
  //   }

  // }

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
        onPressed: () {
          context.pushRoute(AddCategoryScreen());
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _categoryStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> categories = snapshot.data!.docs;

              return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    var category = categories[index].data() as Map;

                    return _buildBlock(
                        "${category['name']}", categories[index]);
                  });
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildBlock(String title, QueryDocumentSnapshot doc) {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<QuerySnapshot>(
        stream: CategoryFirestoreService.getProducts(doc.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List products = snapshot.data!.docs;

            return Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          child: Icon(Icons.add,
                              color: Theme.of(context).primaryColor),
                          onTap: () {
                            context.pushRoute(AddProductScreen(category: doc));
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // for (var i in [1, 2, 3, 4])
                        for (var product in products)
                          GestureDetector(
                            onTap: () {
                              context.pushRoute(
                                  ProductDetailScreen(product: product, categId: doc.id));
                              // navigateToDetailScreen(product);
                            },
                            child: Container(
                              width: size.width / 5,
                              child: Column(
                                children: [
                                  Container(
                                      height: 45,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Icon(
                                          MdiIcons.fromString(product['icon']),
                                          color: Colors.white)),
                                  SizedBox(height: 5),
                                  Text(product['name'],
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500))
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }

          return Container();
        });
  }
}

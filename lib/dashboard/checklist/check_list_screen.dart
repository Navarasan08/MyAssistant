import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/dashboard/checklist/add_check_list_screen.dart';
import 'package:my_assistant/service/category_firestore_service.dart';
import 'package:my_assistant/utils/extentions.dart';

class CheckListScreen extends StatefulWidget {
  const CheckListScreen(
      {super.key, required this.product, required this.categoryId});

  final QueryDocumentSnapshot product;
  final String categoryId;

  @override
  State<CheckListScreen> createState() => _CheckListScreenState();
}

class _CheckListScreenState extends State<CheckListScreen> {
  late Stream<QuerySnapshot> itemsStream;

  @override
  void initState() {
    super.initState();
    itemsStream = CategoryFirestoreService.getProductItems(
        widget.categoryId, widget.product.id);
  }

  void updateItem(String itemId, bool checkVal) async {
    try {
      await CategoryFirestoreService.updateProductItem(
          widget.categoryId, widget.product.id, itemId,
          isChecked: checkVal);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Add"),
          onPressed: () {
            context.pushRoute(AddCheckListScreen(
                categId: widget.categoryId, productId: widget.product.id));
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: itemsStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List items = snapshot.data!.docs;

                return ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _buildItem(items[index]);
                    });
              }

              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget _buildItem(QueryDocumentSnapshot item) {
    var _item = item.data() as Map;

    return Card(
      child: CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(_item['title']),
        value: _item['isChecked'],
        secondary: IconButton(
          icon: Icon(Icons.edit_document),
          onPressed: () {
            context.pushRoute(AddCheckListScreen(
              categId: widget.categoryId,
              productId: widget.product.id,
              item: item,
            ));
          },
        ),
        onChanged: (bool? val) {
          updateItem(item.id, val!);
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/models/product_detail.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/src/product/table/add_field_page.dart';
import 'package:my_assistant/src/product/table/add_header_page.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/extentions.dart';
import 'package:my_assistant/widgets/custom_button.dart';

class ProductTablePage extends StatefulWidget {
  const ProductTablePage({super.key, required this.product});

  final Product product;

  @override
  State<ProductTablePage> createState() => _ProductTablePageState();
}

class _ProductTablePageState extends State<ProductTablePage> {
  Stream<QuerySnapshot>? headerStream;
  Stream<QuerySnapshot>? rowStream;
  int fieldCount = 0;

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<ProductDetailCubit>(context)
    //     .loadProduct("${widget.product.id}");

    headerStream = FirestoreService.getProductHeaders("${widget.product.id}")
        .asBroadcastStream();
    rowStream =
        FirestoreService.getRows("${widget.product.id}").asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.name}"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddFieldPage(
                      productId: widget.product.id!, fieldCount: fieldCount)));
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: headerStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var headers = snapshot.data!.docs;

              if (headers.isEmpty) {
                return Center(
                  child: CustomSubmitButton(
                    title: "Add Field Header",
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddHeaderPage(
                                  productId: widget.product.id!)));
                    },
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    _buildHeader(headers),
                    Divider(),
                    Expanded(child: SingleChildScrollView(child: _buildRows())),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  Widget _buildHeader(List<QueryDocumentSnapshot<Object?>> headers) {
    return Row(
      children: [
        for (var header in headers)
          Expanded(
              child: Center(
            child: Text(
              header['name'],
              style: TextStyle(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          )),
        PopupMenuButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          onSelected: (value) {
            if (value == "edit") {
              context.pushRoute(AddHeaderPage(
                  productId: widget.product.id!, existHeaders: headers));
            }
          },
          itemBuilder: (BuildContext bc) {
            return const [
              PopupMenuItem(
                child: Text("Edit Header"),
                value: 'edit',
              ),
            ];
          },
        )
      ],
    );
  }

  Widget _buildRows() {
    return StreamBuilder<QuerySnapshot>(
        stream: rowStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var rows = snapshot.data!.docs;

            fieldCount = rows.length;

            return Column(
              children: [for (var row in rows) _buildField(row)],
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }

          return Container();
        });
  }

  Widget _buildField(QueryDocumentSnapshot row) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getFields(widget.product.id!, row.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var fields = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  for (var field in fields)
                    Expanded(child: Center(child: Text(field['value']))),
                  PopupMenuButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    onSelected: (value) {
                      if (value == "edit") {
                        context.pushRoute(AddFieldPage(
                          productId: widget.product.id!,
                          fieldCount: fieldCount,
                          existFields: fields,
                          rowId: row.id,
                        ));
                      }

                      if (value == "delete") {
                        DialogModel.showSimpleDialog(context,
                            title: "Delete",
                            msg: "Are you sure to delete the Field", onTap: () {
                          FirestoreService.deleteRow(
                              widget.product.id!, row.id);
                        });
                      }
                    },
                    itemBuilder: (BuildContext bc) {
                      return const [
                        PopupMenuItem(
                          child: Text("Edit Field"),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text("Delete"),
                          value: 'delete',
                        ),
                      ];
                    },
                  )
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

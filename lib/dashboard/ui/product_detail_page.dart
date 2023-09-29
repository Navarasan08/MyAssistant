import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/dashboard/checklist/check_list_screen.dart';
import 'package:my_assistant/dashboard/vehicle/vehicle_detail.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product, required this.categId});
  final QueryDocumentSnapshot product;
  final String categId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: showTemplateScreens(widget.product, widget.categId),
    );
  }

  Widget showTemplateScreens(QueryDocumentSnapshot product, String categId) {
    var _product = product.data() as Map;

    if (_product['templateType'] == "automobile") {
      return VehicleDetail(product: product);
    } else if (_product['templateType'] == "notes") {
      return VehicleDetail(product: product);
    } else if (_product['templateType'] == "checklist") {
      return CheckListScreen(product: product, categoryId: categId);
    } else if (_product['templateType'] == "expense") {
      return VehicleDetail(product: product);
    } else {
      return Center(
        child: Text("Comming Soon.."),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/src/product/goal/product_goal.dart';
import 'package:my_assistant/src/product/table/product_table.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return _buildBody(product.viewMode);
  }

  Widget _buildBody(String? mode) {
    if (mode?.toLowerCase() == "table")
      return ProductTablePage(product: product);
    if (mode?.toLowerCase() == "goal") return ProductGoalPage(product: product);
    if (mode?.toLowerCase() == "list") return Container();

    return Container();
  }
}

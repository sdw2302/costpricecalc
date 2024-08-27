import 'package:flutter/material.dart';

import '../products_menu/products_item.dart';

class IngredientsMenuListView extends StatefulWidget {
  const IngredientsMenuListView({ super.key, required this.item});

  final ProductsItem item;

  @override
  _IngredientsMenuListViewState createState() => _IngredientsMenuListViewState();

  static const routeName = '/ingredients';
}

class _IngredientsMenuListViewState extends State<IngredientsMenuListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
    );
  }
}

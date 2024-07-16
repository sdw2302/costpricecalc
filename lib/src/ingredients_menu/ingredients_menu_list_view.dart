import 'package:flutter/material.dart';

class IngredientsMenuListView extends StatefulWidget {
  const IngredientsMenuListView({super.key, required this.title});

  final String title;

  @override
  _IngredientsMenuListViewState createState() =>
      _IngredientsMenuListViewState();

  static const routeName = '/ingredients_menu_list_view';
}

class _IngredientsMenuListViewState extends State<IngredientsMenuListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(widget.title),
      ),
    );
  }
}

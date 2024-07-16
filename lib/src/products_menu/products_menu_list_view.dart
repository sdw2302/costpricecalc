import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'products_item.dart';
import '../ingredients_menu/ingredients_menu_list_view.dart';

class ProductsMenuListView extends StatefulWidget {
  const ProductsMenuListView({super.key});

  @override
  _ProductsMenuListViewState createState() => _ProductsMenuListViewState();

  static const routeName = '/';
}

class _ProductsMenuListViewState extends State<ProductsMenuListView> {
  List<ProductsItem> items = List.empty(growable: true);
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: ListView.builder(
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) {
              setState(() {
                items.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              title: Text(item.title),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.grey,
              ),
              onTap: () {
                Navigator.restorablePushNamed(
                    context, IngredientsMenuListView.routeName,
                    arguments: {'title': item.title});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            items.add(ProductsItem('$i'));
          });
          i++;
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

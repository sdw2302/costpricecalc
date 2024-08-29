import 'package:costpricecalc/src/ingredients_menu/ingredients_menu_list_view.dart';
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
  int id = 0;
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
        restorationId: 'productsMenuListView',
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
              title: Text(item.name),
              leading: const CircleAvatar(
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${item.ingredientsList.length} ingredient/s'),
                  const Icon(
                    Icons.arrow_right,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IngredientsMenuListView(
                    item: item
                  ))
                );
                setState(() {});
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _displayTextInputDialog(context);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async{
    _textFieldController.text = '';
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a new product'),
          content: Form(
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.label),
                    labelText: 'Product',
                    hintText: 'Product name'
                  ),
                  controller: _textFieldController,
                  validator: inputTextValidator,
                )
              ],
            )
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text('Cancel')
            ),
            TextButton(
              onPressed: () {
                if(_textFieldController.text == null || _textFieldController.text.isEmpty) {
                  showSnackBar('Field cannot be empty');
                }
                else {
                  setState(() {
                    items.add(ProductsItem(id, _textFieldController.text));
                  });
                  id++;
                  Navigator.pop(context);
                }
              }, 
              child: const Text('Create')
            )
          ],
        );
      }
    );
  }

  void showSnackBar(String message){
    final messenger = ScaffoldMessenger.of(context);

    messenger.removeCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  String? inputTextValidator(String? value){
    if (value == null || value.isEmpty){
      return 'This field must not be empty';
    }
  }
}

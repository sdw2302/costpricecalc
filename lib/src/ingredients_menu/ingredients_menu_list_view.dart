import 'package:flutter/material.dart';

import '../products_menu/products_item.dart';
import 'ingredients_item.dart';

class IngredientsMenuListView extends StatefulWidget {
  const IngredientsMenuListView({ super.key, required this.item});

  final ProductsItem item;

  @override
  _IngredientsMenuListViewState createState() => _IngredientsMenuListViewState();

  static const routeName = '/ingredients';
}

class _IngredientsMenuListViewState extends State<IngredientsMenuListView> {
  late List<IngredientsItem> items;

  int id = 0;
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _quantityFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    items = List.from(widget.item.ingredientsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
      ),
      body: ListView.builder(
        restorationId: 'ingredientsMenuListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) {
              setState(() {
                items.removeAt(index);
                widget.item.ingredientsList.removeAt(index);
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
                  Text('${item.quantity} ${item.unit}'),
                  const Icon(
                    Icons.arrow_right,
                    color: Colors.grey,
                  ),
                ],
              )
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

  Future<void> _displayTextInputDialog(BuildContext context) async {
  _nameFieldController.text = '';
  _quantityFieldController.text = '';
  String selectedUnit = 'g';

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create a new ingredient'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Form(
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: _nameFieldController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.label),
                      labelText: 'Ingredient',
                      hintText: 'Ingredient name',
                    ),
                  ),
                  TextFormField(
                    controller: _quantityFieldController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.scale),
                      labelText: 'Quantity',
                      hintText: 'Quantity of ingredient needed',
                      suffixIcon: DropdownButton<String>(
                        value: selectedUnit,
                        icon: const Icon(Icons.arrow_drop_down),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedUnit = newValue ?? 'g';
                          });
                        },
                        items: <String>[
                          'g', 'kg', 'l', 'ml', 'tbsp', 'tsp', 'pnch', 'pc/s'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              try {
                double value = double.parse(_quantityFieldController.text);

                setState(() {
                  items.add(IngredientsItem(id, _nameFieldController.text, value, selectedUnit));
                });

                widget.item.ingredientsList.add(IngredientsItem(id, _nameFieldController.text, value, selectedUnit));
                id++;
              } catch (e) {
                showSnackBar('An error occurred when creating the ingredient');
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}


  void showSnackBar(String message){
    final messenger = ScaffoldMessenger.of(context);

    messenger.removeCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(content: Text(message))
    );
  }
}

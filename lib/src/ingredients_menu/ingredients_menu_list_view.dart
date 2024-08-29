import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../products_menu/products_item.dart';
import 'ingredients_item.dart';

class IngredientsMenuListView extends StatefulWidget {
  const IngredientsMenuListView({ super.key, required this.item });

  final ProductsItem item;

  @override
  _IngredientsMenuListViewState createState() => _IngredientsMenuListViewState();

  static const routeName = '/ingredients';
}

class _IngredientsMenuListViewState extends State<IngredientsMenuListView> {
  List<IngredientsItem> items = List.empty(growable: true);

  final TextEditingController _nameFieldController = TextEditingController();
  final TextEditingController _quantityFieldController = TextEditingController();
  late double height;

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    final productId = widget.item.id ?? -1;
    if(productId != -1){
      final ingredients = await DatabaseHelper().getIngredients(productId);
      setState(() {
        items = ingredients;
      });
    } else {
      items = List.empty(growable: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
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
            onDismissed: (_) async {
              int id = item.id ?? -1;
              if(id != -1){
                await DatabaseHelper().deleteIngredient(id);
                _loadIngredients(); 
              }// Reload ingredients to update the UI
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
              ),
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
      bottomNavigationBar: Container(
        height: height * 0.08,
        color: Theme.of(context).secondaryHeaderColor,
        child: SafeArea(
          child: InkWell(
            onTap: () {
              if(items.isEmpty){
                showSnackBar('There are no ingredients');
                return;
              }
              showSnackBar('calc');
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calculate),
                Text('Calculate cost')
              ],
            ),
          ),
        ),
      )
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
                            'g', 'kg', 'mg', 'l', 'ml', 'tbsp', 'tsp', 'pnch', 'pc/s'
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
              onPressed: () async {
                try {
                  double value = double.parse(_quantityFieldController.text);

                  final newIngredient = IngredientsItem(
                    name: _nameFieldController.text, 
                    quantity: value, 
                    unit: selectedUnit
                  );

                  int id = widget.item.id ?? -1;

                  if(id != -1){
                    await DatabaseHelper().insertIngredient(id, newIngredient);
                    _loadIngredients();
                  }
                  Navigator.pop(context);
                } catch (e) {
                  showSnackBar(e.toString());
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

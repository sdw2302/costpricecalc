import '../ingredients_menu/ingredients_item.dart';
class ProductsItem {
  ProductsItem({this.id, required this.name, this.ingredientsList = const []});

  int? id;  // Nullable to allow the database to generate the ID
  final String name;
  List<IngredientsItem> ingredientsList;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredientsList.map((ingredient) => ingredient.toMap().toString()).join(';'),
    };
  }

  factory ProductsItem.fromMap(Map<String, dynamic> map) {
    return ProductsItem(
      id: map['id'],
      name: map['name'],
      ingredientsList: map['ingredients'] != null
          ? (map['ingredients'] as String)
              .split(';')
              .map((ingredientString) {
                final ingredientMap = _stringToMap(ingredientString);
                return IngredientsItem.fromMap(ingredientMap);
              }).toList()
          : [],
    );
  }

  static Map<String, dynamic> _stringToMap(String ingredientString) {
    return {
      'id': int.parse(ingredientString.split(',')[0].split(':')[1].trim()),
      'name': ingredientString.split(',')[1].split(':')[1].trim(),
      'quantity': double.parse(ingredientString.split(',')[2].split(':')[1].trim()),
      'unit': ingredientString.split(',')[3].split(':')[1].trim().replaceAll('}', ''),
    };
  }
}

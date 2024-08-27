import '../ingredients_menu/ingredients_item.dart';
class ProductsItem{
  ProductsItem(this.id, this.name);

  final int id;
  final String name;
  List<IngredientsItem> ingredientsList = List.empty(growable: true);
}

class IngredientsItem {
  IngredientsItem({this.id, required this.name, required this.quantity, required this.unit});

  int? id;
  final String name;
  final double quantity;
  final String unit;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }

  factory IngredientsItem.fromMap(Map<String, dynamic> map) {
    return IngredientsItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      unit: map['unit'],
    );
  }
}

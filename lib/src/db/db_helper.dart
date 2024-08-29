import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../products_menu/products_item.dart';
import '../ingredients_menu/ingredients_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'products.db');

    return openDatabase(
      path,
      version: 4,
      onCreate: (db, version) {
        Future.wait([
          db.execute(
            'CREATE TABLE products(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
          ),
          db.execute(
            'CREATE TABLE ingredients(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id INTEGER, name TEXT, quantity REAL, unit TEXT, FOREIGN KEY(product_id) REFERENCES products(id))',
          ),
        ]);
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 4) {
          db.execute(
            'CREATE TABLE ingredients(id INTEGER PRIMARY KEY AUTOINCREMENT, product_id INTEGER, name TEXT, quantity REAL, unit TEXT, FOREIGN KEY(product_id) REFERENCES products(id))',
          );
        }
      },
    );
  }

  Future<void> insertProduct(ProductsItem product) async {
    final db = await database;
    await db.insert(
      'products',
      {'name': product.name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProductsItem>> getProducts() async {
  final db = await database;

  final List<Map<String, dynamic>> productMaps = await db.query('products');

  List<ProductsItem> products = [];

  for (var productMap in productMaps) {
    final product = ProductsItem(
      id: productMap['id'] as int,
      name: productMap['name'] as String,
    );

    final List<Map<String, dynamic>> ingredientMaps = await db.query(
      'ingredients',
      where: 'product_id = ?',
      whereArgs: [product.id],
    );

    product.ingredientsList = List.generate(ingredientMaps.length, (i) {
      return IngredientsItem(
        id: ingredientMaps[i]['id'] as int,
        name: ingredientMaps[i]['name'] as String,
        quantity: ingredientMaps[i]['quantity'] as double,
        unit: ingredientMaps[i]['unit'] as String,
      );
    });

    products.add(product);
  }

  return products;
}

  Future<void> deleteProduct(int id) async {
    final db = await database;
    await db.delete(
      'ingredients',
      where: 'product_Id = ?',
      whereArgs: [id]
    );
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert an ingredient
  Future<void> insertIngredient(int productId, IngredientsItem ingredient) async {
    final db = await database;
    await db.insert(
      'ingredients',
      {
        'product_Id': productId,
        'name': ingredient.name,
        'quantity': ingredient.quantity,
        'unit': ingredient.unit,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve ingredients for a product
  Future<List<IngredientsItem>> getIngredients(int productId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ingredients',
      where: 'product_Id = ?',
      whereArgs: [productId],
    );

    return List.generate(maps.length, (i) {
      return IngredientsItem(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
        quantity: maps[i]['quantity'] as double,
        unit: maps[i]['unit'] as String,
      );
    });
  }

  // Delete an ingredient
  Future<void> deleteIngredient(int id) async {
    final db = await database;
    await db.delete(
      'ingredients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

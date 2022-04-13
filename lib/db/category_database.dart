import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:the_eventors_app/models/category.dart';

class CategoryDatabase {
  static final CategoryDatabase instance = CategoryDatabase._init();

  static Database? _database;

  CategoryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('eventCategory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableCategory ( 
  ${CateogryFields.id} $idType, 
  ${CateogryFields.name} $textType
  )
''');
  }

  Future<int> getCategory(String category) async {
    var db = await instance.database;
    var res = await db
        .rawQuery("SELECT * FROM $tableCategory WHERE name = '$category'");

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<Category> getCategoryById(int category) async {
    var db = await instance.database;
    var maps = await db
        .rawQuery("SELECT * FROM $tableCategory WHERE id = '$category'");

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      throw Exception('Id $category not found');
    }
  }

  Future<Category> create(Category category) async {
    final db = await instance.database;

    final id = await db.insert(tableCategory, category.toJson());

    return category.copy(id: id);
  }

  Future<Category?> readByCategory(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategory,
      columns: CateogryFields.values,
      where: '${CateogryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<Category?> readById(int? id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableCategory,
      columns: CateogryFields.values,
      where: '${CateogryFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Category.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Category>> readAllCategories() async {
    final db = await instance.database;
    final result = await db.query(tableCategory);

    return result.map((json) => Category.fromJson(json)).toList();
  }

  Future<int> update(Category category) async {
    final db = await instance.database;

    return db.update(
      tableCategory,
      category.toJson(),
      where: '${CateogryFields.id} = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableCategory,
      where: '${CateogryFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:the_eventors_app/models/event.dart';

class EventDatabase {
  static final EventDatabase instance = EventDatabase._init();

  static Database? _database;

  EventDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('event-database.db');
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
    final textTypeNull = 'TEXT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableEvent ( 
  ${EventFields.id} $idType, 
  ${EventFields.title} $textType,
  ${EventFields.startTime} $textType,
  ${EventFields.duration} $textType,
  ${EventFields.location} $textType, 
  ${EventFields.description} $textType,
  ${EventFields.images} $textType,
  ${EventFields.categoryId} $integerType,
  ${EventFields.createdTime} $textType, 
  ${EventFields.createdBy} $textType,
  ${EventFields.guest} $textTypeNull,
  ${EventFields.going} $textTypeNull,
  ${EventFields.interesed} $textTypeNull

  )
''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;

    final id = await db.insert(tableEvent, event.toJson());

    return event.copy(id: id);
  }

  Future<Event?> readByEvent(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableEvent,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<Event?> readById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableEvent,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Event>> readAllEventsByUsername(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableEvent,
      columns: EventFields.values,
      where: '${EventFields.createdBy} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => Event.fromJson(json)).toList();
    } else {
      return List.empty();
    }
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;
    final result = await db.query(tableEvent);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<int> update(Event Event) async {
    final db = await instance.database;

    return db.update(
      tableEvent,
      Event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [Event.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableEvent,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

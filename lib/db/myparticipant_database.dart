/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:the_eventors_app/models/my_participant.dart';

class MyParticipantDatabase {
  static final MyParticipantDatabase instance = MyParticipantDatabase._init();

  static Database? _database;

  MyParticipantDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('eventmyparticipant.db');
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
CREATE TABLE $tableMyParticipant ( 
  ${MyParticipantFields.id} $idType,
  ${MyParticipantFields.username} $textType, 
  ${MyParticipantFields.eventId} $textType,
  ${MyParticipantFields.going} $textType,
  ${MyParticipantFields.interesed} $textType

  )
''');
  }

  Future<int> getMyParticipant(String category) async {
    var db = await instance.database;
    var res = await db
        .rawQuery("SELECT * FROM $tableMyParticipant WHERE name = '$category'");

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<MyParticipant> getMyParticipantById(int id) async {
    var db = await instance.database;
    var maps =
        await db.rawQuery("SELECT * FROM $tableMyParticipant WHERE id = '$id'");

    if (maps.isNotEmpty) {
      return MyParticipant.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<MyParticipant> getMyParticipantByUsername(String? id) async {
    var db = await instance.database;
    var maps = await db
        .rawQuery("SELECT * FROM $tableMyParticipant WHERE username = '$id'");

    if (maps.isNotEmpty) {
      return MyParticipant.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<MyParticipant> create(MyParticipant MyParticipant) async {
    final db = await instance.database;

    final id = await db.insert(tableMyParticipant, MyParticipant.toJson());

    return MyParticipant.copy(id: id);
  }

  Future<MyParticipant?> readByMyParticipant(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableMyParticipant,
      columns: MyParticipantFields.values,
      where: '${MyParticipantFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MyParticipant.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<MyParticipant>> readAllMyParticipants() async {
    final db = await instance.database;
    final result = await db.query(tableMyParticipant);

    return result.map((json) => MyParticipant.fromJson(json)).toList();
  }

  Future<int> update(MyParticipant MyParticipant) async {
    final db = await instance.database;

    return db.update(
      tableMyParticipant,
      MyParticipant.toJson(),
      where: '${MyParticipantFields.id} = ?',
      whereArgs: [MyParticipant.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableMyParticipant,
      where: '${MyParticipantFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}*/

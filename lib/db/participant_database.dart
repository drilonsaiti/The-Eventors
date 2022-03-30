import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:the_eventors_app/models/participant.dart';

class ParticipantDatabase {
  static final ParticipantDatabase instance = ParticipantDatabase._init();

  static Database? _database;

  ParticipantDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('event-participant.db');
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
CREATE TABLE $tableParticipant ( 
  ${ParticipantFields.id} $idType, 
  ${ParticipantFields.eventId} $integerType,
  ${ParticipantFields.going} $textType,
  ${ParticipantFields.interesed} $textType

  )
''');
  }

  Future<int> getParticipant(int category) async {
    var db = await instance.database;
    var res = await db
        .rawQuery("SELECT * FROM $tableParticipant WHERE id = '$category'");

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<Participant> getParticipantById(int id) async {
    var db = await instance.database;
    var maps =
        await db.rawQuery("SELECT * FROM $tableParticipant WHERE id = '$id'");

    if (maps.isNotEmpty) {
      return Participant.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<Participant> getParticipantByEvent(int? id) async {
    var db = await instance.database;
    var maps = await db
        .rawQuery("SELECT * FROM $tableParticipant WHERE eventId = '$id'");

    if (maps.isNotEmpty) {
      return Participant.fromJson(maps.first);
    } else {
      throw Exception('Id $id not found');
    }
  }

  Future<Participant> create(Participant participant) async {
    final db = await instance.database;

    final id = await db.insert(tableParticipant, participant.toJson());

    return participant.copy(id: id);
  }

  Future<Participant?> readByParticipant(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableParticipant,
      columns: ParticipantFields.values,
      where: '${ParticipantFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Participant.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Participant>> readAllParticipants() async {
    final db = await instance.database;
    final result = await db.query(tableParticipant);

    return result.map((json) => Participant.fromJson(json)).toList();
  }

  Future<int> update(Participant participant) async {
    final db = await instance.database;

    return db.update(
      tableParticipant,
      participant.toJson(),
      where: '${ParticipantFields.id} = ?',
      whereArgs: [participant.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableParticipant,
      where: '${ParticipantFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

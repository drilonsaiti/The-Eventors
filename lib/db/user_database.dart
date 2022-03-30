import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:the_eventors_app/models/user.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('event.db');
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
CREATE TABLE $tableUser ( 
  ${UserFields.id} $idType, 
  ${UserFields.username} $textType,
  ${UserFields.email} $textType,
  ${UserFields.password} $textType,
  ${UserFields.images} $textType
  )
''');
  }

  Future<User?> create(User user) async {
    final db = await instance.database;

    final id = await db.insert(tableUser, user.toJson());
    return user.copy(id: id);
  }

  Future<User?> readUser(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: '${UserFields.username} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Future<User?> readUserByUsername(String id) async {
    var db = await instance.database;
    String path = await getDatabasesPath();
    debugPrint(path);
    var res = await db.rawQuery("SELECT * FROM user WHERE username = '$id'");
    debugPrint(res.toString());
    if (res.isNotEmpty) {
      return User.fromJson(res.first);
    }

    return null;
  }

  Future<User?> readUserByEmail(String id) async {
    var db = await instance.database;
    var res = await db.rawQuery("SELECT * FROM user WHERE email = '$id'");

    if (res.length > 0) {
      return User.fromJson(res.first);
    }

    return null;
  }

  Future<int> getLogin(String user, String password) async {
    var db = await instance.database;
    var res = await db.rawQuery(
        "SELECT * FROM $tableUser WHERE username = '$user' AND password = '$password'");

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<int> getByUsername(String? user) async {
    var db = await instance.database;
    var res =
        await db.rawQuery("SELECT * FROM $tableUser WHERE username = '$user'");

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<User> getUserByUsername(String? user) async {
    var db = await instance.database;
    var maps =
        await db.rawQuery("SELECT * FROM $tableUser WHERE username = '$user'");

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception('Id $user not found');
    }
  }

  Future<int> getPassword(String user, String password) async {
    var db = await instance.database;
    var res = await db
        .rawQuery("SELECT password FROM $tableUser WHERE username = '$user'");
    password = "{password: " + password + "}";
    bool isT = res.first.toString() == password;
    debugPrint(("PASS RES " + isT.toString()));
    if (res.toString() == password) {
      return 1;
    }

    return -1;
  }

  Future<int> getEmail(String user) async {
    var db = await instance.database;
    var res = await db
        .rawQuery("SELECT email FROM $tableUser WHERE username = '$user'");

    user = "{email: " + user + "}";
    bool isT = res.first.toString() == user;
    debugPrint("DATABASE GETMAIL " +
        res.first.toString() +
        " " +
        user +
        " " +
        isT.toString());

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<int> getByEmail(String user) async {
    var db = await instance.database;
    var res =
        await db.rawQuery("SELECT * FROM $tableUser WHERE email = '$user'");

    if (res.length > 0) {
      return 1;
    }

    return -1;
  }

  Future<List<User>> readAllusers() async {
    final db = await instance.database;
    final result = await db.query(tableUser);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> update(User user) async {
    final db = await instance.database;

    return db.update(
      tableUser,
      user.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await instance.database;

    return await db.delete(
      tableUser,
      where: '${UserFields.username} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}

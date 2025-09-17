import 'package:contact_app/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper {
  static Database? _database;
  Future<Database> get dataBase async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'contact_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE contacts(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT UNIQUE NOT NULL, phone TEXT UNIQUE NOT NULL, gmail TEXT NOT NULL )''',
        );
      },
    );
  }

  Future<void> insertUser(User user) async {
    final db = await dataBase;
    await db.insert(
      'contacts',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<List<User>> getUser() async {
    final db = await dataBase;
    final result = await db.query('contacts');
    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<void> deleteUser(int id) async {
    final db = await dataBase;
    await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateUser(User user) async {
    final db = await dataBase;
    await db.update(
      'contacts',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<bool> isNameExist(String name) async {
    final db = await dataBase;
    final result = await db.query(
      'contacts',
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  Future<bool> isphoneExist(String phone) async {
    final db = await dataBase;
    final result = await db.query(
      'contacts',
      where: 'phone = ?',
      whereArgs: [phone],
    );
    return result.isNotEmpty;
  }
}

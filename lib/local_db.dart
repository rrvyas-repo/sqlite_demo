import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_demo/local_db.model.dart';

class LocalDataBase {
  static Future<Database> get openDb async {
    return await openDatabase(
      join(await getDatabasesPath(), 'student.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE studentData(id INTEGER PRIMARY KEY, name TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertData(Student data) async {
    final db = await openDb;
    await db.insert(
      'studentData',
      data.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Student>> selectData() async {
    final db = await openDb;
    final List<Map<String, dynamic>> maps = await db.query('studentData');
    // await db.close();
    return List.generate(maps.length, (i) {
      return Student.fromJson(maps[i]);
      // return {
      //   'id': maps[i]['id'],
      //   'name': maps[i]['name'],
      // };
    });
  }

  static Future<void> updateData(Student data) async {
    final db = await openDb;
    await db.update(
      'studentData',
      data.toJson(),
      where: 'id = ?',
      whereArgs: [data.id],
    );
    // await db.close();
  }

  static Future<void> deleteData(int id) async {
    final db = await openDb;
    await db.delete(
      'studentData',
      where: 'id = ?',
      whereArgs: [id],
    );
    // await db.close();
  }

  static Future<void> get closeDb async {
    final db = await openDb;
    db.close();
  }
}

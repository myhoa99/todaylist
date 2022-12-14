import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../model/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 5;
  static final String _tableName = 'task';
  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'task.db';
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        print('create a new one');
        return db.execute('CREATE TABLE $_tableName ('
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING,"
            "note TEXT,"
            "date STRING,"
            "startTime STRING, "
            "endTime SRING,"
            "remind INTERGER,"
            "repeat STRING, "
            "color INTERGER,"
            "isCompleted INTERGER )");
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function call');
    return await _db?.insert(_tableName, task!.toJson()) ?? 1;
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('quert funcion');
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id) async {
    return await _db!.rawUpdate('''
        UPDATE task
        SET isCompleted=? 
        WHERE id=?
        ''', [1, id]);
  }
}

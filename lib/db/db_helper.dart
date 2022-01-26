import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '/models/task.dart';

class DBHelper {
  static Database? _db;
  static const int _version = 1;

  static const String _tableName = 'tasks';

  static Future<void> initDB() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'tasks.db';
        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          return db.execute(
            'CREATE TABLE $_tableName ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title STRING, '
            'note TEXT, '
            'isCompleted INTEGER, '
            'color INTEGER, '
            'startTime STRING, '
            'endTime STRING, '
            'date INTEGER, '
            'remind INTEGER, '
            'repeat STRING)',
          );
        });
        print('CREATE DATABASE ');
      } catch (e) {
        print(e);
      }
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function code');
    return await _db!.insert(_tableName, task!.toJson());
  }

  static Future<int> delete(Task task) async {
    print('delete function code');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAllTask() async {
    print('delete All function code');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('query function code');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    print('update function code ');
    return await _db!.rawUpdate('''
    UPDATE tasks 
    SET isComplete = ? 
    WHERE id = ?  
    ''', [1, id]);
  }
}

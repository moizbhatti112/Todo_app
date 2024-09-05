import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_practice/models/todomodel.dart';

class DbHandler {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }

    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'mydatabase.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
CREATE TABLE Tasktable(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  isdone BOOL
  
  )

''');
      },
    );
    return _database;
  }

  Future<int> insertdata(Todomodel task) async {
    Database? db = await database;
    int id=await db!.insert(
      'Tasktable',
      {'name': task.name, 'isdone': task.isdone ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Todomodel>> gettasks() async {
    Database? db = await database;
    final List<Map<String, dynamic>> maps = await db!.query('Tasktable');

    return List.generate(maps.length, (i) {
      return Todomodel(
        
   id: maps[i]['id'],     name: maps[i]['name'], isdone: maps[i]['isdone'] == 1);
    });
  }

  Future<void> deltask(String name) async {
    Database? db = await database;
    await db?.delete('Tasktable', where: 'name=?', whereArgs: [name]);
  }

  Future<void> updateisdone(Todomodel task) async {
    Database? db = await database;
    await db?.update('Tasktable', {'isdone': task.isdone ? 1 : 0},
        where: 'name=?', whereArgs: [task.name]);
  }

  Future<void> edit(Todomodel task) async {
    Database? db = await database;
    db?.update('Tasktable', {'name':task.name,'isdone':task.isdone?1:0},where: 'id=?',whereArgs: [task.id]);
  }
}

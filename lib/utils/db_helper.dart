import 'dart:async';
import 'dart:core';

import 'package:sqflite/sqflite.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cssflutter/models/note.dart';

class DataBaseHelper {
  static DataBaseHelper _databaseHelper;
  static Database _database;

  String studentTable = 'student_table';
  String colId = 'id';
  String colName = 'name';
  String colDescription = 'description';
  String colGender = 'gender';
  String colDate = 'date';

  DataBaseHelper._createInstance();
  factory DataBaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DataBaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'students.db';

    var studentDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return studentDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $studentTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colName TEXT,$colDescription TEXT,$colGender TEXT,$colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(studentTable, orderBy: '$colGender ASC');
    return result;
  }

  Future<int> insertStudent(Note note) async {
    Database db = await this.database;
    var result = await db.insert(studentTable, note.toMap());
    return result;
  }

  Future<int> updateStudent(Note note) async {
    var db = await this.database;
    var result = await db.update(studentTable, note.toMap(),
        where: '$colId=?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteStudent(int id) async {
    var db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $studentTable WHERE $colId=$id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FOM $studentTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;
    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;
  }
}

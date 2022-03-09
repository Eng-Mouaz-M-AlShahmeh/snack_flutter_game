/* Developed by Eng Mouaz M AlShahmeh */
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:snack_flutter_game/database/database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class GameDatabase {
  GameDatabase._privateConstructor();

  static final GameDatabase instance = GameDatabase._privateConstructor();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, DataBaseConstants.dbName);
    return await openDatabase(path,
        version: DataBaseConstants.dbVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) {
    db.execute('''
      CREATE TABLE ${DataBaseConstants.scoreTable} (
      ${DataBaseConstants.columnId} INTEGER PRIMARY KEY,
      ${DataBaseConstants.score} INTEGER NOT NULL,
      ${DataBaseConstants.date} TEXT )
      ''');
    db.execute('''
      CREATE TABLE ${DataBaseConstants.resumeGameTable} (
      ${DataBaseConstants.columnId} INTEGER PRIMARY KEY,
      ${DataBaseConstants.direction} INTEGER NOT NULL,
      ${DataBaseConstants.dx} INTEGER NOT NULL,
      ${DataBaseConstants.dy} INTEGER NOT NULL )
      ''');
    db.execute('''
      CREATE TABLE ${DataBaseConstants.settingsTable} (
       ${DataBaseConstants.columnId} INTEGER PRIMARY KEY,
      ${DataBaseConstants.snackColor} TEXT,
      ${DataBaseConstants.eggColor} TEXT,
      ${DataBaseConstants.speed} INTEGER NOT NULL,
      ${DataBaseConstants.sound} INTEGER NOT NULL,
      ${DataBaseConstants.showLines} INTEGER NOT NULL )
      ''');
  }
}

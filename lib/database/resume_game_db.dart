/* Developed by Eng Mouaz M AlShahmeh */
import 'package:snack_flutter_game/database/database_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'game_database.dart';

class ResumeGameDb {
  static Future<int> insert(Map<String, dynamic> row) async {
    Database db = await GameDatabase.instance.database;
    return await db.insert(DataBaseConstants.resumeGameTable, row);
  }

  static Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await GameDatabase.instance.database;
    return await db.query(DataBaseConstants.resumeGameTable);
  }

  static Future<int> deleteAll() async {
    Database db = await GameDatabase.instance.database;
    return await db.delete(DataBaseConstants.resumeGameTable);
  }
}

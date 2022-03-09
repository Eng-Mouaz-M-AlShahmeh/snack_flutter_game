/* Developed by Eng Mouaz M AlShahmeh */
import 'package:snack_flutter_game/database/game_database.dart';
import 'package:sqflite/sqflite.dart';
import 'database_constants.dart';

class SettingsDb {

  static Future<int> insert(Map<String,dynamic> row) async {
      Database db = await GameDatabase.instance.database;
      return await db.insert(DataBaseConstants.settingsTable, row);
  }
  static Future<List<Map<String,dynamic>>> queryAll() async {
    Database db = await GameDatabase.instance.database;
    return await db.query(DataBaseConstants.settingsTable);
  }
  static Future<int> deleteAll() async {
    Database db = await GameDatabase.instance.database;
    return await db.delete(DataBaseConstants.settingsTable);
  }
}
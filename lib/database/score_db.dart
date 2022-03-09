/* Developed by Eng Mouaz M AlShahmeh */
import 'package:snack_flutter_game/database/database_constants.dart';
import 'package:snack_flutter_game/database/game_database.dart';
import 'package:sqflite/sqflite.dart';

class ScoreDb {

  static Future<int> insert(Map<String, dynamic> row) async {
    Database db = await GameDatabase.instance.database;
    return await db.insert(DataBaseConstants.scoreTable, row);
  }
  static Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await GameDatabase.instance.database;
    return await db.query(DataBaseConstants.scoreTable);
  }

}

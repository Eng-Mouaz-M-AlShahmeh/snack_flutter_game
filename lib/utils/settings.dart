/* Developed by Eng Mouaz M AlShahmeh */
import 'package:snack_flutter_game/database/database_constants.dart';

class Settings {
  static String snackColor;
  static String eggColor;
  static int speed;
  static bool showLines;
  static bool sound;

  static fromJson(Map<String, dynamic> data) {
    snackColor = data[DataBaseConstants.snackColor];
    eggColor = data[DataBaseConstants.eggColor];
    speed = data[DataBaseConstants.speed];
    showLines = data[DataBaseConstants.showLines] == 1;
    sound = data[DataBaseConstants.sound] == 1;
  }

  static setDefaultData() {
    snackColor = 'FF00BCD4';
    eggColor = 'FFEC407A';
    speed = 80;
    showLines = false;
    sound = true;
  }
  static toJson() {
    return {
      DataBaseConstants.snackColor: snackColor,
      DataBaseConstants.eggColor: eggColor,
      DataBaseConstants.speed: speed,
      DataBaseConstants.sound: sound ? 1 : 0,
      DataBaseConstants.showLines: showLines ? 1 :0
    };
  }
}

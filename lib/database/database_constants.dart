/* Developed by Eng Mouaz M AlShahmeh */
import 'package:intl/intl.dart';

class DataBaseConstants {
  static const dbName = 'snackGame.db';
  static const dbVersion = 1;
  static const resumeGameTable = 'resumeGameTable';
  static const columnId='_id';
  static const direction = 'direction';
  static const dx = 'dx';
  static const dy = 'dy';
  static const score = 'score';
  static const date = 'date';
  static const scoreTable = 'scoreTable';
  static final dateFormat = DateFormat("h:mm a d-M-yyyy");
  static const settingsTable = 'settings';
  static const snackColor = 'snackColor';
  static const eggColor = 'eggColor';
  static const speed = 'speed';
  static const sound = 'sound';
  static const showLines = 'showLines';

}
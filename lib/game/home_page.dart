/* Developed by Eng Mouaz M AlShahmeh */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snack_flutter_game/database/resume_game_db.dart';
import 'package:snack_flutter_game/database/score_db.dart';
import 'package:snack_flutter_game/database/settings_db.dart';
import 'package:snack_flutter_game/game/game_screen.dart';
import 'package:snack_flutter_game/game/score_screen.dart';
import 'package:snack_flutter_game/game/settings_screen.dart';
import 'package:snack_flutter_game/utils/color_pallette.dart';
import 'package:snack_flutter_game/utils/settings.dart';
import 'package:snack_flutter_game/widgets/my_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> resumeGameData;
  List<Map<String, dynamic>> settingsData;

  @override
  void initState() {
    super.initState();
    fetchPreviousData();
  }

  fetchPreviousData() async {
    resumeGameData = await ResumeGameDb.queryAll();
    settingsData = await SettingsDb.queryAll();
    if (settingsData != null && settingsData.isNotEmpty) {
      Settings.fromJson(settingsData.first);
    } else {
      Settings.setDefaultData();
      await SettingsDb.insert(Settings.toJson());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallette.darkBlue,
      body: Column(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'لعبة الثعبان',
                textAlign: TextAlign.center,
                style: GoogleFonts.almarai(
                    letterSpacing: 15.0, color: Colors.white, fontSize: 50),
              ),
            ],
          ),
          const SizedBox(height: 100),
          if (resumeGameData != null && resumeGameData.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton('استعادة',
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  width: 200,
                  height: 50, onPressed: () async {
                int deletedRow = await ResumeGameDb.deleteAll();
                print('deleted row :$deletedRow');
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GameScreen(
                              data: resumeGameData,
                            )));
              }),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton('لعبة جديدة',
                buttonColor: Colors.white,
                textColor: Colors.black,
                width: 200,
                height: 50, onPressed: () async {
              int deletedRow = await ResumeGameDb.deleteAll();
              print('deleted row :$deletedRow');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => GameScreen()));
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
              'النتائج',
              buttonColor: Colors.white,
              textColor: Colors.black,
              width: 200,
              height: 50,
              onPressed: () async {
                var data = await ScoreDb.queryAll();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScoreScreen()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MyButton(
              'الإعدادات',
              buttonColor: Colors.white,
              textColor: Colors.black,
              width: 200,
              height: 50,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

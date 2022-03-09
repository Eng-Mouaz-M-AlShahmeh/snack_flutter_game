/* Developed by Eng Mouaz M AlShahmeh */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snack_flutter_game/database/settings_db.dart';
import 'package:snack_flutter_game/utils/color_pallette.dart';
import 'package:snack_flutter_game/utils/settings.dart';
import 'package:snack_flutter_game/widgets/settings_tile.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool sound;
  bool showLines;
  String tempSnackColor;
  String tempEggColor;
  int speed;

  bool showSnackColorDialog = false;
  bool showEggColorDialog = false;
  bool showSpeedDialog = false;

  @override
  void initState() {
    super.initState();
    tempSnackColor = Settings.snackColor;
    tempEggColor = Settings.eggColor;
    speed = Settings.speed;
    sound = Settings.sound;
    showLines = Settings.showLines;
  }

  @override
  Widget build(BuildContext context) {
    print('hash code : ${ColorPallette.canvasColor.hashCode}');
    return Scaffold(
        backgroundColor: ColorPallette.canvasColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.chevron_left,
              size: 35,
              color: Colors.grey[400],
            ),
          ),
          title: Text(
            'الإعدادات',
            style: GoogleFonts.almarai(color: Colors.white, letterSpacing: 5),
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  Icons.done,
                  size: 26,
                  color: Colors.white,
                ),
                onPressed: () async {
                  await SettingsDb.deleteAll();
                  Settings.eggColor = tempEggColor;
                  Settings.snackColor = tempSnackColor;
                  Settings.speed = speed;
                  Settings.showLines = showLines;
                  Settings.sound = sound;
                  await SettingsDb.insert(Settings.toJson());
                  Navigator.pop(context);
                })
          ],
          elevation: 0,
          backgroundColor: ColorPallette.canvasColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    showSnackColorDialog = !showSnackColorDialog;
                  });
                },
                child: SettingsTile(
                    text: 'لون الثعبان',
                    widget: Container(
                      width: 20,
                      height: 20,
                      color: Color(int.parse(tempSnackColor, radix: 16)),
                    )),
              ),

              if (showSnackColorDialog)
                Container(
                    height: 70,
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          SnackAndAggColors.colors.length,
                              (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                tempSnackColor =
                                SnackAndAggColors.colors[index];
                                showSnackColorDialog = false;
                              });
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              color: Color(int.parse(
                                  SnackAndAggColors.colors[index],
                                  radix: 16)),
                            ),
                          )),
                    )),

              GestureDetector(
                onTap: () {
                  setState(() {
                    showEggColorDialog = !showEggColorDialog;
                  });
                },
                child: SettingsTile(
                    text: 'لون البيض',
                    widget: Container(
                      width: 20,
                      height: 20,
                      color: Color(int.parse(tempEggColor, radix: 16)),
                    )),
              ),
              if (showEggColorDialog)
                Container(
                    height: 70,
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          SnackAndAggColors.colors.length,
                          (index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tempEggColor =
                                        SnackAndAggColors.colors[index];
                                    showEggColorDialog = false;
                                  });
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  color: Color(int.parse(
                                      SnackAndAggColors.colors[index],
                                      radix: 16)),
                                ),
                              )),
                    )),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showSpeedDialog = !showSpeedDialog;
                  });
                },
                child: SettingsTile(
                  text: 'السرعة',
                  widget: Text(
                    speed.toString(),
                    style: GoogleFonts.aBeeZee(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0),
                  ),
                ),
              ),
              if (showSpeedDialog)
                Container(
                    height: 70,
                    padding: const EdgeInsets.all(10.0),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15)),
                    child: Slider(
                      onChanged: (value) {
                        setState(() {
                          speed = value.round();
                        });
                      },
                      value: speed.toDouble(),
                      activeColor: Colors.white,
                      inactiveColor: Colors.white12,
                      min: 1.0,
                      max: 100.0,
                    )),
              SettingsTile(
                text: 'الصوت',
                padding: const EdgeInsets.only(right: 10.0, top: 0, bottom: 0),
                widget: Switch(
                  value: sound,
                  activeColor: Colors.white,
                  inactiveTrackColor: Colors.white12,
                  onChanged: (value) {
                    setState(() {
                      sound = !sound;
                    });
                  },
                ),
              ),
              SettingsTile(
                text: 'الخطوط',
                padding: const EdgeInsets.only(right: 10.0, top: 0, bottom: 0),
                widget: Switch(
                  value: showLines,
                  activeColor: Colors.white,
                  inactiveTrackColor: Colors.white12,
                  onChanged: (value) {
                    setState(() {
                      showLines = !showLines;
                    });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

/* Developed by Eng Mouaz M AlShahmeh */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snack_flutter_game/database/score_db.dart';
import 'package:snack_flutter_game/utils/color_pallette.dart';

class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  List<Map<String, dynamic>> scoreData;
  int maximum = 0;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    scoreData = await ScoreDb.queryAll();
    setState(() {
      for (var element in scoreData) {
        maximum = element["score"] > maximum ? element["score"] : maximum;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'النتائج',
          style: GoogleFonts.almarai(color: Colors.white, letterSpacing: 5),
        ),
        elevation: 0,
        backgroundColor: ColorPallette.canvasColor,
      ),
      body: scoreData == null
          ? const Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ))
          : ListView.builder(
              itemCount: scoreData.length,
              itemBuilder: (context, index) {
                bool isHighest = scoreData[index]["score"] == maximum;
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: isHighest
                              ? Colors.cyan[200]
                              : ColorPallette.canvasBorderColor,
                          width: 1),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        scoreData[index]["date"].toString(),
                        style: GoogleFonts.aBeeZee(
                            fontSize: 14,
                            letterSpacing: 1.5,
                            color: isHighest ? Colors.cyan : Colors.grey[400]),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        scoreData[index]["score"].toString(),
                        style: GoogleFonts.aBeeZee(
                            fontSize: 20,
                            letterSpacing: 2.0,
                            fontWeight: FontWeight.bold,
                            color: isHighest ? Colors.cyan : Colors.grey[200]),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

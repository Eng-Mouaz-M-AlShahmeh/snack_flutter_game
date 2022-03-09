/* Developed by Eng Mouaz M AlShahmeh */
import 'dart:async';
import 'dart:collection';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snack_flutter_game/database/database_constants.dart';
import 'package:snack_flutter_game/database/resume_game_db.dart';
import 'package:snack_flutter_game/database/score_db.dart';
import 'package:snack_flutter_game/game/home_page.dart';
import 'package:snack_flutter_game/painter/my_painter.dart';
import 'package:snack_flutter_game/utils/settings.dart';
import '../utils/utils.dart';

class GameScreen extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  GameScreen({this.data});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  bool isPaused = true;
  bool left = false;
  bool right = true;
  bool up = false;
  bool down = false;
  bool gameOver = false;
  bool isVariableInit = false;
  int drawNewAggTime = 0;
  int snackHeadX = 0;
  int snackHeadY = 0;
  int move = 20;
  double width = 0;
  double height = 0;
  int score = 0;
  double bottomContainerHeight = 150;
  double topContainerHeight = 50;
  double controlSize = 45;
  final newAggDelayTime = SnackUtils.drawNewAggTime;
  int delay = 150;
  Timer timer;

  List<double> xPoints = [];
  List<double> yPoints = [];
  AnimationController _animationController;
  Offset eggLocation;
  Queue<Offset> snackLocations = Queue();

  @override
  void initState() {
    super.initState();
    if (widget.data != null && widget.data.isNotEmpty) {
      fetchPreviousData();
      snackHeadX = snackLocations.last.dx.round();
      snackHeadY = snackLocations.last.dy.round();
    } else {
      snackLocations.add(Offset(snackHeadX.toDouble(), snackHeadY.toDouble()));
    }

    move = SnackUtils.snackRectSize;
    delay = (530 - 5 * Settings.speed).round();
    print('delay : $delay');
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animationController.forward();

    timer = Timer.periodic(Duration(milliseconds: delay), (value) {
      setState(() {
        moveSnack();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  storeScore() async {
    Map<String, dynamic> data = {
      DataBaseConstants.score: score,
      DataBaseConstants.date:
          DataBaseConstants.dateFormat.format(DateTime.now()),
    };
    await ScoreDb.insert(data);
  }

  storeCurrentData() async {
    String direction = left
        ? "left"
        : right
            ? "right"
            : up
                ? "up"
                : "down";

    List list = snackLocations.toList();

    // storing egg locations at end
    if (drawNewAggTime > 0) {
      drawNewAgg();
    }
    list.add(eggLocation);
    for (var offset in list) {
      Map<String, dynamic> map = {
        DataBaseConstants.direction: direction,
        DataBaseConstants.dx: offset.dx.round(),
        DataBaseConstants.dy: offset.dy.round()
      };
      print(map);
      print("Row inserted : ${ResumeGameDb.insert(map)}");
    }
    // ResumeGameDb.instance.insert(game.toMap());
  }

  fetchPreviousData() {
    String direction;
    for (var value in widget.data) {
      direction = value[DataBaseConstants.direction];
      snackLocations.add(Offset(value[DataBaseConstants.dx].toDouble(),
          value[DataBaseConstants.dy].toDouble()));
    }
    drawNewAggTime = -1;
    eggLocation = snackLocations.removeLast();
    score = snackLocations.length - 1;

    switch (direction) {
      case "left":
        {
          left = true;
          right = up = down = false;
          break;
        }
      case "right":
        {
          right = true;
          up = down = left = false;
          break;
        }
      case "up":
        {
          up = true;
          down = left = right = false;
          break;
        }
      case "down":
        {
          down = true;
          up = left = right = false;
          break;
        }
    }
  }

  Future<AudioPlayer> playSound() async {
    if (!Settings.sound) return null;
    AudioCache cache = AudioCache();
    return await cache.play("hat.mp3");
  }

  moveSnack() {
    if (isPaused) {
      return;
    }

    //Moving Agg according to direction
    if (up) {
      snackHeadY = snackHeadY <= yPoints[0].round()
          ? yPoints[yPoints.length - 1].round()
          : snackHeadY - move;
    } else if (down) {
      snackHeadY = snackHeadY >= yPoints[yPoints.length - 1].round()
          ? yPoints[0].round()
          : snackHeadY + move;
    } else if (left) {
      snackHeadX = snackHeadX <= xPoints[0].round()
          ? xPoints[xPoints.length - 1].round()
          : snackHeadX - move;
    } else if (right) {
      snackHeadX = snackHeadX >= xPoints[xPoints.length - 1].round()
          ? xPoints[0].round()
          : snackHeadX + move;
    }

    // if snack's offsets containing new head location then that means head is touched with his tail
    Offset head = Offset(snackHeadX.toDouble(), snackHeadY.toDouble());
    if (snackLocations.contains(head)) {
      setState(() {
        isPaused = true;
      });
      storeScore();
      gameOver = true;
      showGameOverDialog(context);

      return;
    }
    snackLocations.add(head);

    //Checking Agg location with snack head
    if (snackHeadX == eggLocation.dx && snackHeadY == eggLocation.dy) {
      playSound();
      eggLocation = const Offset(-50, -50);
      score++;
      drawNewAggTime = newAggDelayTime;
    } else {
      snackLocations.removeFirst();
    }
  }

  drawNewAgg() {
    // generating random x and y offset for new agg location from xPoints and yPoints list
    eggLocation = Offset(xPoints[Random().nextInt(xPoints.length - 1)],
        yPoints[Random().nextInt(yPoints.length - 1)]);

    //If new agg location is over lapping snack locations then we're recalling function for new egg locations
    if (snackLocations.contains(eggLocation)) {
      drawNewAgg();
    }
  }

  initVariables() {
    for (double y = 0;
        y <
            height -
                topContainerHeight -
                bottomContainerHeight -
                MediaQuery.of(context).padding.top;
        y += SnackUtils.snackRectSize) {
      yPoints.add(y);
    }
    for (double x = 0; x < width; x += SnackUtils.snackRectSize) {
      xPoints.add(x);
    }
    //Removing points which are out of the box
    xPoints.removeLast();
    yPoints.removeLast();

    if (drawNewAggTime == 0) {
      drawNewAgg();
    }
  }

  checkNewAggTime() {
    if (drawNewAggTime > 0) {
      drawNewAggTime--;
      if (drawNewAggTime == 0) {
        drawNewAgg();
      }
    }
  }

  moveLeft() {
    if (isPaused) {
      return;
    }
    if (right && snackLocations.length > 1) {
      return;
      // snackHeadY += move;
      // if (!yPoints.contains(snackHeadY)) {
      //   snackHeadY -= 2 * move;
      // }
      // snackLocations.add(Offset(snackHeadX.toDouble(), snackHeadY.toDouble()));
      // snackLocations.removeFirst();
    }
    down = false;
    up = false;
    left = true;
    right = false;
  }

  moveRight() {
    if (isPaused) {
      return;
    }
    if (left && snackLocations.length > 1) {
      return;
      // snackHeadY -= move;
      // if (!yPoints.contains(snackHeadY)) {
      //   snackHeadY += 2 * move;
      // }
      // snackLocations.add(Offset(snackHeadX.toDouble(), snackHeadY.toDouble()));
      // snackLocations.removeFirst();
    }
    down = false;
    up = false;
    left = false;
    right = true;
  }

  moveUp() {
    if (isPaused) {
      return;
    }
    if (down && snackLocations.length > 1) {
      return;
      // snackHeadX -= move;
      // if (!xPoints.contains(snackHeadX)) {
      //   snackHeadX += 2 * move;
      // }
      // snackLocations.add(Offset(snackHeadX.toDouble(), snackHeadY.toDouble()));
      // snackLocations.removeFirst();
    }
    down = false;
    up = true;
    left = false;
    right = false;
  }

  moveDown() {
    if (isPaused) {
      return;
    }
    if (up && snackLocations.length > 1) {
      return;
      // snackHeadX += move;
      // if (!xPoints.contains(snackHeadX)) {
      //   snackHeadX -= 2 * move;
      // }
      // snackLocations.add(Offset(snackHeadX.toDouble(), snackHeadY.toDouble()));
      // snackLocations.removeFirst();
    }
    down = true;
    up = false;
    left = false;
    right = false;
  }

  showGameOverDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async{
              return false;
            },
            child: AlertDialog(
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'انتهت اللعبة',
                    style: GoogleFonts.almarai(color: Colors.black, fontSize: 30),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.yellow,
                      onPressed: () {
                        gameOver = false;
                        snackLocations.clear();
                        snackHeadX = 0;
                        snackHeadY = 0;
                        snackLocations.add(
                            Offset(snackHeadX.toDouble(), snackHeadY.toDouble()));
                        score = 0;
                        isPaused = true;
                        drawNewAgg();
                        Navigator.pop(context);
                      },
                      child: Text(
                        'موافق',
                        style: GoogleFonts.almarai(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    if(gameOver) {

    }
    checkNewAggTime();
    if (!isVariableInit) {
      initVariables();
      isVariableInit = true;
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPallette.canvasColor,
        body: Column(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorPallette.canvasColor,
                boxShadow: [
                  BoxShadow(
                      color: ColorPallette.canvasBorderColor,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: const Offset(0, 0)),
                ],
              ),
              child: CustomPaint(
                size: Size(xPoints.length * SnackUtils.snackRectSize.toDouble(),
                    yPoints.length * SnackUtils.snackRectSize.toDouble()),
                painter: MyPainter(snackLocations, eggLocation),
                willChange: true,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: topContainerHeight,
              decoration: BoxDecoration(
                color: ColorPallette.controlContainerColor,
              ),
              child: Text("النقاط  :  " + score.toString(),
                  style: GoogleFonts.almarai(
                      fontSize: 25,
                      color: ColorPallette.scoreTextColor,
                      letterSpacing: 2.2)),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: bottomContainerHeight,
              decoration: BoxDecoration(
                color: ColorPallette.controlContainerColor,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!isPaused)
                    Expanded(
                      child: TextButton(
                        child: Icon(
                          Icons.arrow_drop_up,
                          size: controlSize,
                          color: ColorPallette.controlColor,
                        ),
                        onPressed: () {
                          setState(() {
                            moveUp();
                          });
                        },
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Icon(
                            isPaused ? Icons.home_filled : Icons.arrow_left,
                            size: controlSize,
                            color: ColorPallette.controlColor,
                          ),
                          onPressed: () {
                            if (isPaused) {
                              storeCurrentData();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            } else {
                              setState(() {
                                moveRight();
                              });
                            }
                          },
                        ),

                        TextButton(
                          child: Icon(
                            isPaused ? Icons.play_arrow : Icons.pause,
                            size: controlSize + 5,
                            color: ColorPallette.controlColor,
                          ),
                          onPressed: () {
                            isPaused = !isPaused;
                          },
                        ),

                        TextButton(
                          child: Icon(
                            isPaused ? Icons.refresh : Icons.arrow_right,
                            size: controlSize,
                            color: ColorPallette.controlColor,
                          ),
                          onPressed: () {
                            if (isPaused) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GameScreen()));
                            } else {
                              setState(() {
                                moveLeft();
                              });
                            }
                          },
                        ),


                      ],
                    ),
                  ),
                  if (!isPaused)
                    Expanded(
                      child: TextButton(
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: controlSize,
                          color: ColorPallette.controlColor,
                        ),
                        onPressed: () {
                          setState(() {
                            moveDown();
                          });
                        },
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

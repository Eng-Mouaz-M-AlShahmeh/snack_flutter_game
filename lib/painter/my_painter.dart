/* Developed by Eng Mouaz M AlShahmeh */
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:snack_flutter_game/utils/settings.dart';
import '../utils/utils.dart';

class MyPainter extends CustomPainter {
  Queue<Offset> points;
  Offset eggLocation;

  MyPainter(this.points, this.eggLocation);
  @override
  void paint(Canvas canvas, Size size) {
    for (var point in points) {
      int margin = SnackUtils.marginBetweenTwoSnackRect;
      final rect = Rect.fromLTRB(
          point.dx.toDouble() + margin / 2,
          point.dy.toDouble() + margin / 2,
          point.dx + SnackUtils.snackRectSize.toDouble() - margin,
          point.dy + SnackUtils.snackRectSize.toDouble() - margin);
      final paint = Paint()
        ..color = Color(int.parse(Settings.snackColor, radix: 16))
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }

    if (Settings.showLines) {
      for (double i = 0; i <= size.width; i += 20) {
        final paint = Paint()
          ..color = Colors.grey[500]
          ..style = PaintingStyle.fill;
        canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
      }
      for (double i = 0; i <= size.height; i += 20) {
        final paint = Paint()
          ..color = Colors.grey[500]
          ..style = PaintingStyle.fill;
        canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
      }
    }
    final paint = Paint()
      ..color = Color(int.parse(Settings.eggColor, radix: 16))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(eggLocation.dx + SnackUtils.eggSize + 1,
            eggLocation.dy + SnackUtils.eggSize + 1),
        SnackUtils.eggSize.toDouble(),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

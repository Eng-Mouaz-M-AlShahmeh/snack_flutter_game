/* Developed by Eng Mouaz M AlShahmeh */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color buttonColor;

  final Color textColor;

  final double width;

  final double height;
  GestureTapCallback onPressed;

  MyButton(this.text,
      {this.buttonColor, this.textColor, @required this.onPressed,this.width,this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:20.0,vertical: 10.0),
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: buttonColor ?? Colors.white,
            borderRadius: BorderRadius.circular(20)),
        child: Text(
          text,
          style: GoogleFonts.almarai(
              letterSpacing: 1.5,
              color: textColor ?? Colors.black,
              fontSize: 18),
        ),
      ),
    );
  }
}

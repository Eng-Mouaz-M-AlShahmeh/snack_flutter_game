/* Developed by Eng Mouaz M AlShahmeh */
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatelessWidget {
  final text;
  final widget;
  final EdgeInsets padding;
  SettingsTile({this.text, this.widget, this.padding});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: GoogleFonts.almarai(
                  fontSize: 20, letterSpacing: 2, color: Colors.grey[400]),
            ),
            widget
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_fonts/google_fonts.dart';


Color screenColor = Colors.black;
Color fontColor = Colors.white;
Color accentColor = Color(0xffff1a75);
Color secondaryColor = Color(0xff504F56);

class FontProperties extends StatelessWidget {
  final String textToBeUsed;
  final Color color;
  final double sizeFont;
  FontProperties({required this.textToBeUsed, required this.color, required this.sizeFont});

  @override
  Widget build(BuildContext context) {
    return Text(
      textToBeUsed,
      style: GoogleFonts.roboto(
          textStyle: TextStyle(color: color, fontSize: sizeFont)),
    );
  }
}

String parseToMinutesSeconds(int ms) {
  String data;
  Duration duration = Duration(milliseconds: ms);

  int minutes = duration.inMinutes;
  int seconds = (duration.inSeconds) - (minutes * 60);

  data = minutes.toString() + ":";
  if (seconds <= 9) 
    data += "0";

  data += seconds.toString();
  return data;
}
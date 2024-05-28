import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle titlePoppins([double? size = 28, Color? textColor = Colors.white]) {
  return GoogleFonts.poppins(
      fontSize: size, fontWeight: FontWeight.bold, color: textColor);
}

TextStyle tilePoppins([double? size = 16, Color? textColor = Colors.white]) {
  return GoogleFonts.poppins(
      fontSize: size, fontWeight: FontWeight.bold, color: textColor);
}

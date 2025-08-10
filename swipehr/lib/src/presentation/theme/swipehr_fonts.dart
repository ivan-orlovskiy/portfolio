import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';

class SwipeHrFonts {
  SwipeHrFonts._();

  static final text = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.text,
      fontWeight: FontWeight.w400,
      fontSize: 24,
    ),
  );

  static final secondaryBtn = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.secondary,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
  );

  static final listChip = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.text,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
  );

  static final listChipDone = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.text,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      decoration: TextDecoration.lineThrough,
    ),
  );

  static final listChipEnding = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.text,
      fontWeight: FontWeight.w300,
      fontSize: 16,
    ),
  );

  static final textSmall = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.text,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    ),
  );

  static final textStats = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: SwipeHrColors.text,
      fontWeight: FontWeight.w400,
      fontSize: 24,
    ),
  );
}

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';

class AppFonts {
  const AppFonts._internal();

  // LIGHT THEME
  static final pageTitleLight = GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.fontLight,
  );
  static final panelTitleLight = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.fontLight,
  );
  static final hintLight = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.weakLight,
  );
  static final settingsTitleLight = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.actionLight,
  );
  static final panelAttributeLight = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    color: AppColors.fontLight,
  );
  static final panelSmallLight = GoogleFonts.lato(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.fontLight,
  );
  static final loginHintLight = GoogleFonts.lato(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
    color: AppColors.fontLight,
  );
  static final actionLight = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.fontLight,
  );
}

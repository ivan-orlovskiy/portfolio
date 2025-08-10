import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';

class FlushbarFactory {
  const FlushbarFactory._internal();

  static Flushbar warningFlushBar({
    required String message,
  }) {
    return Flushbar(
      margin: const EdgeInsets.all(20),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(milliseconds: 3000),
      animationDuration: const Duration(milliseconds: 200),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(10),
      backgroundColor: AppColors.alertLight,
      messageText: Text(
        message,
        style: AppFonts.settingsTitleLight,
      ),
    );
  }

  static Flushbar successFlushBar({
    required String message,
  }) {
    return Flushbar(
      margin: const EdgeInsets.all(20),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: const Duration(milliseconds: 5000),
      animationDuration: const Duration(milliseconds: 200),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(10),
      backgroundColor: AppColors.successLight,
      messageText: Text(
        message,
        style: AppFonts.settingsTitleLight,
      ),
    );
  }
}

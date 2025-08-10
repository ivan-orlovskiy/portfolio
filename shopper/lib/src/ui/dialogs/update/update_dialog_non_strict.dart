import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:store_redirect/store_redirect.dart';

class UpdateDialogNonStrict extends StatelessWidget {
  const UpdateDialogNonStrict({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 4),
      child: Center(
        child: Container(
          width: 300,
          height: 450,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        Lang.newAppVersionIsAvailable,
                        style: AppFonts.pageTitleLight,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${Lang.getItIn} ${_getStoreName()}.',
                        style: AppFonts.panelTitleLight,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/gears_animation.json',
                      height: 300,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppButton(
                        title: '${Lang.goTo} ${_getStoreName()}',
                        onPressed: () => StoreRedirect.redirect(),
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        inverted: true,
                        title: Lang.later,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getStoreName() {
    if (Platform.isAndroid) {
      return 'Play Market';
    } else {
      return 'App Store';
    }
  }
}

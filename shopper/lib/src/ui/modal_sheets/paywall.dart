import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';

class Paywall extends StatelessWidget {
  const Paywall({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgLight,
        ),
        child: SafeArea(
          child: SizedBox(
            height: 430,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 320,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 100),
                            foregroundDecoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              backgroundBlendMode: BlendMode.saturation,
                            ),
                            child: Lottie.asset(
                              'assets/lottie/present_animation.json',
                              height: 200,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${Lang.paywallHeader}!',
                                    style: AppFonts.pageTitleLight,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    Lang.paywallText,
                                    style: AppFonts.panelTitleLight,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      AppButton(
                        title: Lang.okay,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

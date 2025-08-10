import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/modal_sheets/onboarding.dart';
import 'package:shopper/src/ui/modal_sheets/paywall.dart';
import 'package:shopper/src/ui/pages/auth_flow/sign_in_page.dart';
import 'package:shopper/src/ui/pages/auth_flow/sign_up_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: Onboarding(
          pageController: _pageController,
          onLastPageReached: () {
            showModalBottomSheet(
              isScrollControlled: true,
              showDragHandle: true,
              enableDrag: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              backgroundColor: AppColors.bgLight,
              barrierColor: AppColors.bgDialog.withOpacity(0.7),
              context: context,
              builder: (context) => const Paywall(),
            );
          },
          lastChild: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            Lang.welcome,
                            style: AppFonts.pageTitleLight,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 70),
                  child: ThemedIcon(
                    assetName: 'assets/app/logo.svg',
                  ),
                ),
              ),
              Positioned(
                top: 150,
                right: -150,
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
                  child: Transform.rotate(
                    angle: pi * 0.5,
                    child: Lottie.asset(
                      'assets/lottie/leaves_animation.json',
                      height: 300,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 200,
                left: -220,
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    backgroundBlendMode: BlendMode.saturation,
                  ),
                  child: Transform.rotate(
                    angle: pi * -0.9,
                    child: Lottie.asset(
                      'assets/lottie/leaves_animation.json',
                      height: 300,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${Lang.comeon}:',
                        style: AppFonts.panelTitleLight,
                      ),
                      const SizedBox(height: 10),
                      AppButton(
                        title: Lang.iHaveAcc,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      AppButton(
                        title: Lang.iDontHaveAcc,
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

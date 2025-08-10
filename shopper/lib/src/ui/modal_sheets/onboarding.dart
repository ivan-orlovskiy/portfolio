import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  final PageController pageController;
  final VoidCallback onLastPageReached;
  final Widget lastChild;

  const Onboarding({
    super.key,
    required this.pageController,
    required this.onLastPageReached,
    required this.lastChild,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final ValueNotifier<bool> _value = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isInitialPage = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          onPageChanged: (pageIndex) {
            _value.value = pageIndex != 4;
            _isInitialPage.value = pageIndex == 0;
            if (pageIndex == 4) widget.onLastPageReached();
          },
          controller: widget.pageController,
          children: [
            _buildPage1(context),
            _buildPage2(context),
            _buildPage3(context),
            _buildPage4(context),
            widget.lastChild,
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: ValueListenableBuilder(
              valueListenable: _value,
              builder: (context, value, child) => AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: value ? Offset.zero : const Offset(0, -1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: value ? 1 : 0,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () => widget.pageController.animateToPage(
                            4,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: Container(
                            height: 20,
                            width: 70,
                            margin: const EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                Lang.skip,
                                style: AppFonts.panelAttributeLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SmoothPageIndicator(
                          effect: const WormEffect(
                            activeDotColor: AppColors.accentLight,
                            dotColor: AppColors.bgDialog,
                            dotHeight: 4,
                            dotWidth: 30,
                            spacing: 10,
                          ),
                          controller: widget.pageController,
                          count: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ValueListenableBuilder(
              valueListenable: _value,
              builder: (context, value, child) => AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: value ? Offset.zero : const Offset(0, 1),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: value ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _isInitialPage,
                          builder: (context, initialPageValue, child) => AnimatedSlide(
                            duration: const Duration(milliseconds: 200),
                            offset: !initialPageValue ? Offset.zero : const Offset(0, 1),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: !initialPageValue ? 1 : 0,
                              child: GestureDetector(
                                onTap: () {
                                  if (!initialPageValue) {
                                    widget.pageController.previousPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      Lang.previous,
                                      style: AppFonts.panelTitleLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.accentLight,
                            ),
                            child: Center(
                              child: Text(
                                Lang.next,
                                style: AppFonts.panelTitleLight.copyWith(color: AppColors.bgLight),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage1(BuildContext context) {
    return Container(
      color: AppColors.bgLight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 400),
            child: Text(
              Lang.page1Title,
              style: AppFonts.pageTitleLight,
            ),
          ),
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.grey.shade800,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Lottie.asset(
              'assets/lottie/sharing_animation.json',
              height: 270,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Lang.page1Content,
                        style: AppFonts.panelTitleLight,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2(BuildContext context) {
    return Container(
      color: AppColors.bgLight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 400),
            child: Text(
              Lang.page2Title,
              style: AppFonts.pageTitleLight,
            ),
          ),
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.grey.shade800,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/blob_animation.json',
                  height: 300,
                ),
                Lottie.asset(
                  'assets/lottie/cards_animation.json',
                  height: 300,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Lang.page2Content,
                        style: AppFonts.panelTitleLight,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage3(BuildContext context) {
    return Container(
      color: AppColors.bgLight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 400),
            child: Text(
              Lang.page3Title,
              style: AppFonts.pageTitleLight,
            ),
          ),
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.grey.shade800,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Lottie.asset(
              'assets/lottie/voice_animation.json',
              height: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Lang.page3Content,
                        style: AppFonts.panelTitleLight,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage4(BuildContext context) {
    return Container(
      color: AppColors.bgLight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 400),
            child: Text(
              Lang.page4Title,
              style: AppFonts.pageTitleLight,
            ),
          ),
          Container(
            foregroundDecoration: BoxDecoration(
              color: Colors.grey.shade800,
              backgroundBlendMode: BlendMode.saturation,
            ),
            child: Lottie.asset(
              'assets/lottie/feather_animation.json',
              height: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Lang.page4Content,
                        style: AppFonts.panelTitleLight,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

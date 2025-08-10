import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Tutorial extends StatefulWidget {
  final List<Widget> children;

  const Tutorial({
    super.key,
    required this.children,
  });

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  final ValueNotifier<bool> _isInitialPage = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isLastPage = ValueNotifier<bool>(false);
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550,
      color: AppColors.bgLight,
      child: SafeArea(
        child: Stack(
          children: [
            PageView(
              onPageChanged: (pageIndex) {
                _isInitialPage.value = pageIndex == 0;
                _isLastPage.value = pageIndex == widget.children.length - 1;
              },
              controller: _pageController,
              children: widget.children
                  .map((e) => _TutorialWrapper(child: e))
                  .toList(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => _pageController.animateToPage(
                          widget.children.length - 1,
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
                          dotWidth: 20,
                          spacing: 5,
                        ),
                        controller: _pageController,
                        count: widget.children.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: _isInitialPage,
                        builder: (context, initialPageValue, child) =>
                            AnimatedSlide(
                          duration: const Duration(milliseconds: 200),
                          offset: !initialPageValue
                              ? Offset.zero
                              : const Offset(0, 1),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: !initialPageValue ? 1 : 0,
                            child: GestureDetector(
                              onTap: () {
                                if (!initialPageValue) {
                                  _pageController.previousPage(
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
                      ValueListenableBuilder(
                        valueListenable: _isLastPage,
                        builder: (context, value, child) => GestureDetector(
                          onTap: () {
                            if (value) {
                              Navigator.pop(context);
                              return;
                            }
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.accentLight,
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 100),
                                child: value
                                    ? Text(
                                        Lang.close,
                                        key: const ValueKey(0),
                                        style: AppFonts.panelTitleLight
                                            .copyWith(color: AppColors.bgLight),
                                      )
                                    : Text(
                                        Lang.next,
                                        key: const ValueKey(1),
                                        style: AppFonts.panelTitleLight
                                            .copyWith(color: AppColors.bgLight),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TutorialWrapper extends StatelessWidget {
  final Widget child;
  const _TutorialWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [child],
    );
  }
}

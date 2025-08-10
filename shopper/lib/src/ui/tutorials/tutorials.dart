import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:once/once.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/modal_sheets/tutorial.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

enum TutorialType {
  lists,
  listItems,
  audio,
  cards,
  participants,
}

class Tutorials {
  const Tutorials._internal();

  static void runTutorialOnce(BuildContext context, TutorialType type) =>
      switch (type) {
        TutorialType.lists => _runTutorialOnce(
            context, _getListsTutorial(context), 'listsTutorial'),
        TutorialType.listItems => _runTutorialOnce(
            context, _getListItemsTutorial(context), 'listItemsTutorial'),
        TutorialType.audio => _runTutorialOnce(
            context, _getAudioTutorial(context), 'audioTutorial'),
        TutorialType.cards => _runTutorialOnce(
            context, _getCardsTutorial(context), 'cardsTutorial'),
        TutorialType.participants => _runTutorialOnce(
            context, _getParticipantsTutorial(context), 'usersTutorial'),
      };

  static void runAllTutorials(BuildContext context) async {
    await _showTutorial(context, _getListsTutorial(context));
    if (!context.mounted) return;
    await _showTutorial(context, _getListItemsTutorial(context));
    if (!context.mounted) return;
    await _showTutorial(context, _getAudioTutorial(context));
    if (!context.mounted) return;
    await _showTutorial(context, _getParticipantsTutorial(context));
    if (!context.mounted) return;
    await _showTutorial(context, _getCardsTutorial(context));
  }

  static Widget _getListsTutorial(BuildContext context) => Tutorial(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addNewList,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child: ThemedIcon(assetName: 'assets/icons/plus.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addNewListDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.removeList,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someList,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColors.accentLight, BlendMode.srcIn),
                          child:
                              ThemedIcon(assetName: 'assets/icons/trash.svg'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/swipe_left_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.removeListDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.updateList,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someList,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/long_tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.updateListDesc,
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
        ],
      );

  static Widget _getListItemsTutorial(BuildContext context) => Tutorial(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addNewListItem,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child: ThemedIcon(assetName: 'assets/icons/plus.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addNewListItemDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addWithVoiceTab,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child:
                          ThemedIcon(assetName: 'assets/icons/microphone.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addWithVoiceTabDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.removeListItem,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someListItem,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColors.accentLight, BlendMode.srcIn),
                          child:
                              ThemedIcon(assetName: 'assets/icons/trash.svg'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/swipe_left_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.removeListItemDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.markUnmarkItem,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColors.accentLight, BlendMode.srcIn),
                          child:
                              ThemedIcon(assetName: 'assets/icons/check.svg'),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someListItem,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/swipe_right_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.markUnmarkItemDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.clearList,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child: ThemedIcon(assetName: 'assets/icons/trash.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.clearListDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addPeople,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.bgLight,
                      radius: 27.5,
                      child: ThemedIcon(
                          assetName: 'assets/icons/users.svg', height: 40),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addPeopleDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.andRemember,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 40),
                foregroundDecoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  backgroundBlendMode: BlendMode.saturation,
                ),
                child: Lottie.asset(
                  'assets/lottie/together_animation.json',
                  height: 220,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.andRememberDesc,
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
        ],
      );

  static Widget _getCardsTutorial(BuildContext context) => Tutorial(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addNewCard,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child: ThemedIcon(
                          assetName: 'assets/icons/creditcard_add.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addNewCardDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.scanCard,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.bgLight,
                      radius: 27.5,
                      child: ThemedIcon(
                          assetName: 'assets/icons/creditcard.svg', height: 40),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.scanCardDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.removeCard,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someCard,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColors.accentLight, BlendMode.srcIn),
                          child:
                              ThemedIcon(assetName: 'assets/icons/trash.svg'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/swipe_left_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.removeCardDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.updateCard,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someCard,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/long_tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.updateCardDesc,
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
        ],
      );

  static Widget _getParticipantsTutorial(BuildContext context) => Tutorial(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addNewUser,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child: ThemedIcon(assetName: 'assets/icons/plus.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addNewUserDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.removeUser,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someUser,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColors.accentLight, BlendMode.srcIn),
                          child:
                              ThemedIcon(assetName: 'assets/icons/trash.svg'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/swipe_left_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.removeUserDesc,
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
        ],
      );

  static Widget _getAudioTutorial(BuildContext context) => Tutorial(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.addItemsWithVoice,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 100),
                    child: CircleAvatar(
                      backgroundColor: AppColors.accentLight,
                      radius: 27.5,
                      child:
                          ThemedIcon(assetName: 'assets/icons/microphone.svg'),
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/tap_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.addItemsWithVoiceDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.voiceRules,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 40),
                foregroundDecoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  backgroundBlendMode: BlendMode.saturation,
                ),
                child: Lottie.asset(
                  'assets/lottie/voice_animation.json',
                  height: 190,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 250),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.voiceRulesDesc,
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
          Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 350),
                child: Text(
                  Lang.removeVoiceItem,
                  style: AppFonts.pageTitleLight,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: AppColors.panelLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                Lang.someListItem,
                                style: AppFonts.panelTitleLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              AppColors.accentLight, BlendMode.srcIn),
                          child:
                              ThemedIcon(assetName: 'assets/icons/trash.svg'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      backgroundBlendMode: BlendMode.saturation,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/swipe_left_animation.json',
                      height: 300,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Lang.removeVoiceItemDesc,
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
        ],
      );

  static void _runTutorialOnce(
      BuildContext context, Widget tutorial, String tutorialKey) {
    Once.runOnce(
      tutorialKey,
      callback: () => WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          Future.delayed(
            const Duration(milliseconds: 500),
            () => showModalBottomSheet(
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
              builder: (context) => tutorial,
            ),
          );
        },
      ),
    );
  }

  static Future<void> _showTutorial(
          BuildContext context, Widget tutorial) async =>
      await showModalBottomSheet(
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
        builder: (context) => tutorial,
      );
}

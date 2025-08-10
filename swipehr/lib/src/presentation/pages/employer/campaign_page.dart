import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/employer/selection_results_page.dart.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button_secondary.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';

class CampaignPage extends StatefulWidget {
  final List<Application> applications;

  const CampaignPage({
    Key? key,
    required this.applications,
  }) : super(key: key);

  @override
  State<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  final List<Application> _currentStack = [];
  final List<Application> _accepted = [];
  final List<Application> _declined = [];

  @override
  void initState() {
    super.initState();
    _currentStack.addAll(widget.applications);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              size: 20,
              Ionicons.chevron_back,
              color: SwipeHrColors.text,
            ),
          ),
        ),
      ),
      centerTitle: false,
      title: PageText(Lang.selection),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatsRow(),
              _buildCards(context),
              // _buildBtn(context),
              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Column(
            children: [
              SmallText(Lang.accepted),
              const SizedBox(height: 5),
              Text(
                _accepted.length.toString(),
                style: SwipeHrFonts.textStats.copyWith(
                  color: SwipeHrColors.accepted,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: Column(
            children: [
              SmallText(Lang.declined),
              const SizedBox(height: 5),
              Text(
                _declined.length.toString(),
                style: SwipeHrFonts.textStats.copyWith(
                  color: SwipeHrColors.declined,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: Column(
            children: [
              SmallText(Lang.total),
              const SizedBox(height: 5),
              Text(
                _currentStack.length.toString(),
                style: SwipeHrFonts.textStats,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50, top: 30),
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width * 0.9,
      child: CardSwiper(
        duration: const Duration(milliseconds: 100),
        threshold: 90,
        isLoop: false,
        numberOfCardsDisplayed: _currentStack.length > 1 ? 2 : 1,
        backCardOffset: const Offset(0, 35),
        allowedSwipeDirection: AllowedSwipeDirection.symmetric(horizontal: true),
        scale: 0.87,
        onEnd: () async {
          await showDialog(
            context: context,
            builder: (ctx) {
              return Dialog(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: SwipeHrColors.pageBackground,
                  ),
                  width: 300,
                  height: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20),
                      PageText('Продолжить?'),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_accepted.length > 1)
                            ActionButton(
                              text: 'Продолжить отбор',
                              width: MediaQuery.of(context).size.width / 2,
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CampaignPage(
                                      applications: _accepted,
                                    ),
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 20),
                          ActionButtonSecondary(
                            color: SwipeHrColors.trigger,
                            text: 'Закончить отбор',
                            width: MediaQuery.of(context).size.width / 2,
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SelectionResultsPage(
                                    applications: _accepted,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        },
        onSwipe: (previousIndex, currentIndex, direction) {
          setState(() {
            if (direction == CardSwiperDirection.left) {
              _declined.add(_currentStack[previousIndex]);
            } else {
              _accepted.add(_currentStack[previousIndex]);
            }
          });
          return true;
        },
        cardsCount: _currentStack.length,
        cardBuilder: (context, index, horizontalOffsetPercentage, verticalOffsetPercentage) {
          final application = _currentStack[index];
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 7,
                  color: Colors.black.withOpacity(0.07),
                  offset: const Offset(0, 3),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            width: 300,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: application.tags.entries.length,
                itemBuilder: (context, index2) {
                  final data = application.tags.entries.elementAt(index2);
                  return Container(
                    padding: const EdgeInsets.all(7),
                    child: _buildInfo(data.key, data.value),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallText(key),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          constraints: const BoxConstraints(minHeight: 1.1 * kBottomNavigationBarHeight),
          decoration: BoxDecoration(
            color: SwipeHrColors.completedBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  value,
                  style: SwipeHrFonts.listChip,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBtn(BuildContext context) {
    return ActionButton(
      text: 'Закончить отбор',
      width: MediaQuery.of(context).size.width - 32,
      onPressed: () {},
    );
  }
}

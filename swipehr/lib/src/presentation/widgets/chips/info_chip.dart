import 'package:flutter/material.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';

class InfoChip extends StatelessWidget {
  final String title;
  final String info;

  const InfoChip({
    required this.title,
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmallText(title),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            constraints: const BoxConstraints(minHeight: 1.1 * kBottomNavigationBarHeight),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    info,
                    style: SwipeHrFonts.listChip,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

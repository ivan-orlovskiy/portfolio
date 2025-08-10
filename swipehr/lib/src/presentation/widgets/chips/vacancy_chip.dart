import 'package:flutter/material.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';

class VacancyChip extends StatelessWidget {
  final Vacancy vacancy;
  final VoidCallback onPressed;

  const VacancyChip({
    required this.vacancy,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 1.1 * kBottomNavigationBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              vacancy.name,
              style: SwipeHrFonts.listChip,
            ),
          ],
        ),
      ),
    );
  }
}

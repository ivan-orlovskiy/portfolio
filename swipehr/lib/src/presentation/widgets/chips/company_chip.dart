import 'package:flutter/material.dart';
import 'package:swipehr/src/domain/entities/employer.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';

class CompanyChip extends StatelessWidget {
  final Employer company;
  final VoidCallback onPressed;

  const CompanyChip({
    required this.company,
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
              company.companyName,
              style: SwipeHrFonts.listChip,
            ),
          ],
        ),
      ),
    );
  }
}

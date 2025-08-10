import 'package:flutter/material.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';

class ApplicationChip extends StatelessWidget {
  final Application application;
  final VoidCallback onPressed;

  const ApplicationChip({
    required this.application,
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
              application.id.hashCode.toString(),
              style: SwipeHrFonts.listChip,
            ),
          ],
        ),
      ),
    );
  }
}

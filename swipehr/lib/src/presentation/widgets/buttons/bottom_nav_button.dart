import 'package:flutter/material.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';

class BottomNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isCurrent;

  const BottomNavButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.isCurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 25,
        child: Icon(
          icon,
          size: 25,
          color: isCurrent ? SwipeHrColors.secondary : SwipeHrColors.notActive,
        ),
      ),
    );
  }
}

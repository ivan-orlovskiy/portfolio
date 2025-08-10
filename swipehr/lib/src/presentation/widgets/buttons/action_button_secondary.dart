import 'package:flutter/material.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';

class ActionButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color? color;

  const ActionButtonSecondary({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.color,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color ?? SwipeHrColors.secondary),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        width: width ?? 300,
        height: height ?? 50,
        child: Center(
          child: Text(
            text,
            style: SwipeHrFonts.listChip
                .copyWith(color: color ?? SwipeHrColors.secondary),
          ),
        ),
      ),
    );
  }
}

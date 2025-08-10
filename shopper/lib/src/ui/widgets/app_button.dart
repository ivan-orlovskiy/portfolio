import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool inverted;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: inverted ? AppColors.bgLight : AppColors.accentLight,
          border: inverted
              ? Border.all(
                  color: AppColors.accentLight,
                  width: 1.5,
                )
              : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: AppFonts.settingsTitleLight.copyWith(
                    color: inverted ? AppColors.accentLight : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

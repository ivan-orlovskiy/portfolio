import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  const ConfirmationDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 4),
      child: Center(
        child: Container(
          width: 300,
          height: 220,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  message,
                  style: AppFonts.panelTitleLight,
                ),
                Column(
                  children: [
                    AppButton(
                      title: Lang.yes,
                      onPressed: () => Navigator.pop(context, true),
                    ),
                    const SizedBox(height: 10),
                    AppButton(
                      inverted: true,
                      title: Lang.no,
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

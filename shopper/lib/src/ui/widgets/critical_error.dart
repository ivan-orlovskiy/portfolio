import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class CriticalError extends StatelessWidget {
  final String errorMessage;

  const CriticalError({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ThemedIcon(assetName: 'assets/icons/error.svg'),
          const SizedBox(height: 10),
          Text(
            errorMessage,
            style: AppFonts.panelTitleLight,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

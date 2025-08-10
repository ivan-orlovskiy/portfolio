import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isEnd;
  final FocusNode? focusNode;
  final TextInputType? textInputType;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.isEnd = false,
    this.focusNode,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: textInputType,
      focusNode: focusNode,
      textInputAction: isEnd ? TextInputAction.done : TextInputAction.next,
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        hintText: hint,
        hintStyle: AppFonts.hintLight,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: AppColors.accentLight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: AppColors.accentLight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

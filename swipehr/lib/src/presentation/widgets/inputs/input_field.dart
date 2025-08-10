import 'package:flutter/material.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';

class InputField extends StatelessWidget {
  final double? width;
  final String hintText;
  final String? title;
  final TextEditingController controller;
  final String? Function(String? value)? validator;

  const InputField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.title,
    this.width,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) SmallText(title!),
          if (title != null) const SizedBox(height: 7),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: controller,
            validator: validator,
            cursorColor: SwipeHrColors.secondary,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintStyle:
                  SwipeHrFonts.listChipEnding.copyWith(color: SwipeHrColors.text.withOpacity(0.5)),
              hintText: hintText,
              border: InputBorder.none,
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}

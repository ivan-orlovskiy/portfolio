import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool isEnd;
  final FocusNode? focusNode;

  const PasswordTextField({
    Key? key,
    required this.controller,
    required this.hint,
    this.isEnd = false,
    this.focusNode,
  }) : super(key: key);

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _passwordIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: !_passwordIsVisible,
      focusNode: widget.focusNode,
      textInputAction:
          widget.isEnd ? TextInputAction.done : TextInputAction.next,
      controller: widget.controller,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () => setState(() {
            _passwordIsVisible = !_passwordIsVisible;
          }),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ThemedIcon(
              assetName: _passwordIsVisible
                  ? 'assets/icons/eyeopen.svg'
                  : 'assets/icons/eyeclosed.svg',
            ),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        hintText: widget.hint,
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

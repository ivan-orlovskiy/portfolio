import 'package:flutter/material.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';

class AppCheckbox extends StatefulWidget {
  final Function(bool state) onChanged;
  final Widget? child;

  const AppCheckbox({
    super.key,
    required this.onChanged,
    this.child,
  });

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
            });
            widget.onChanged(_isChecked);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: AppColors.accentLight),
                color: AppColors.bgLight,
              ),
              child: Container(
                width: 18,
                height: 18,
                margin: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _isChecked ? AppColors.accentLight : AppColors.bgLight,
                ),
              ),
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}

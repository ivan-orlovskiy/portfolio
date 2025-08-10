import 'package:flutter/material.dart';
import 'package:shopper/src/common/extensions/icon_extension.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class IconSelector extends StatefulWidget {
  final String initialIconName;
  const IconSelector({
    super.key,
    this.initialIconName = '',
  });

  @override
  State<IconSelector> createState() => IconSelectorState();
}

class IconSelectorState extends State<IconSelector> {
  static const _icons = [
    'air',
    'attachment',
    'basket',
    'basketball',
    'bell',
    'cart',
    'heart',
    'snow',
  ];

  String get icon => _icons[_currentIcon];

  int _currentIcon = _icons.length ~/ 2;

  @override
  void initState() {
    if (!_icons.contains(widget.initialIconName)) return;
    _currentIcon = _icons.indexOf(widget.initialIconName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (value) => _currentIcon = value % _icons.length,
            controller: PageController(viewportFraction: 0.2, initialPage: _currentIcon),
            itemCount: _icons.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(12),
              child: ThemedIcon(
                height: 15,
                width: 15,
                assetName: _icons[index % _icons.length].iconPath,
              ),
            ),
          ),
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.5, 1.0],
                  colors: [
                    AppColors.bgLight,
                    Colors.white.withOpacity(0),
                    AppColors.bgLight,
                  ],
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Align(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 1.5,
                    color: AppColors.accentLight,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

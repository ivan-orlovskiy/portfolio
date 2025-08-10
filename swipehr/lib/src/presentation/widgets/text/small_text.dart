import 'package:flutter/material.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';

class SmallText extends StatelessWidget {
  final String text;
  const SmallText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: SwipeHrFonts.textSmall,
      textAlign: TextAlign.center,
    );
  }
}

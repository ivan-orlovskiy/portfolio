import 'package:flutter/material.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';

class PageText extends StatelessWidget {
  final String text;
  const PageText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: SwipeHrFonts.text,
      textAlign: TextAlign.center,
    );
  }
}

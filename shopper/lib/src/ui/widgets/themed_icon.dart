import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ThemedIcon extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;

  const ThemedIcon({
    Key? key,
    required this.assetName,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
    );
  }
}

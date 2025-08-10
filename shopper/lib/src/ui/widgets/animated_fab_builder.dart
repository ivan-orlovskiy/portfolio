import 'package:flutter/widgets.dart';

class AnimatedFabBuilder extends StatelessWidget {
  final ValueNotifier<bool> valueNotifier;
  final Widget child;

  const AnimatedFabBuilder({
    super.key,
    required this.valueNotifier,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, _) => AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: value ? Offset.zero : const Offset(0, 1),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: value ? 1 : 0,
          child: child,
        ),
      ),
    );
  }
}

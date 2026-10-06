import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RestaurantTierEntryAnimation extends StatelessWidget {
  const RestaurantTierEntryAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.slideBegin = 0.04,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideBegin;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }
    return child
        .animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOut)
        .slideY(
          begin: slideBegin,
          end: 0,
          duration: duration,
          curve: Curves.easeOut,
        );
  }
}

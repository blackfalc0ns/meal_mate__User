import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubscriptionBillingEntranceRegistry extends InheritedWidget {
  SubscriptionBillingEntranceRegistry({
    required super.child,
    super.key,
  }) : playedKeys = <String>{};

  final Set<String> playedKeys;

  static SubscriptionBillingEntranceRegistry? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        SubscriptionBillingEntranceRegistry>();
  }

  @override
  bool updateShouldNotify(SubscriptionBillingEntranceRegistry oldWidget) =>
      false;
}

class SubscriptionBillingEntrance extends StatelessWidget {
  const SubscriptionBillingEntrance({
    required this.sectionKey,
    required this.child,
    this.delay = Duration.zero,
    super.key,
  });

  final String sectionKey;
  final Widget child;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return child;
    }

    final registry = SubscriptionBillingEntranceRegistry.of(context);
    final alreadyPlayed = registry?.playedKeys.contains(sectionKey) ?? false;

    if (alreadyPlayed) {
      return child;
    }

    registry?.playedKeys.add(sectionKey);

    return child
        .animate()
        .fadeIn(
          delay: delay,
          duration: 280.ms,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.025,
          end: 0,
          delay: delay,
          duration: 280.ms,
          curve: Curves.easeOut,
        );
  }
}

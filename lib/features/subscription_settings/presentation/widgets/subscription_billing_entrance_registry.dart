import 'package:flutter/material.dart';

class SubscriptionBillingEntranceRegistry extends InheritedWidget {
  const SubscriptionBillingEntranceRegistry({
    required this.playedKeys,
    required super.child,
    super.key,
  });

  final Set<String> playedKeys;

  static SubscriptionBillingEntranceRegistry? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
          SubscriptionBillingEntranceRegistry
        >();
  }

  @override
  bool updateShouldNotify(SubscriptionBillingEntranceRegistry oldWidget) =>
      oldWidget.playedKeys != playedKeys;
}

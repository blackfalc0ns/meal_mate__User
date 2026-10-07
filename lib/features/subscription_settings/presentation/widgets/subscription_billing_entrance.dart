import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/subscription_billing_entrance_registry.dart';

class SubscriptionBillingEntrance extends StatefulWidget {
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
  State<SubscriptionBillingEntrance> createState() =>
      _SubscriptionBillingEntranceState();
}

class _SubscriptionBillingEntranceState
    extends State<SubscriptionBillingEntrance> {
  bool? _shouldAnimate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shouldAnimate == null) {
      if (MediaQuery.disableAnimationsOf(context)) {
        _shouldAnimate = false;
      } else {
        final registry = SubscriptionBillingEntranceRegistry.of(context);
        final alreadyPlayed =
            registry?.playedKeys.contains(widget.sectionKey) ?? false;
        if (alreadyPlayed) {
          _shouldAnimate = false;
        } else {
          registry?.playedKeys.add(widget.sectionKey);
          _shouldAnimate = true;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldAnimate != true) {
      return widget.child;
    }

    return widget.child
        .animate()
        .fadeIn(delay: widget.delay, duration: 280.ms, curve: Curves.easeOut)
        .slideY(
          begin: 0.025,
          end: 0,
          delay: widget.delay,
          duration: 280.ms,
          curve: Curves.easeOut,
        );
  }
}

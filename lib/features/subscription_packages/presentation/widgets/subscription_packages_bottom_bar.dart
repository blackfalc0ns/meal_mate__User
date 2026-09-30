import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';

class SubscriptionPackagesBottomBar extends StatelessWidget {
  const SubscriptionPackagesBottomBar({
    super.key,
    required this.selectedPackageNotifier,
    required this.hasBundles,
    required this.isLoading,
    this.onContinue,
  });

  final ValueListenable<int?> selectedPackageNotifier;
  final bool hasBundles;
  final bool isLoading;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return PositionedDirectional(
      start: Spacing.subscriptionProgramsHorizontalPadding,
      end: Spacing.subscriptionProgramsHorizontalPadding,
      bottom: Spacing.lg,
      child: SafeArea(
        top: false,
        child: ValueListenableBuilder<int?>(
          valueListenable: selectedPackageNotifier,
          builder: (context, selectedIndex, _) {
            final isEnabled = selectedIndex != null && hasBundles;

            return AppSubscriptionButton.next(
              text: locale.subscription_choose_plan_button,
              onPressed: isEnabled ? onContinue : null,
              isLoading: isLoading,
            );
          },
        ),
      )
          .animate()
          .fadeIn(duration: 350.ms, curve: Curves.easeOut)
          .slideY(
            begin: 0.15,
            end: 0,
            duration: 350.ms,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

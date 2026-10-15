import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_next_step_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_payment_confirmed_banner.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_action_buttons.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_hero_header.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_summary_card.dart';
import 'package:meal_meat_user/features/payment/presentation/widgets/success/subscription_success_top_bar.dart';

/// Screen displayed after a successful subscription payment / activation.
/// Conforms to Figma M-06.08 - Subscription / Success (node 3356:7428).
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key, this.args});

  final PaymentSuccessArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final resolvedArgs =
        args ??
        PaymentSuccessArgs(
          subscriptionId: '',
          packageName: locale.subscription_healthy_balanced,
          durationDays: 30,
          durationLabel: '30 ${locale.health_goals_days}',
          restaurantTier: locale.subscription_summary_restaurant_tier_value,
          paymentDate: DateTime.now().toIso8601String().split('T').first,
          startDate: DateTime.now()
              .add(const Duration(days: 1))
              .toIso8601String()
              .split('T')
              .first,
          endDate: DateTime.now()
              .add(const Duration(days: 31))
              .toIso8601String()
              .split('T')
              .first,
        );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        unawaited(
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
        );
      },
      child: Scaffold(
        backgroundColor: color.surface,
        body: SafeArea(
          child: Column(
            children: [
              SubscriptionSuccessTopBar(
                onNotificationPressed: () {
                  unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.notifications),
                  );
                },
                onClosePressed: () {
                  unawaited(
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                  );
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    key: const ValueKey('subscription-success-content'),
                    children: [
                      const SubscriptionSuccessHeroHeader(),
                      SubscriptionSuccessSummaryCard(args: resolvedArgs),
                      const SizedBox(height: Spacing.xs),
                      const SubscriptionPaymentConfirmedBanner(),
                      const SizedBox(height: Spacing.xs),
                      const SubscriptionNextStepBanner(),
                      const SizedBox(height: Spacing.sm),
                    ],
                  ).animate().fadeIn(duration: 250.ms),
                ),
              ),
              SubscriptionSuccessActionButtons(
                onStartMeals: () {
                  unawaited(
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.home,
                      (route) => false,
                      arguments: AppShellScreen.mealsTabIndex,
                    ),
                  );
                },
                onViewSubscription: () {
                  unawaited(
                    Navigator.of(context).pushNamed(AppRoutes.profileBilling),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

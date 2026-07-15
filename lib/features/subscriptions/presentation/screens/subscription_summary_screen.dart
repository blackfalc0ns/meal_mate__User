import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_subscription_button.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_hero_section.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_summary_details_card.dart';

class SubscriptionSummaryScreen extends StatelessWidget {
  const SubscriptionSummaryScreen({super.key, required this.plan});

  final MonthlyPlanDetailsEntity plan;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Semantics(
          label: locale.subscription_summary_title,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: Spacing.monthlyPlanDesignWidth,
                height: Spacing.subscriptionSummaryDesignHeight,
                child: Stack(
                  children: [
                    Positioned.fill(child: ColoredBox(color: color.surface)),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: MonthlyPlanHeroSection(
                        plan: plan,
                        imageAsset: Assets.monthlyPlanHero,
                        onBack: () => Navigator.maybePop(context),
                      ),
                    ),
                    Positioned(
                      left: Spacing.subscriptionSummaryDetailsLeft,
                      top: Spacing.subscriptionSummaryDetailsTop,
                      child: SubscriptionSummaryDetailsCard(plan: plan),
                    ),
                    Positioned(
                      left: Spacing.subscriptionSummarySubscribeLeft,
                      top: Spacing.subscriptionSummarySubscribeTop,
                      width: Spacing.subscriptionSummarySubscribeWidth,
                      child: AppSubscriptionButton(
                        price: plan.price,
                        currency: plan.currency,
                        onPressed: () => context.pushNamed(AppRoutes.payment),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

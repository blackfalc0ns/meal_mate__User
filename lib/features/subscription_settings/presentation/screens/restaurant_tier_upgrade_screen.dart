import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/restaurant_tier_upgrade_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_details_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_payment_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_quick_comparison_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_upgrade_actions.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_upgrade_hero_card.dart';

class RestaurantTierUpgradeScreen extends StatelessWidget {
  const RestaurantTierUpgradeScreen({super.key});

  static const _dataSource = RestaurantTierUpgradeFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final data = _dataSource.getUpgrade();

    return Semantics(
      label: locale.nav_subscription,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(elevation: Spacing.zero, title: data.title),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.restaurantTierHorizontalPadding,
                ),
                sliver: SliverList.list(
                  children: [
                    const SizedBox(height: Spacing.lg),
                    RestaurantTierUpgradeHeroCard(data: data),
                    const SizedBox(height: Spacing.lg),
                    RestaurantTierQuickComparisonSection(data: data),
                    const SizedBox(height: Spacing.lg),
                    RestaurantTierDetailsSection(data: data),
                    const SizedBox(height: Spacing.lg),
                    RestaurantTierPaymentSection(data: data),
                    const SizedBox(height: Spacing.lg),
                    RestaurantTierUpgradeActions(
                      confirmLabel: data.confirmLabel,
                      backLabel: data.backLabel,
                      onConfirm: () {},
                      onBack: () => Navigator.maybePop(context),
                    ),
                    SizedBox(
                      height: MediaQuery.paddingOf(context).bottom + Spacing.xl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/restaurant_tier_upgrade_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_current_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_option_card.dart';

class RestaurantTierUpgradeScreen extends StatefulWidget {
  const RestaurantTierUpgradeScreen({super.key});

  @override
  State<RestaurantTierUpgradeScreen> createState() =>
      _RestaurantTierUpgradeScreenState();
}

class _RestaurantTierUpgradeScreenState
    extends State<RestaurantTierUpgradeScreen> {
  static const _dataSource = RestaurantTierUpgradeFakeDataSource();

  int _selectedTierIndex = 1;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final data = _dataSource.getUpgrade();
    final currentTier = data.tiers[0];
    final plusTier = data.tiers[1];
    final maxTier = data.tiers[2];

    return Semantics(
      label: locale.nav_subscription,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(title: data.title),

        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.restaurantTierHorizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Spacing.md),
                RestaurantTierCurrentSubscriptionCard(data: data),
                const SizedBox(height: Spacing.xl),
                Text(
                  data.chooseTitle,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  data.chooseSubtitle,
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                RestaurantTierOptionCard(
                  title: currentTier.name,
                  badgeAsset: currentTier.badgeAsset,
                  description: currentTier.description,
                  restaurantCount: currentTier.restaurantCount,
                  titleColor: color.primary,
                  descriptionColor: color.onSurfaceVariant,
                  countColor: color.onSurfaceVariant,
                  countBorderColor: color.outline,
                  background: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(
                      Spacing.restaurantTierCardRadius,
                    ),
                    border: Border.all(color: color.outline),
                    boxShadow: [
                      BoxShadow(
                        color: color.shadow.withValues(alpha: 0.08),
                        blurRadius: Spacing.md,
                        offset: const Offset(Spacing.zero, Spacing.xs),
                      ),
                    ],
                  ),
                  actionPanelColor: color.surfaceContainerHighest,
                  actionPanelBorderColor: color.outline,
                  actionButtonColor: color.surfaceContainerHighest,
                  actionButtonTextColor: color.onSurfaceVariant,
                  priceColor: color.onSurfaceVariant,
                  actionText: currentTier.buttonLabel,
                  price: data.price,
                  pricePeriod: data.pricePeriod,
                  isCurrent:
                      currentTier.type == RestaurantTierOptionType.current,
                  isSelected: false,
                  onTap: null,
                ),
                const SizedBox(height: Spacing.restaurantTierCardsGap),
                RestaurantTierOptionCard(
                  title: plusTier.name,
                  badgeAsset: plusTier.badgeAsset,
                  description: plusTier.description,
                  restaurantCount: plusTier.restaurantCount,
                  titleColor: color.onPrimary,
                  descriptionColor: color.onPrimary,
                  countColor: color.onSurface,
                  countBorderColor: color.onPrimary,
                  background: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.primary.withValues(alpha: 0.82),
                        color.onTertiaryContainer,
                      ],
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                    ),
                    borderRadius: BorderRadius.circular(
                      Spacing.restaurantTierCardRadius,
                    ),
                  ),
                  actionPanelColor: color.primary,
                  actionPanelBorderColor: color.primaryContainer,
                  actionButtonColor: color.onPrimary,
                  actionButtonTextColor: color.primary,
                  priceColor: color.onPrimary,
                  actionText: plusTier.buttonLabel,
                  price: data.price,
                  pricePeriod: data.pricePeriod,
                  isCurrent: plusTier.type == RestaurantTierOptionType.current,
                  isSelected: _selectedTierIndex == 1,
                  onTap: () => setState(() => _selectedTierIndex = 1),
                ),
                const SizedBox(height: Spacing.restaurantTierCardsGap),
                RestaurantTierOptionCard(
                  title: maxTier.name,
                  badgeAsset: maxTier.badgeAsset,
                  description: maxTier.description,
                  restaurantCount: maxTier.restaurantCount,
                  titleColor: color.secondary,
                  descriptionColor: color.onPrimary,
                  countColor: color.onSurface,
                  countBorderColor: color.onPrimary,
                  background: BoxDecoration(
                    color: color.inverseSurface,
                    borderRadius: BorderRadius.circular(
                      Spacing.restaurantTierCardRadius,
                    ),
                  ),
                  actionPanelColor: color.onSurface,
                  actionPanelBorderColor: color.secondary,
                  actionButtonColor: color.secondary,
                  actionButtonTextColor: color.onSecondary,
                  priceColor: color.secondary,
                  actionText: maxTier.buttonLabel,
                  price: data.price,
                  pricePeriod: data.pricePeriod,
                  isCurrent: maxTier.type == RestaurantTierOptionType.current,
                  isSelected: _selectedTierIndex == 2,
                  onTap: () => setState(() => _selectedTierIndex = 2),
                ),
                const SizedBox(height: Spacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

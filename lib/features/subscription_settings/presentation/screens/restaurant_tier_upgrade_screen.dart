import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/restaurant_tier_upgrade_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_continue_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_current_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_option_card.dart';

class RestaurantTierUpgradeScreen extends StatefulWidget {
  const RestaurantTierUpgradeScreen({super.key});

  static const _dataSource = RestaurantTierUpgradeFakeDataSource();

  @override
  State<RestaurantTierUpgradeScreen> createState() =>
      _RestaurantTierUpgradeScreenState();
}

class _RestaurantTierUpgradeScreenState
    extends State<RestaurantTierUpgradeScreen> {
  RestaurantTierOptionType _selectedType = RestaurantTierOptionType.plus;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final data = RestaurantTierUpgradeScreen._dataSource.getUpgrade();

    return Semantics(
      label: locale.nav_subscription,
      child: Scaffold(
        appBar: CustomAppBar(elevation: Spacing.zero, title: data.title),
        bottomNavigationBar: RestaurantTierContinueButton(
          text: _continueLabel(data),
          onPressed: () => context.pushNamed(
            AppRoutes.restaurantTierUpgradeConfirmation,
          ),
        ),
        body: SafeArea(
          top: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                sliver: SliverList.list(
                  children: _selectionChildren(context, data),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _selectionChildren(
    BuildContext context,
    RestaurantTierUpgradeEntity data,
  ) {
    final color = context.colorScheme;

    return [
      const SizedBox(height: Spacing.lg),
      RestaurantTierCurrentSubscriptionCard(data: data),
      const SizedBox(height: Spacing.xxl),
      Text(
        data.chooseTitle,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size16,
          color: color.onSurface,
        ),
      ),
      const SizedBox(height: Spacing.base),
      Text(
        data.chooseSubtitle,
        style: getMediumStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size12,
          color: color.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: Spacing.xxl),
      for (final tier in data.tiers) ...[
        RestaurantTierOptionCard(
          title: tier.name,
          badgeAsset: tier.badgeAsset,
          description: tier.description,
          restaurantCount: tier.restaurantCount,
          titleColor: _titleColor(context, tier.type),
          descriptionColor: _descriptionColor(context, tier.type),
          countColor: _countColor(context, tier.type),
          countBorderColor: _countBorderColor(context, tier.type),
          background: _cardBackground(context, tier.type),
          actionPanelColor: _actionPanelColor(context, tier.type),
          actionPanelBorderColor: _actionPanelBorderColor(context, tier.type),
          actionButtonColor: _actionButtonColor(context, tier.type),
          actionButtonTextColor: _actionButtonTextColor(context, tier.type),
          priceColor: _priceColor(context, tier.type),
          actionText: tier.buttonLabel,
          price: data.price,
          pricePeriod: data.pricePeriod,
          isCurrent: tier.type == RestaurantTierOptionType.current,
          isSelected: tier.type == _selectedType,
          onTap: tier.type == RestaurantTierOptionType.current
              ? null
              : () => _selectAndNavigate(tier.type),
        ),
        const SizedBox(height: Spacing.restaurantTierCardsGap),
      ],
      SizedBox(height: MediaQuery.paddingOf(context).bottom + Spacing.xxxl),
    ];
  }

  String _continueLabel(RestaurantTierUpgradeEntity data) {
    return _selectedType == RestaurantTierOptionType.max
        ? data.continueMaxLabel
        : data.continuePlusLabel;
  }

  void _selectAndNavigate(RestaurantTierOptionType type) {
    setState(() {
      _selectedType = type;
    });
    context.pushNamed(AppRoutes.restaurantTierUpgradeConfirmation);
  }

  BoxDecoration _cardBackground(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return BoxDecoration(
      color: type == RestaurantTierOptionType.current
          ? color.surface
          : type == RestaurantTierOptionType.plus
          ? color.primary
          : color.inverseSurface,
      gradient: type == RestaurantTierOptionType.plus
          ? LinearGradient(
              begin: AlignmentDirectional.topEnd,
              end: AlignmentDirectional.bottomStart,
              colors: [color.primary, color.primaryFixedDim],
            )
          : null,
      border: Border.all(
        color: type == RestaurantTierOptionType.max
            ? color.secondary
            : color.outlineVariant,
      ),
      borderRadius: BorderRadius.circular(Spacing.restaurantTierCardRadius),
      boxShadow: [
        BoxShadow(
          color: color.shadow.withValues(alpha: 0.08),
          blurRadius: Spacing.md,
          offset: const Offset(Spacing.zero, Spacing.xs),
        ),
      ],
    );
  }

  Color _titleColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : type == RestaurantTierOptionType.current
        ? color.primary
        : color.onPrimary;
  }

  Color _descriptionColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.current
        ? color.onSurfaceVariant
        : color.onPrimary;
  }

  Color _countColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.primary;
  }

  Color _countBorderColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.primary;
  }

  Color _actionPanelColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.inverseSurface
        : color.primaryFixedDim;
  }

  Color _actionPanelBorderColor(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.primaryContainer;
  }

  Color _actionButtonColor(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.surface;
  }

  Color _actionButtonTextColor(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.onSecondary
        : color.primary;
  }

  Color _priceColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.onPrimary;
  }
}

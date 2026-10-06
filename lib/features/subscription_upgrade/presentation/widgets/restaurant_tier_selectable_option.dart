import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/models/restaurant_tier_option_view_data.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_option_card.dart';

class RestaurantTierSelectableOption extends StatelessWidget {
  const RestaurantTierSelectableOption({
    super.key,
    required this.viewData,
    required this.onSelect,
  });

  final RestaurantTierOptionViewData viewData;
  final ValueChanged<SubscriptionUpgradeOptionEntity> onSelect;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final option = viewData.option;
    final optionType = viewData.optionType;

    final title = option.tierNameAr.isNotEmpty
        ? option.tierNameAr
        : (option.tierNameEn.isNotEmpty
            ? option.tierNameEn
            : option.targetTier);

    final description = option.isCurrent
        ? locale.restaurant_tier_current_tier_caption
        : locale.restaurant_tier_includes_all_format(title);

    final actionText = option.isCurrent
        ? locale.restaurant_tier_your_current_tier
        : locale.restaurant_tier_upgrade_to_tier(title);

    final currency = option.currencyCode.isNotEmpty
        ? option.currencyCode
        : 'KWD';
    final currencyText = currency == 'KWD' ? 'د.ك' : currency;

    final priceText = option.isCurrent
        ? '0.00 $currencyText'
        : '${option.priceDifference.toStringAsFixed(2)} $currencyText';

    return BlocSelector<
      RestaurantTierUpgradeViewModel,
      RestaurantTierUpgradeState,
      bool
    >(
      selector: (state) =>
          state.selectedOption?.targetTier == viewData.targetTier,
      builder: (context, isSelected) {
        return RestaurantTierOptionCard(
          title: title,
          badgeAsset: viewData.badgeAsset,
          imageUrl: viewData.imageUrl,
          description: description,
          restaurantCount: '+${option.accessibleRestaurantCount}',
          titleColor: _titleColor(context, optionType),
          descriptionColor: _descriptionColor(context, optionType),
          countColor: _countColor(context, optionType),
          countBorderColor: _countBorderColor(context, optionType),
          background: _cardBackground(context, optionType),
          actionPanelColor: _actionPanelColor(context, optionType),
          actionPanelBorderColor: _actionPanelBorderColor(context, optionType),
          actionButtonColor: _actionButtonColor(context, optionType),
          actionButtonTextColor: _actionButtonTextColor(context, optionType),
          priceColor: _priceColor(context, optionType),
          actionText: actionText,
          price: priceText,
          pricePeriod: locale.restaurant_tier_price_period,
          isCurrent: option.isCurrent,
          isSelected: isSelected,
          onTap: !option.selectable ? null : () => onSelect(option),
        );
      },
    );
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

  Color _actionButtonColor(BuildContext context, RestaurantTierOptionType type) {
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

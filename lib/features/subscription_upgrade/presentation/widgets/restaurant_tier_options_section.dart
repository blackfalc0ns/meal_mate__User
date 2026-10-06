import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/models/restaurant_tier_option_view_data.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_selectable_option.dart';

class RestaurantTierOptionsSection extends StatelessWidget {
  const RestaurantTierOptionsSection({
    super.key,
    required this.onOptionSelected,
  });

  final ValueChanged<SubscriptionUpgradeOptionEntity> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocSelector<
      RestaurantTierUpgradeViewModel,
      RestaurantTierUpgradeState,
      List<RestaurantTierOptionViewData>?
    >(
      selector: (state) => state.preparedOptions,
      builder: (context, preparedOptions) {
        if (preparedOptions == null || preparedOptions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locale.restaurant_tier_choose_title,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              locale.restaurant_tier_choose_subtitle,
              style: getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            for (final optionViewData in preparedOptions) ...[
              RestaurantTierSelectableOption(
                viewData: optionViewData,
                onSelect: onOptionSelected,
              ),
              const SizedBox(height: Spacing.restaurantTierCardsGap),
            ],
          ],
        );
      },
    );
  }
}

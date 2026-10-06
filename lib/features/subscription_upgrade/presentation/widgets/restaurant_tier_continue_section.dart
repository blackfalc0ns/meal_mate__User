import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_continue_button.dart';

class RestaurantTierContinueSection extends StatelessWidget {
  const RestaurantTierContinueSection({
    super.key,
    required this.onContinue,
  });

  final ValueChanged<SubscriptionUpgradeOptionEntity> onContinue;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      RestaurantTierUpgradeViewModel,
      RestaurantTierUpgradeState,
      SubscriptionUpgradeOptionEntity?
    >(
      selector: (state) => state.selectedOption,
      builder: (context, selectedOption) {
        final isEnabled =
            selectedOption != null && selectedOption.selectable;

        final text = isEnabled
            ? locale.restaurant_tier_continue_to_tier(
                selectedOption.tierNameAr.isNotEmpty
                    ? selectedOption.tierNameAr
                    : selectedOption.targetTier,
              )
            : locale.restaurant_tier_continue_button;

        return RestaurantTierContinueButton(
          text: text,
          onPressed: isEnabled ? () => onContinue(selectedOption) : null,
        );
      },
    );
  }
}

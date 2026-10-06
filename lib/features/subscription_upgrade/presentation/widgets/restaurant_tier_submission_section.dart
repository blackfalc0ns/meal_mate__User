import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/widgets/restaurant_tier_upgrade_actions.dart';

class RestaurantTierSubmissionSection extends StatelessWidget {
  const RestaurantTierSubmissionSection({
    super.key,
    required this.confirmLabel,
    required this.backLabel,
    required this.onConfirm,
    required this.onBack,
  });

  final String confirmLabel;
  final String backLabel;
  final VoidCallback onConfirm;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocSelector<
      RestaurantTierUpgradeViewModel,
      RestaurantTierUpgradeState,
      bool
    >(
      selector: (state) => state.isSubmitting,
      builder: (context, isSubmitting) {
        return RestaurantTierUpgradeActions(
          confirmLabel: isSubmitting
              ? locale.restaurant_tier_processing
              : confirmLabel,
          backLabel: backLabel,
          onConfirm: isSubmitting ? () {} : onConfirm,
          onBack: onBack,
        );
      },
    );
  }
}

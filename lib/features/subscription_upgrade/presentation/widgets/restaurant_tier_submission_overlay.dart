import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/manager/restaurant_tier_upgrade_view_model.dart';

class RestaurantTierSubmissionOverlay extends StatelessWidget {
  const RestaurantTierSubmissionOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RestaurantTierUpgradeViewModel,
      RestaurantTierUpgradeState,
      bool
    >(
      selector: (state) => state.isSubmitting,
      builder: (context, isSubmitting) {
        if (!isSubmitting) return const SizedBox.shrink();

        return const ColoredBox(
          color: Colors.black26,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

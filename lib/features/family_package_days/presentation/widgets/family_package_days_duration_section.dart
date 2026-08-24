import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';

class FamilyPackageDaysDurationSection extends StatelessWidget {
  const FamilyPackageDaysDurationSection({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;

    if (state.isDurationsLoading && state.durations.isEmpty) {
      return const SubscriptionDurationSelectorSkeleton();
    }

    if (state.durations.isEmpty) {
      return const SizedBox.shrink();
    }

    return SubscriptionDurationSelector(
      selectedIndex: state.selectedDurationIndex,
      onSelected: (index) {
        context.read<FamilyPackageDaysViewModel>().doIntent(
          SelectFamilyDurationEvent(index),
        );
      },
      includesFriday: state.includeFriday,
      onFridayChanged: (include) {
        context.read<FamilyPackageDaysViewModel>().doIntent(
          ToggleFamilyFridayEvent(include),
        );
      },
      customDurationDays: state.customDurationDays,
      onCustomDurationChanged: (days) {
        context.read<FamilyPackageDaysViewModel>().doIntent(
          UpdateFamilyCustomDurationEvent(days),
        );
      },
      durations: state.durations,
      isFridayEnabled: true,
      isLoading: state.isDurationsLoading,
    );
  }
}

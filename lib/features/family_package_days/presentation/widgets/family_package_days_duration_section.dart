import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';

class FamilyPackageDaysDurationSection extends StatelessWidget {
  const FamilyPackageDaysDurationSection({super.key, this.state});

  final FamilyPackageDaysState? state;

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      return _buildContent(context, state!);
    }
    return BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
      buildWhen: (previous, current) =>
          previous.isDurationsLoading != current.isDurationsLoading ||
          previous.durationsFailure != current.durationsFailure ||
          previous.durations != current.durations ||
          previous.selectedDurationIndex != current.selectedDurationIndex ||
          previous.customDurationDays != current.customDurationDays ||
          previous.includeFriday != current.includeFriday ||
          previous.isSelectedManagerPlanLocked !=
              current.isSelectedManagerPlanLocked,
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, FamilyPackageDaysState state) {
    if (state.durationsFailure != null && state.durations.isEmpty) {
      return InlineApiErrorWidget(
        failure: state.durationsFailure!,
        onRetry: () => context.read<FamilyPackageDaysViewModel>().doIntent(
          const RetryFamilyDurationsEvent(),
        ),
      );
    }

    if (state.isDurationsLoading && state.durations.isEmpty) {
      return const SubscriptionDurationSelectorSkeleton();
    }

    if (state.durations.isEmpty) {
      return const SizedBox.shrink();
    }

    return AbsorbPointer(
      absorbing: state.isSelectedManagerPlanLocked,
      child: SubscriptionDurationSelector(
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
        isLoading: state.isDurationsLoading && state.durations.isEmpty,
      ),
    );
  }
}

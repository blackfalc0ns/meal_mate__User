import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/widget/custom_warning_widget.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_packages_section.dart';

class MonthlyPlanPackagesView extends StatelessWidget {
  const MonthlyPlanPackagesView({
    super.key,
    required this.state,
    required this.plan,
    required this.fridayUnavailableMessage,
    required this.onBrowseRestaurants,
  });

  final SubscriptionPlanState state;
  final MonthlyPlanDetailsEntity plan;
  final String fridayUnavailableMessage;
  final ValueChanged<int> onBrowseRestaurants;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (fridayUnavailableMessage.isNotEmpty) ...[
          CustomWarningWidget(
            icon: Icons.warning_rounded,
            message: fridayUnavailableMessage,
            isWarning: true,
            maxMessageLines: 3,
          ),
          const SizedBox(height: Spacing.md),
        ],
        MonthlyPlanPackagesSection(
          packages: plan.packageTiers,
          selectedIndex: state.selectedTierIndex,
          onSelected: (index) => context
              .read<SubscriptionPlanViewModel>()
              .doIntent(SelectSubscriptionTierEvent(index)),
          onBrowseRestaurants: onBrowseRestaurants,
        ),
      ],
    );
  }
}

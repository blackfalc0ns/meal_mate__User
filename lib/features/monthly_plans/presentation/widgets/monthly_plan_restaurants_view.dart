import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_plan_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurants_loading_skeleton.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_restaurants_section.dart';

class MonthlyPlanRestaurantsView extends StatelessWidget {
  const MonthlyPlanRestaurantsView({
    super.key,
    required this.state,
    required this.plan,
    required this.onClose,
    required this.onRetry,
  });

  final SubscriptionPlanState state;
  final MonthlyPlanDetailsEntity plan;
  final VoidCallback onClose;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              color: color.onSurface,
              size: Spacing.iconLg,
              semanticLabel: locale.go_back,
            ),
          ),
        ),
        const SizedBox(height: Spacing.xs),
        if (state.isBrowseRestaurantsLoading && state.browseRestaurants.isEmpty)
          const MonthlyPlanRestaurantsLoadingSkeleton()
        else if (state.browseRestaurantsFailure != null &&
            state.browseRestaurants.isEmpty)
          ApiErrorWidget(
            exception: state.browseRestaurantsFailure!.exception,
            onRetry: onRetry,
          )
        else if (state.browseRestaurants.isEmpty)
          EmptyStateWidget(
            title: locale.subscription_restaurant_categories_title,
            description: locale.subscription_restaurant_categories_subtitle,
            icon: Icons.restaurant_rounded,
          )
        else
          MonthlyPlanRestaurantsSection(
            mode: SubscriptionPlanViewMode.grid,
            restaurants: plan.restaurants,
          ),
      ],
    );
  }
}

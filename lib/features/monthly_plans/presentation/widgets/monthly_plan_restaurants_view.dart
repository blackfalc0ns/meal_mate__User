import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
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

    final screenHeight = MediaQuery.sizeOf(context).height;
    final minContentHeight = screenHeight > Spacing.monthlyPlanDurationCardTop
        ? screenHeight - Spacing.monthlyPlanDurationCardTop
        : Spacing.zero;

    return Container(
      constraints: BoxConstraints(minHeight: minContentHeight),
      decoration: BoxDecoration(
        color: color.subscriptionRestaurantsSheetBackground.withValues(
          alpha: 0.5,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
        border: Border.all(
          color: color.subscriptionRestaurantsSheetBorder,
          width: Spacing.border,
        ),
      ),
      padding: const EdgeInsets.only(top: Spacing.md, bottom: Spacing.xxxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  IconButton(
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
                  Expanded(
                    child: Center(
                      child: Directionality(
                        textDirection: Directionality.of(context),
                        child: Text(
                          locale.calendar_browse_restaurants,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size18,
                            color: color.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.iconLg),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
            child:
                state.isBrowseRestaurantsLoading &&
                    state.browseRestaurants.isEmpty
                ? const MonthlyPlanRestaurantsLoadingSkeleton()
                : state.browseRestaurantsFailure != null &&
                      state.browseRestaurants.isEmpty
                ? ApiErrorWidget(
                    exception: state.browseRestaurantsFailure!.exception,
                    onRetry: onRetry,
                  )
                : state.browseRestaurants.isEmpty
                ? EmptyStateWidget(
                    title: locale.subscription_restaurant_categories_title,
                    description:
                        locale.subscription_restaurant_categories_subtitle,
                    icon: Icons.restaurant_rounded,
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MonthlyPlanRestaurantsSection(
                        mode: SubscriptionPlanViewMode.grid,
                        restaurants: plan.restaurants,
                      ),
                      if (state.isBrowseRestaurantsLoadingMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.md),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                      if (state.browseRestaurantsLoadMoreFailure != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Spacing.md,
                          ),
                          child: InlineApiErrorWidget(
                            failure: state.browseRestaurantsLoadMoreFailure!,
                            onRetry: onRetry,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );

  }
}

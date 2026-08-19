import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/restaurant_details_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/restaurant_details_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/restaurant_details_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/ingredient_origins_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/restaurant_details_header_section.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/restaurant_details_skeleton.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/restaurant_meal_group_list.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/restaurant_meal_groups_tab_bar.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({super.key, this.args});

  final SubscriptionRestaurantDetailsArgs? args;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final navArgs = args;

    if (navArgs == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.calendar_browse_restaurants,
          description: locale.error_not_found_desc,
          icon: Icons.restaurant_rounded,
        ),
      );
    }

    return BlocProvider<RestaurantDetailsViewModel>(
      create: (_) => getIt<RestaurantDetailsViewModel>()
        ..doIntent(
          GetRestaurantDetailsEvent(
            programId: navArgs.programId,
            bundleId: navArgs.bundleId,
            restaurantId: navArgs.restaurantId,
          ),
        ),
      child: BlocBuilder<RestaurantDetailsViewModel, RestaurantDetailsState>(
        builder: (context, state) {
          if (state.isLoading && !state.isSuccess) {
            return Scaffold(
              backgroundColor: color.surface,
              body: const RestaurantDetailsSkeleton(),
            );
          }

          if (state.failure != null && !state.isSuccess) {
            return Scaffold(
              backgroundColor: color.surface,
              body: Center(
                child: ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () =>
                      context.read<RestaurantDetailsViewModel>().doIntent(
                        GetRestaurantDetailsEvent(
                          programId: navArgs.programId,
                          bundleId: navArgs.bundleId,
                          restaurantId: navArgs.restaurantId,
                        ),
                      ),
                ),
              ),
            );
          }

          final details = state.details;
          if (details == null) {
            return Scaffold(
              backgroundColor: color.surface,
              body: EmptyStateWidget(
                title: locale.calendar_browse_restaurants,
                description: locale.error_not_found_desc,
                icon: Icons.restaurant_rounded,
              ),
            );
          }

          final activeGroup = state.activeMealGroup;

          return Scaffold(
            backgroundColor: color.surface,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RestaurantDetailsHeaderSection(
                    restaurantName: details.name(locale.localeName),
                    coverImageUrl: details.coverImageUrl,
                    logoUrl: details.logoUrl,
                    onBack: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(height: Spacing.xxxl * 2),
                  if (details.ingredientOrigins.isNotEmpty) ...[
                    IngredientOriginsSection(
                      origins: details.ingredientOrigins,
                    ),
                    const SizedBox(height: Spacing.xl),
                  ],
                  if (details.mealGroups.isNotEmpty) ...[
                    RestaurantMealGroupsTabBar(
                      groups: details.mealGroups,
                      selectedSlot: state.selectedSlot,
                      onSlotSelected: (slot) => context
                          .read<RestaurantDetailsViewModel>()
                          .doIntent(SelectMealGroupSlotEvent(slot)),
                    ),
                    const SizedBox(height: Spacing.lg),
                  ],
                  if (activeGroup != null && activeGroup.meals.isNotEmpty) ...[
                    RestaurantMealGroupList(
                      group: activeGroup,
                      onMealTap: (mealId) {
                        context.pushNamed(
                          AppRoutes.mealDetails,
                          arguments: SubscriptionMealDetailsArgs(
                            programId: navArgs.programId,
                            bundleId: navArgs.bundleId,
                            restaurantId: navArgs.restaurantId,
                            mealId: mealId,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Spacing.xxxl),
                  ] else ...[
                    EmptyStateWidget(
                      title: locale.calendar_browse_restaurants,
                      description:
                          locale.subscription_packages_empty_description,
                      icon: Icons.restaurant_menu_rounded,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

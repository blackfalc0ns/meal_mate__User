import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_restaurant_details_event.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_restaurant_details_state.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/manager/subscription_restaurant_details_view_model.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/subscription_restaurant_details_loading_skeleton.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/mapper/subscription_menu_mapper.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/screens/restaurant_menu_screen.dart';

class SubscriptionRestaurantDetailsScreen extends StatelessWidget {
  const SubscriptionRestaurantDetailsScreen({super.key, this.args});

  final SubscriptionRestaurantDetailsArgs? args;

  void _onBackPressed(BuildContext context) {
    unawaited(Navigator.maybePop(context));
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final detailsArgs = args;

    if (detailsArgs == null) {
      return Scaffold(
        backgroundColor: color.surface,
        body: EmptyStateWidget(
          title: locale.calendar_restaurant_name,
          description: locale.subscription_packages_empty_description,
          icon: Icons.restaurant_rounded,
        ),
      );
    }

    return BlocProvider(
      create: (_) => getIt<SubscriptionRestaurantDetailsViewModel>()
        ..doIntent(
          GetSubscriptionRestaurantDetailsEvent(
            programId: detailsArgs.programId,
            bundleId: detailsArgs.bundleId,
            restaurantId: detailsArgs.restaurantId,
          ),
        ),
      child:
          BlocBuilder<
            SubscriptionRestaurantDetailsViewModel,
            SubscriptionRestaurantDetailsState
          >(
            builder: (context, state) {
              if (state.isLoading && state.details == null) {
                return SubscriptionRestaurantDetailsLoadingSkeleton(
                  onBack: () => _onBackPressed(context),
                );
              }

              if (state.failure != null && state.details == null) {
                return Scaffold(
                  backgroundColor: color.surface,
                  body: ApiErrorWidget(
                    exception: state.failure!.exception,
                    onRetry: () {
                      context
                          .read<SubscriptionRestaurantDetailsViewModel>()
                          .doIntent(
                            GetSubscriptionRestaurantDetailsEvent(
                              programId: detailsArgs.programId,
                              bundleId: detailsArgs.bundleId,
                              restaurantId: detailsArgs.restaurantId,
                            ),
                          );
                    },
                  ),
                );
              }

              final details = state.details;
              if (details == null) {
                return Scaffold(
                  backgroundColor: color.surface,
                  body: EmptyStateWidget(
                    title: locale.calendar_restaurant_name,
                    description: locale.subscription_packages_empty_description,
                    icon: Icons.restaurant_rounded,
                  ),
                );
              }

              final menuData = SubscriptionMenuMapper.toMenuData(
                details: details,
                locale: locale,
                restaurantName: detailsArgs.restaurantName,
                restaurantLogoUrl: detailsArgs.restaurantLogoUrl,
                restaurantInitials: detailsArgs.restaurantInitials,
                restaurantRating: detailsArgs.restaurantRating,
              );

              return RestaurantMenuScreen(
                mode: RestaurantMenuMode.preview,
                menuData: menuData,
                onBackPressed: () => _onBackPressed(context),
                onOptionDetails: (option) {
                  unawaited(
                    Navigator.of(context).pushNamed(
                      AppRoutes.mealDetails,
                      arguments: SubscriptionMealDetailsArgs(
                        programId: detailsArgs.programId,
                        bundleId: detailsArgs.bundleId,
                        restaurantId: detailsArgs.restaurantId,
                        mealId: option.id,
                        restaurantInitials: detailsArgs.restaurantInitials,
                        restaurantRating: detailsArgs.restaurantRating,
                      ),
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}

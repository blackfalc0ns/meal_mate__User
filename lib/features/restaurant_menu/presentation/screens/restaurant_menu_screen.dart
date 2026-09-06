import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart';

export 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart'
    show RestaurantMenuMode;

class RestaurantMenuScreen extends StatelessWidget {
  const RestaurantMenuScreen({
    super.key,
    required this.mode,
    this.restaurantName,
    this.restaurantLogoAsset,
    this.restaurantLogoUrl,
    this.restaurantInitials,
    this.restaurantRating,
    this.programId,
    this.bundleId,
    this.restaurantId,
    this.details,
    this.availableMeals,
    this.selectedMealIds = const [],
    this.onMealToggled,
    this.onLoadMore,
    this.onSave,
    this.canSave = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSaving = false,
    this.failure,
    this.onBackPressed,
    this.bottomContentPadding = Spacing.zero,
  });

  final RestaurantMenuMode mode;
  final String? restaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;
  final String? restaurantRating;
  final String? programId;
  final String? bundleId;
  final String? restaurantId;
  final SubscriptionRestaurantDetailsEntity? details;
  final CalendarAvailableMealsEntity? availableMeals;
  final List<String> selectedMealIds;
  final ValueChanged<String>? onMealToggled;
  final ValueChanged<String>? onLoadMore;
  final VoidCallback? onSave;
  final bool canSave;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSaving;
  final Failure? failure;
  final VoidCallback? onBackPressed;
  final double bottomContentPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RestaurantMenuView(
        isFullPage: true,
        mode: mode,
        restaurantName: restaurantName,
        restaurantLogoAsset: restaurantLogoAsset,
        restaurantLogoUrl: restaurantLogoUrl,
        restaurantInitials: restaurantInitials,
        restaurantRating: restaurantRating,
        programId: programId,
        bundleId: bundleId,
        restaurantId: restaurantId,
        details: details,
        availableMeals: availableMeals,
        selectedMealIds: selectedMealIds,
        onMealToggled: onMealToggled,
        onLoadMore: onLoadMore,
        onSave: onSave,
        canSave: canSave,
        isLoading: isLoading,
        isLoadingMore: isLoadingMore,
        isSaving: isSaving,
        failure: failure,
        onBackPressed: onBackPressed,
        bottomContentPadding: bottomContentPadding,
      ),
    );
  }
}

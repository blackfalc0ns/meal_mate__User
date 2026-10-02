import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart';

export 'package:meal_meat_user/features/restaurant_menu/domain/models/restaurant_menu_models.dart';
export 'package:meal_meat_user/features/restaurant_menu/presentation/widgets/restaurant_menu_view.dart'
    show RestaurantMenuMode;

class RestaurantMenuScreen extends StatelessWidget {
  const RestaurantMenuScreen({
    super.key,
    required this.mode,
    required this.menuData,
    this.onMealToggled,
    this.onOptionDetails,
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
  final RestaurantMenuData menuData;
  final ValueChanged<String>? onMealToggled;
  final ValueChanged<RestaurantMenuOption>? onOptionDetails;
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
        menuData: menuData,
        onMealToggled: onMealToggled,
        onOptionDetails: onOptionDetails,
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

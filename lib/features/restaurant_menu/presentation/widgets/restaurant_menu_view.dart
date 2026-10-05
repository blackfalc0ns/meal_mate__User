import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/restaurant_menu/domain/models/restaurant_menu_models.dart';

export 'package:meal_meat_user/features/restaurant_menu/domain/models/restaurant_menu_models.dart';

part 'restaurant_menu_content.dart';
part 'restaurant_menu_meals_body.dart';
part 'restaurant_menu_animated_option.dart';
part 'restaurant_menu_frame.dart';
part 'restaurant_menu_navigation.dart';
part 'restaurant_menu_sheet_handle.dart';
part 'restaurant_menu_header.dart';
part 'restaurant_menu_description.dart';
part 'restaurant_menu_source_section.dart';
part 'restaurant_menu_source_card.dart';
part 'restaurant_menu_tabs.dart';
part 'restaurant_menu_tab_label.dart';
part 'restaurant_menu_options_section.dart';
part 'restaurant_menu_section_title.dart';
part 'restaurant_menu_option_card.dart';
part 'restaurant_menu_select_button.dart';
part 'restaurant_menu_nutrition_row.dart';
part 'restaurant_menu_nutrition.dart';
part 'restaurant_menu_ingredient_row.dart';
part 'restaurant_menu_ingredient_chip.dart';
part 'restaurant_menu_loading_skeleton.dart';
part 'restaurant_menu_divider_line.dart';
part 'restaurant_menu_protein_logo.dart';

enum RestaurantMenuMode { preview, selection }

class RestaurantMenuView extends StatelessWidget {
  const RestaurantMenuView({
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
    this.isFullPage = false,
    this.bottomContentPadding = Spacing.zero,
    this.selectionControlBuilder,
    this.isMealSelected,
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
  final bool isFullPage;
  final double bottomContentPadding;
  final Widget Function(BuildContext context, RestaurantMenuOption option)?
  selectionControlBuilder;
  final bool Function(String mealId)? isMealSelected;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final restaurantName =
        menuData.restaurantName ?? locale.calendar_restaurant_name;

    final headerSliver = RestaurantMenuContent.buildHeaderSliver(
      isFullPage: isFullPage,
      restaurantName: restaurantName,
      restaurantLogoAsset: menuData.restaurantLogoAsset,
      restaurantLogoUrl: menuData.restaurantLogoUrl,
      restaurantInitials: menuData.restaurantInitials,
      origins: menuData.origins,
      isLoading: isLoading,
    );

    return RestaurantMenuFrame(
      restaurantName: restaurantName,
      coverImageUrl: menuData.coverImageUrl,
      onBackPressed: onBackPressed,
      child: RestaurantMenuMealsBody(
        mode: mode,
        menuData: menuData,
        tabs: menuData.tabs,
        headerSliver: headerSliver,
        onMealToggled: onMealToggled,
        onOptionDetails: onOptionDetails,
        onLoadMore: onLoadMore,
        onSave: onSave,
        canSave: canSave,
        isLoading: isLoading,
        isLoadingMore: isLoadingMore,
        isSaving: isSaving,
        failure: failure,
        bottomContentPadding: bottomContentPadding,
        selectionControlBuilder: selectionControlBuilder,
        isMealSelected: isMealSelected,
        restaurantName: restaurantName,
        restaurantInitials: menuData.restaurantInitials,
        restaurantLogoUrl: menuData.restaurantLogoUrl,
        restaurantRating: menuData.restaurantRating,
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';

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

typedef RestaurantMenuOption = ({
  String id,
  String slot,
  String title,
  String imageAsset,
  String? imageUrl,
  String calories,
  String protein,
  String carbs,
  String fat,
  List<CalendarMealIngredientEntity> ingredients,
  bool selected,
  String? blockReason,
});

class RestaurantMenuView extends StatefulWidget {
  const RestaurantMenuView({
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
    this.isFullPage = false,
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
  final bool isFullPage;
  final double bottomContentPadding;

  @override
  State<RestaurantMenuView> createState() => RestaurantMenuViewState();
}

class RestaurantMenuViewState extends State<RestaurantMenuView> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final height = MediaQuery.sizeOf(context).height;
    final restaurantName =
        widget.restaurantName ?? locale.calendar_restaurant_name;
    final details = widget.details;
    final groups = details?.mealGroups ?? const [];
    final availableMeals = widget.availableMeals;
    final apiSlotRequirements = availableMeals?.slotRequirements ?? const [];
    final apiSlots = apiSlotRequirements
        .map((requirement) => requirement.slot)
        .where((slot) => slot.isNotEmpty)
        .toList();
    final apiSlotLabels = apiSlotRequirements
        .map((requirement) {
          final label = requirement.displayName;
          return label.isNotEmpty ? label : requirement.slot;
        })
        .where((slot) => slot.isNotEmpty)
        .toList();
    final mealTabs = apiSlotLabels.isNotEmpty
        ? apiSlotLabels
        : groups.isEmpty
        ? [
            locale.calendar_breakfast,
            locale.calendar_lunch,
            locale.calendar_dinner,
          ]
        : groups.map((group) => group.name(locale.localeName)).toList();
    final selectedTab = mealTabs.isEmpty
        ? 0
        : _selectedTab.clamp(0, mealTabs.length - 1);
    final selectedSlot = apiSlots.isNotEmpty
        ? apiSlots[selectedTab.clamp(0, apiSlots.length - 1)]
        : mealTabs[selectedTab];
    final options = availableMeals != null
        ? _optionsFromAvailableMeals(
            availableMeals.meals,
            selectedSlot,
            locale.calendar_more,
          )
        : groups.isEmpty
        ? const <RestaurantMenuOption>[]
        : _optionsFromGroup(
            groups[selectedTab],
            locale.localeName,
            locale.calendar_more,
          );
    final resolvedRestaurantName =
        widget.restaurantName ??
        availableMeals?.restaurant?.name ??
        restaurantName;
    final restaurantLogoUrl =
        widget.restaurantLogoUrl ??
        details?.logoUrl ??
        availableMeals?.restaurant?.logoUrl;
    final contentTop = Spacing.restaurantDetailsSheetTop;
    final contentRadius = const BorderRadius.vertical(
      top: Radius.circular(Spacing.restaurantDetailsSheetRadius),
    );

    return Material(
      color: color.surface,
      child: Container(
        height: height,
        color: color.surface,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: Spacing.restaurantDetailsHeroHeight,
              child: details?.coverImageUrl == null
                  ? Image.asset(
                      Assets.calendarMealPickerHero,
                      fit: BoxFit.cover,
                    )
                  : AppCachedNetworkImage(
                      imageUrl: details!.coverImageUrl,
                      fit: BoxFit.cover,
                      semanticLabel: restaurantName,
                    ),
            ),
            CustomBackButton(
              onPressed:
                  widget.onBackPressed ?? () => Navigator.maybePop(context),
            ),
            Positioned(
              top: contentTop,
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: contentRadius,
                child: ColoredBox(
                  color: color.surface,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification.metrics.pixels >=
                              notification.metrics.maxScrollExtent - 200 &&
                          !widget.isLoading &&
                          !widget.isLoadingMore) {
                        widget.onLoadMore?.call(selectedSlot);
                      }
                      return false;
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              if (!widget.isFullPage) ...[
                                const SizedBox(height: Spacing.lg),
                                const RestaurantMenuSheetHandle(),
                              ],
                              const SizedBox(height: Spacing.md),
                              RestaurantMenuHeader(
                                restaurantName: resolvedRestaurantName,
                                restaurantLogoAsset: widget.restaurantLogoAsset,
                                restaurantLogoUrl: restaurantLogoUrl,
                                restaurantInitials: widget.restaurantInitials,
                              ),
                              const RestaurantMenuDescription(),
                              const RestaurantMenuDividerLine(),
                              RestaurantMenuSourceSection(
                                coreIngredients:
                                    availableMeals?.coreIngredients ?? const [],
                                origins: details?.ingredientOrigins ?? const [],
                              ),
                              const SizedBox(height: Spacing.base),
                              RestaurantMenuTabs(
                                labels: mealTabs,
                                selectedIndex: selectedTab,
                                onChanged: (index) {
                                  setState(() => _selectedTab = index);
                                },
                              ),
                              const SizedBox(height: Spacing.sm),
                              if (widget.failure != null)
                                ApiErrorWidget(
                                  exception: widget.failure!.exception,
                                )
                              else if (widget.isLoading)
                                const RestaurantMenuLoadingSkeleton()
                              else
                                RestaurantMenuOptionsSection(
                                  mealType: mealTabs[selectedTab],
                                  tabIndex: selectedTab,
                                  options: options,
                                  isLoadingMore: widget.isLoadingMore,
                                  onOptionSelected:
                                      widget.mode ==
                                              RestaurantMenuMode.selection &&
                                          availableMeals != null &&
                                          widget.onMealToggled != null
                                      ? (index) => widget.onMealToggled!(
                                          options[index].id,
                                        )
                                      : null,
                                  onOptionDetailsSelected:
                                      availableMeals != null
                                      ? (index) {
                                          final selectedMeal = availableMeals
                                              .meals
                                              .where(
                                                (m) =>
                                                    m.id == options[index].id,
                                              )
                                              .firstOrNull;
                                          if (selectedMeal != null) {
                                            _openMealDetailsForCalendarMeal(
                                              selectedMeal,
                                            );
                                          }
                                        }
                                      : groups.isEmpty
                                      ? null
                                      : (index) => _openMealDetails(
                                          groups[selectedTab].meals[index],
                                        ),
                                ),
                              if (widget.mode == RestaurantMenuMode.selection &&
                                  widget.onSave != null) ...[
                                const SizedBox(height: Spacing.lg),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.lg,
                                  ),
                                  child: AppButton(
                                    text: locale.calendar_done,
                                    isLoading: widget.isSaving,
                                    onPressed: widget.canSave
                                        ? widget.onSave
                                        : null,
                                  ),
                                ),
                              ],
                              SizedBox(
                                height:
                                    Spacing.xxl + widget.bottomContentPadding,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openMealDetails(SubscriptionRestaurantMealEntity meal) {
    final locale = context.localization;
    final details = widget.details;
    final programId = widget.programId;
    final bundleId = widget.bundleId;
    final restaurantId = widget.restaurantId ?? details?.restaurantId;

    if (programId != null &&
        programId.isNotEmpty &&
        bundleId != null &&
        bundleId.isNotEmpty &&
        restaurantId != null &&
        restaurantId.isNotEmpty &&
        meal.mealId.isNotEmpty) {
      Navigator.of(context).pushNamed(
        AppRoutes.mealDetails,
        arguments: SubscriptionMealDetailsArgs(
          programId: programId,
          bundleId: bundleId,
          restaurantId: restaurantId,
          mealId: meal.mealId,
          restaurantInitials: widget.restaurantInitials,
          restaurantRating: widget.restaurantRating,
        ),
      );
      return;
    }

    final restaurantName =
        details?.name(locale.localeName) ??
        widget.restaurantName ??
        locale.calendar_restaurant_name;

    Navigator.of(context).pushNamed(
      AppRoutes.mealDetails,
      arguments: MealDetailsEntity(
        title: meal.name(locale.localeName),
        description: locale.search_meal_description,
        restaurantName: restaurantName,
        restaurantLogo: widget.restaurantInitials ?? _initials(restaurantName),
        restaurantLogoUrl: widget.restaurantLogoUrl ?? details?.logoUrl,
        headerImageUrl: meal.imageUrl ?? details?.coverImageUrl,
        ratingTitle: locale.localeName == 'ar'
            ? 'تقييم المطعم'
            : 'Restaurant rating',
        ratingValue: widget.restaurantRating ?? '',
        programLabel: locale.localeName == 'ar'
            ? 'مناسبة لبرنامج'
            : 'Suitable for program',
        programValue: '',
        deliveryLabel: locale.localeName == 'ar'
            ? 'وقت التوصيل'
            : 'Delivery time',
        deliveryValue: '',
        ingredientsTitle: locale.calendar_ingredients,
        ingredients: meal.ingredients
            .map(
              (ingredient) => MealDetailsIngredientEntity(
                label: ingredient.name(locale.localeName),
                asset: _ingredientAsset(ingredient.category),
                iconUrl: ingredient.iconUrl,
              ),
            )
            .where((ingredient) => ingredient.label.isNotEmpty)
            .toList(),
        nutritionTitle: locale.localeName == 'ar'
            ? 'القيم الغذائية'
            : 'Nutrition facts',
        nutritionItems: [
          MealDetailsNutritionEntity(
            value: _gramValue(null, locale.localeName),
            label: locale.localeName == 'ar' ? 'ألياف' : 'Fiber',
            type: MealDetailsNutritionType.fiber,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(meal.proteinG, locale.localeName),
            label: locale.calendar_protein,
            type: MealDetailsNutritionType.protein,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(meal.carbsG, locale.localeName),
            label: locale.calendar_carbs,
            type: MealDetailsNutritionType.carbs,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(meal.fatG, locale.localeName),
            label: locale.calendar_fat,
            type: MealDetailsNutritionType.fat,
          ),
          MealDetailsNutritionEntity(
            value: meal.calories?.toString() ?? '-',
            label: locale.calendar_calories,
            type: MealDetailsNutritionType.calories,
          ),
        ],
        macroDistributionTitle: locale.localeName == 'ar'
            ? 'توزيع العناصر الغذائية'
            : 'Macro distribution',
        macroItems: _macroItems(meal, locale.localeName, locale),
        allergensTitle: locale.localeName == 'ar'
            ? 'مسببات الحساسية'
            : 'Allergens',
        allergens: const [],
      ),
    );
  }

  List<RestaurantMenuOption> _optionsFromGroup(
    SubscriptionRestaurantMealGroupEntity group,
    String localeName,
    String moreLabel,
  ) {
    return group.meals.map((meal) {
      final ingredients = meal.ingredients
          .map(
            (ingredient) => CalendarMealIngredientEntity(
              label: ingredient.name(localeName),
              asset: _ingredientAsset(ingredient.category),
              iconUrl: ingredient.iconUrl,
            ),
          )
          .where((ingredient) => ingredient.label.isNotEmpty)
          .toList();
      final visibleIngredients = _visibleIngredients(ingredients, moreLabel);

      return (
        id: meal.mealId,
        slot: group.name(localeName),
        title: meal.name(localeName),
        imageAsset: Assets.calendarMealPickerHero,
        imageUrl: meal.imageUrl,
        calories: meal.calories?.toString() ?? '',
        protein: meal.proteinG?.toString() ?? '',
        carbs: meal.carbsG?.toString() ?? '',
        fat: meal.fatG?.toString() ?? '',
        ingredients: visibleIngredients,
        selected: false,
        blockReason: null,
      );
    }).toList();
  }

  List<RestaurantMenuOption> _optionsFromAvailableMeals(
    List<CalendarMealEntity> meals,
    String slot,
    String moreLabel,
  ) {
    return meals
        .where((meal) => meal.slot.toLowerCase() == slot.toLowerCase())
        .map((meal) {
          final visibleIngredients = _visibleIngredients(
            meal.ingredients,
            moreLabel,
          );

          return (
            id: meal.id,
            slot: meal.slot,
            title: meal.title,
            imageAsset: Assets.calendarMealPickerHero,
            imageUrl: meal.imageUrl,
            calories: meal.calories,
            protein: meal.protein,
            carbs: meal.carbs,
            fat: meal.fat,
            ingredients: visibleIngredients,
            selected: widget.selectedMealIds.contains(meal.id),
            blockReason: meal.blockReason,
          );
        })
        .toList();
  }

  List<MealDetailsMacroEntity> _macroItems(
    SubscriptionRestaurantMealEntity meal,
    String localeName,
    AppLocalizations locale,
  ) {
    final fatCalories = (meal.fatG ?? 0) * 9;
    final proteinCalories = (meal.proteinG ?? 0) * 4;
    final carbsCalories = (meal.carbsG ?? 0) * 4;
    final total = fatCalories + proteinCalories + carbsCalories;

    return [
      MealDetailsMacroEntity(
        percent: _percent(fatCalories, total),
        label: locale.calendar_fat,
        value: _gramValue(meal.fatG, localeName),
        type: MealDetailsNutritionType.fat,
      ),
      MealDetailsMacroEntity(
        percent: _percent(proteinCalories, total),
        label: locale.calendar_protein,
        value: _gramValue(meal.proteinG, localeName),
        type: MealDetailsNutritionType.protein,
      ),
      MealDetailsMacroEntity(
        percent: _percent(carbsCalories, total),
        label: locale.calendar_carbs,
        value: _gramValue(meal.carbsG, localeName),
        type: MealDetailsNutritionType.carbs,
      ),
    ];
  }

  String _percent(int value, int total) {
    if (total == 0) return '-';
    return '%${((value / total) * 100).round()}';
  }

  String _gramValue(int? value, String localeName) {
    if (value == null) return '-';
    return localeName == 'ar' ? '$value جم' : '${value}g';
  }

  String _ingredientAsset(String category) {
    return Assets.calendarMealPickerHero;
  }

  List<CalendarMealIngredientEntity> _visibleIngredients(
    List<CalendarMealIngredientEntity> ingredients,
    String moreLabel,
  ) {
    if (ingredients.length <= 4) return ingredients;
    return [
      ...ingredients.take(4),
      CalendarMealIngredientEntity(
        label: moreLabel,
        asset: Assets.calendarMealPickerHero,
      ),
    ];
  }

  void _openMealDetailsForCalendarMeal(CalendarMealEntity meal) {
    final locale = context.localization;
    final details = widget.details;
    final availableMeals = widget.availableMeals;
    final restaurant = availableMeals?.restaurant;
    final restaurantName =
        widget.restaurantName ??
        restaurant?.name ??
        details?.name(locale.localeName) ??
        locale.calendar_restaurant_name;

    final proteinG = _parseNullableInt(meal.protein);
    final carbsG = _parseNullableInt(meal.carbs);
    final fatG = _parseNullableInt(meal.fat);

    Navigator.of(context).pushNamed(
      AppRoutes.mealDetails,
      arguments: MealDetailsEntity(
        title: meal.title,
        description: locale.search_meal_description,
        restaurantName: restaurantName,
        restaurantLogo: widget.restaurantInitials ?? _initials(restaurantName),
        restaurantLogoUrl:
            widget.restaurantLogoUrl ?? restaurant?.logoUrl ?? details?.logoUrl,
        headerImageUrl: meal.imageUrl ?? details?.coverImageUrl,
        ratingTitle: locale.localeName == 'ar'
            ? 'تقييم المطعم'
            : 'Restaurant rating',
        ratingValue: widget.restaurantRating ?? restaurant?.rating ?? '',
        programLabel: locale.localeName == 'ar' ? 'نوع الوجبة' : 'Meal type',
        programValue: meal.mealType,
        deliveryLabel: locale.localeName == 'ar'
            ? 'وقت التوصيل'
            : 'Delivery time',
        deliveryValue: restaurant?.deliveryWindow ?? '',
        ingredientsTitle: locale.calendar_ingredients,
        ingredients: meal.ingredients
            .map(
              (ingredient) => MealDetailsIngredientEntity(
                label: ingredient.label,
                asset: ingredient.asset,
                iconUrl: ingredient.iconUrl,
              ),
            )
            .where((ingredient) => ingredient.label.isNotEmpty)
            .toList(),
        nutritionTitle: locale.localeName == 'ar'
            ? 'القيم الغذائية'
            : 'Nutrition facts',
        nutritionItems: [
          MealDetailsNutritionEntity(
            value: _gramValue(null, locale.localeName),
            label: locale.localeName == 'ar' ? 'ألياف' : 'Fiber',
            type: MealDetailsNutritionType.fiber,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(proteinG, locale.localeName),
            label: locale.calendar_protein,
            type: MealDetailsNutritionType.protein,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(carbsG, locale.localeName),
            label: locale.calendar_carbs,
            type: MealDetailsNutritionType.carbs,
          ),
          MealDetailsNutritionEntity(
            value: _gramValue(fatG, locale.localeName),
            label: locale.calendar_fat,
            type: MealDetailsNutritionType.fat,
          ),
          MealDetailsNutritionEntity(
            value: meal.calories.isNotEmpty ? meal.calories : '-',
            label: locale.calendar_calories,
            type: MealDetailsNutritionType.calories,
          ),
        ],
        macroDistributionTitle: locale.localeName == 'ar'
            ? 'توزيع العناصر الغذائية'
            : 'Macro distribution',
        macroItems: _macroItemsFromValues(
          proteinG,
          carbsG,
          fatG,
          locale.localeName,
          locale,
          proteinPercentage: meal.proteinPercentage,
          carbsPercentage: meal.carbsPercentage,
          fatPercentage: meal.fatPercentage,
        ),
        allergensTitle: locale.localeName == 'ar'
            ? 'مسببات الحساسية'
            : 'Allergens',
        allergens: const [],
      ),
    );
  }

  List<MealDetailsMacroEntity> _macroItemsFromValues(
    int? proteinG,
    int? carbsG,
    int? fatG,
    String localeName,
    AppLocalizations locale, {
    double? proteinPercentage,
    double? carbsPercentage,
    double? fatPercentage,
  }) {
    final fatCalories = (fatG ?? 0) * 9;
    final proteinCalories = (proteinG ?? 0) * 4;
    final carbsCalories = (carbsG ?? 0) * 4;
    final total = fatCalories + proteinCalories + carbsCalories;

    final fatPercentStr = fatPercentage != null
        ? '%${fatPercentage.round()}'
        : _percent(fatCalories, total);
    final proteinPercentStr = proteinPercentage != null
        ? '%${proteinPercentage.round()}'
        : _percent(proteinCalories, total);
    final carbsPercentStr = carbsPercentage != null
        ? '%${carbsPercentage.round()}'
        : _percent(carbsCalories, total);

    return [
      MealDetailsMacroEntity(
        percent: fatPercentStr,
        label: locale.calendar_fat,
        value: _gramValue(fatG, localeName),
        type: MealDetailsNutritionType.fat,
      ),
      MealDetailsMacroEntity(
        percent: proteinPercentStr,
        label: locale.calendar_protein,
        value: _gramValue(proteinG, localeName),
        type: MealDetailsNutritionType.protein,
      ),
      MealDetailsMacroEntity(
        percent: carbsPercentStr,
        label: locale.calendar_carbs,
        value: _gramValue(carbsG, localeName),
        type: MealDetailsNutritionType.carbs,
      ),
    ];
  }

  int? _parseNullableInt(String value) {
    if (value.isEmpty) return null;
    return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
  }

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}

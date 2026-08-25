import 'package:flutter/material.dart';
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
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_entity.dart';

part 'calendar_sheet_handle.dart';
part 'calendar_meal_picker_restaurant_header.dart';
part 'calendar_meal_picker_restaurant_description.dart';
part 'calendar_source_section.dart';
part 'calendar_source_card.dart';
part 'calendar_meal_tabs.dart';
part 'calendar_tab_label.dart';
part 'calendar_meal_options_section.dart';
part 'calendar_section_title.dart';
part 'calendar_meal_option_card.dart';
part 'calendar_select_button.dart';
part 'calendar_meal_nutrition_row.dart';
part 'calendar_meal_nutrition.dart';
part 'calendar_meal_ingredient_row.dart';
part 'calendar_meal_picker_ingredient_chip.dart';
part 'calendar_divider_line.dart';
part 'calendar_protein_logo.dart';

typedef CalendarMealPickerOption = ({
  String id,
  String slot,
  String title,
  String imageAsset,
  String? imageUrl,
  String calories,
  String protein,
  String carbs,
  String fat,
  List<String> ingredients,
  bool selected,
  String? blockReason,
});

class CalendarMealPickerSheet extends StatefulWidget {
  const CalendarMealPickerSheet({
    super.key,
    this.restaurantName,
    this.restaurantLogoAsset,
    this.restaurantLogoUrl,
    this.restaurantInitials,
    this.restaurantRating,
    this.details,
    this.availableMeals,
    this.selectedMealIds = const [],
    this.onMealToggled,
    this.onSave,
    this.canSave = false,
    this.isSaving = false,
    this.failure,
  });

  final String? restaurantName;
  final String? restaurantLogoAsset;
  final String? restaurantLogoUrl;
  final String? restaurantInitials;
  final String? restaurantRating;
  final SubscriptionRestaurantDetailsEntity? details;
  final CalendarAvailableMealsEntity? availableMeals;
  final List<String> selectedMealIds;
  final ValueChanged<String>? onMealToggled;
  final VoidCallback? onSave;
  final bool canSave;
  final bool isSaving;
  final Failure? failure;

  @override
  State<CalendarMealPickerSheet> createState() =>
      CalendarMealPickerSheetState();
}

class CalendarMealPickerSheetState extends State<CalendarMealPickerSheet> {
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
    final apiSlots =
        availableMeals?.slotRequirements
            .map((requirement) => requirement.slot)
            .where((slot) => slot.isNotEmpty)
            .toList() ??
        const <String>[];
    final mealTabs = apiSlots.isNotEmpty
        ? apiSlots
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
    final options = availableMeals != null
        ? _optionsFromAvailableMeals(
            availableMeals.meals,
            mealTabs[selectedTab],
            locale.calendar_more,
          )
        : groups.isEmpty
        ? const <CalendarMealPickerOption>[]
        : _optionsFromGroup(
            groups[selectedTab],
            locale.localeName,
            locale.calendar_more,
          );

    return Material(
      color: color.surface,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          height: height,
          color: color.surface,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 221,
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
              CustomBackButton(onPressed: () => Navigator.pop(context)),
              Positioned(
                top: 189,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(31.2),
                  ),
                  child: ColoredBox(
                    color: color.surface,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: Spacing.lg),
                              const CalendarSheetHandle(),
                              const SizedBox(height: Spacing.md),
                              CalendarMealPickerRestaurantHeader(
                                restaurantName: restaurantName,
                                restaurantLogoAsset: widget.restaurantLogoAsset,
                                restaurantLogoUrl:
                                    widget.restaurantLogoUrl ??
                                    details?.logoUrl,
                                restaurantInitials: widget.restaurantInitials,
                              ),
                              const CalendarMealPickerRestaurantDescription(),
                              const CalendarDividerLine(),
                              CalendarSourceSection(
                                origins: details?.ingredientOrigins ?? const [],
                              ),
                              const SizedBox(height: Spacing.base),
                              CalendarMealTabs(
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
                              else
                                CalendarMealOptionsSection(
                                  mealType: mealTabs[selectedTab],
                                  tabIndex: selectedTab,
                                  options: options,
                                  onOptionSelected: availableMeals != null
                                      ? (index) => widget.onMealToggled?.call(
                                          options[index].id,
                                        )
                                      : groups.isEmpty
                                      ? null
                                      : (index) => _openMealDetails(
                                          groups[selectedTab].meals[index],
                                        ),
                                ),
                              if (widget.onSave != null) ...[
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
                              const SizedBox(height: Spacing.xxl),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMealDetails(SubscriptionRestaurantMealEntity meal) {
    final locale = context.localization;
    final details = widget.details;
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

  List<CalendarMealPickerOption> _optionsFromGroup(
    SubscriptionRestaurantMealGroupEntity group,
    String localeName,
    String moreLabel,
  ) {
    return group.meals.map((meal) {
      final ingredients = meal.ingredients
          .map((ingredient) => ingredient.name(localeName))
          .where((name) => name.isNotEmpty)
          .toList();
      final visibleIngredients = ingredients.length > 4
          ? [...ingredients.take(4), moreLabel]
          : ingredients;

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

  List<CalendarMealPickerOption> _optionsFromAvailableMeals(
    List<CalendarMealEntity> meals,
    String slot,
    String moreLabel,
  ) {
    return meals.where((meal) => meal.slot == slot).map((meal) {
      final ingredients = meal.ingredients.length > 4
          ? [...meal.ingredients.take(4), moreLabel]
          : meal.ingredients;

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
        ingredients: ingredients,
        selected: widget.selectedMealIds.contains(meal.id),
        blockReason: meal.blockReason,
      );
    }).toList();
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

  String _initials(String value) {
    final words = value.trim().split(RegExp(r'\s+'));
    if (words.isEmpty || words.first.isEmpty) return value;
    return words.take(3).map((word) => word.characters.first).join();
  }
}

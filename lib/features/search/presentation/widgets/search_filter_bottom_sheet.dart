import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/search/presentation/widgets/search_filter_range.dart';

class SearchFilterCriteria {
  const SearchFilterCriteria({
    required this.showMeals,
    required this.goalIndex,
    required this.calories,
    required this.protein,
    required this.preferences,
  });

  const SearchFilterCriteria.initial()
    : showMeals = true,
      goalIndex = 0,
      calories = const RangeValues(300, 800),
      protein = const RangeValues(10, 60),
      preferences = const [true, true, true];

  final bool showMeals;
  final int goalIndex;
  final RangeValues calories;
  final RangeValues protein;
  final List<bool> preferences;
}

class SearchFilterBottomSheet extends StatefulWidget {
  const SearchFilterBottomSheet({super.key, required this.initialCriteria});

  final SearchFilterCriteria initialCriteria;

  @override
  State<SearchFilterBottomSheet> createState() =>
      _SearchFilterBottomSheetState();
}

class _SearchFilterBottomSheetState extends State<SearchFilterBottomSheet> {
  late bool _showMeals;
  late int _goalIndex;
  late RangeValues _calories;
  late RangeValues _protein;
  late List<bool> _preferences;

  @override
  void initState() {
    super.initState();
    _showMeals = widget.initialCriteria.showMeals;
    _goalIndex = widget.initialCriteria.goalIndex;
    _calories = widget.initialCriteria.calories;
    _protein = widget.initialCriteria.protein;
    _preferences = List.of(widget.initialCriteria.preferences);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final goalLabels = [
      locale.health_goals_weight_loss,
      locale.search_filter_weight_gain,
      locale.dietary_preferences_diet_high_protein,
      locale.search_filter_muscle_gain,
    ];
    final preferenceLabels = [
      locale.dietary_preferences_allergy_lactose,
      locale.add_allergy_gluten,
      locale.dietary_preferences_allergy_nuts,
    ];

    return SafeArea(
      top: false,
      child: SizedBox(
        height: Spacing.searchFilterSheetHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.searchFilterSheetHorizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: Spacing.lg - Spacing.xs),
              Container(
                width: Spacing.searchFilterSheetHandleWidth,
                height: Spacing.searchFilterSheetHandleHeight,
                decoration: BoxDecoration(
                  color: color.outlineVariant,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
              const SizedBox(height: Spacing.lg - Spacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: color.primary,
                    size: Spacing.iconMd,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.search_filter_title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              SizedBox(
                height: Spacing.searchFilterSegmentHeight,
                child: Row(
                  children: [
                    for (final item in [
                      (
                        label: locale.search_filter_meals,
                        icon: Icons.ramen_dining_rounded,
                      ),
                      (
                        label: locale.search_filter_restaurants,
                        icon: Icons.storefront_rounded,
                      ),
                    ])
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(
                            () => _showMeals =
                                item.icon == Icons.ramen_dining_rounded,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  (_showMeals ==
                                      (item.icon == Icons.ramen_dining_rounded))
                                  ? color.primary
                                  : color.surface,
                              borderRadius: BorderRadius.circular(Spacing.md),
                              boxShadow: [
                                BoxShadow(
                                  color: color.shadow.withValues(alpha: .08),
                                  blurRadius: Spacing.xss,
                                  offset: const Offset(0, Spacing.xs / 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  item.icon,
                                  size: Spacing.iconSm,
                                  color:
                                      (_showMeals ==
                                          (item.icon ==
                                              Icons.ramen_dining_rounded))
                                      ? color.onPrimary
                                      : color.primary,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Text(
                                  item.label,
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size10,
                                    color:
                                        (_showMeals ==
                                            (item.icon ==
                                                Icons.ramen_dining_rounded))
                                        ? color.onPrimary
                                        : color.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: Spacing.sm),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.lg + Spacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: Spacing.iconSm,
                      color: color.primary,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.search_filter_programs,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.md),
              SizedBox(
                height: Spacing.searchFilterOptionHeight,
                child: Row(
                  children: List.generate(goalLabels.length, (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: index == goalLabels.length - 1
                              ? 0
                              : Spacing.searchFilterGoalGap,
                        ),
                        child: GestureDetector(
                          onTap: () => setState(() => _goalIndex = index),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color.surface,
                              border: Border.all(color: color.outlineVariant),
                              borderRadius: BorderRadius.circular(Spacing.md),
                              boxShadow: [
                                BoxShadow(
                                  color: color.shadow.withValues(alpha: .05),
                                  blurRadius: Spacing.sm,
                                  offset: const Offset(0, Spacing.xss),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  index == 0
                                      ? Icons.local_fire_department_rounded
                                      : index == 3
                                      ? Icons.fitness_center_rounded
                                      : Icons.sports_gymnastics_rounded,
                                  size: Spacing.iconSm,
                                  color: index == 0
                                      ? color.secondary
                                      : color.primary,
                                ),
                                const SizedBox(width: Spacing.xs),
                                Flexible(
                                  child: Text(
                                    goalLabels[index],
                                    overflow: TextOverflow.ellipsis,
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size9,
                                      color: color.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: Spacing.searchFilterSectionGap),
              SearchFilterRange(
                label: locale.calendar_calories,
                icon: Icons.local_fire_department_rounded,
                range: _calories,
                min: 300,
                max: 800,
                unit: locale.search_filter_calories_unit,
                onChanged: (value) => setState(() => _calories = value),
              ),
              const SizedBox(height: Spacing.searchFilterDividerGap),
              SearchFilterRange(
                label: locale.calendar_protein,
                icon: Icons.fitness_center_rounded,
                range: _protein,
                min: 10,
                max: 60,
                unit: locale.search_filter_grams_unit,
                onChanged: (value) => setState(() => _protein = value),
              ),
              const SizedBox(height: Spacing.lg - Spacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  locale.search_filter_allergy_suitable,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: List.generate(preferenceLabels.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: index == preferenceLabels.length - 1
                            ? 0
                            : Spacing.searchFilterGoalGap,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(
                          () => _preferences[index] = !_preferences[index],
                        ),
                        child: Container(
                          height: Spacing.searchFilterPreferenceHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color.primaryContainer,
                            border: Border.all(color: color.outlineVariant),
                            borderRadius: BorderRadius.circular(Spacing.lg),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _preferences[index]
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                size: Spacing.iconSm,
                                color: color.primary,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Flexible(
                                child: Text(
                                  preferenceLabels[index],
                                  overflow: TextOverflow.ellipsis,
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size9,
                                    color: color.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _apply,
                      icon: const Icon(
                        Icons.check_rounded,
                        size: Spacing.iconMd,
                      ),
                      label: Text(
                        locale.search_filter_apply,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onPrimary,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          Spacing.searchFilterActionHeight,
                        ),
                        backgroundColor: color.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.searchFilterGoalGap),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: Icon(
                        Icons.refresh_rounded,
                        size: Spacing.iconMd,
                        color: color.primary,
                      ),
                      label: Text(
                        locale.search_filter_reset,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.primary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(
                          Spacing.searchFilterActionHeight,
                        ),
                        side: BorderSide(color: color.outlineVariant),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
            ],
          ),
        ),
      ),
    );
  }

  void _reset() {
    setState(() {
      _showMeals = true;
      _goalIndex = 0;
      _calories = const RangeValues(300, 800);
      _protein = const RangeValues(10, 60);
      _preferences.setAll(0, List<bool>.filled(_preferences.length, true));
    });
  }

  void _apply() {
    Navigator.pop(
      context,
      SearchFilterCriteria(
        showMeals: _showMeals,
        goalIndex: _goalIndex,
        calories: _calories,
        protein: _protein,
        preferences: List.unmodifiable(_preferences),
      ),
    );
  }
}

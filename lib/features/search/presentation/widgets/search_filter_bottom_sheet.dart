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
      locale.dietary_preferences_diet_high_protein,
      locale.health_goals_activity_high,
      locale.health_goals_activity_active,
    ];
    final preferenceLabels = [
      locale.dietary_preferences_allergy_lactose,
      locale.add_allergy_gluten,
      locale.dietary_preferences_allergy_nuts,
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: Spacing.searchFilterSheetHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.searchFilterSheetHorizontalPadding,
            ),
            child: Column(
              children: [
                const SizedBox(height: Spacing.xs),
                Container(
                  width: Spacing.searchFilterSheetHandleWidth,
                  height: Spacing.searchFilterSheetHandleHeight,
                  decoration: BoxDecoration(
                    color: color.outlineVariant,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      color: color.primary,
                      size: Spacing.iconMd,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.search_quick_results,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                SizedBox(
                  height: Spacing.searchFilterSegmentHeight + Spacing.xss,
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
                                        (item.icon ==
                                            Icons.ramen_dining_rounded))
                                    ? color.primary
                                    : color.surface,
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusXs,
                                ),
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
                                      fontFamily:
                                          FontConstant.ibmPlexSansArabic,
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
                const SizedBox(height: Spacing.md),
                Align(
                  alignment: Alignment.centerRight,
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
                        locale.subscription_selected_program_label,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size11,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                SizedBox(
                  height: Spacing.searchFilterOptionHeight,
                  child: ListView.separated(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: goalLabels.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: Spacing.sm),
                    itemBuilder: (context, index) {
                      final selected = _goalIndex == index;
                      return ChoiceChip(
                        selected: selected,
                        onSelected: (_) => setState(() => _goalIndex = index),
                        label: Text(goalLabels[index]),
                        avatar: Icon(
                          index == 0
                              ? Icons.local_fire_department_rounded
                              : Icons.fitness_center_rounded,
                          size: Spacing.iconSm,
                          color: selected ? color.onPrimary : color.primary,
                        ),
                        labelStyle: getMediumStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size9,
                          color: selected ? color.onPrimary : color.onSurface,
                        ),
                        selectedColor: color.primary,
                        backgroundColor: color.surface,
                        side: BorderSide(color: color.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Spacing.radiusSm),
                        ),
                        visualDensity: VisualDensity.compact,
                      );
                    },
                  ),
                ),
                const SizedBox(height: Spacing.md),
                SearchFilterRange(
                  label: locale.calendar_calories,
                  icon: Icons.local_fire_department_rounded,
                  range: _calories,
                  min: 300,
                  max: 800,
                  onChanged: (value) => setState(() => _calories = value),
                ),
                const SizedBox(height: Spacing.sm),
                SearchFilterRange(
                  label: locale.calendar_protein,
                  icon: Icons.fitness_center_rounded,
                  range: _protein,
                  min: 10,
                  max: 60,
                  onChanged: (value) => setState(() => _protein = value),
                ),
                const SizedBox(height: Spacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    locale.dietary_preferences_allergies_title,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size11,
                      color: color.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: Spacing.sm,
                  runSpacing: Spacing.sm,
                  children: List.generate(preferenceLabels.length, (index) {
                    return FilterChip(
                      selected: _preferences[index],
                      onSelected: (value) =>
                          setState(() => _preferences[index] = value),
                      label: Text(preferenceLabels[index]),
                      avatar: Icon(
                        _preferences[index]
                            ? Icons.check_circle_rounded
                            : Icons.circle_outlined,
                        size: Spacing.iconSm,
                        color: color.primary,
                      ),
                      labelStyle: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size9,
                        color: color.onSurface,
                      ),
                      backgroundColor: color.surface,
                      selectedColor: color.primaryContainer,
                      side: BorderSide(color: color.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      visualDensity: VisualDensity.compact,
                    );
                  }),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _reset,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: Spacing.iconMd,
                          color: color.primary,
                        ),
                        label: Text(
                          locale.auth_reset_password_title,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
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
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _apply,
                        icon: const Icon(
                          Icons.check_rounded,
                          size: Spacing.iconMd,
                        ),
                        label: Text(
                          locale.add_allergy_save,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
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
                  ],
                ),
                const SizedBox(height: Spacing.sm),
              ],
            ),
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

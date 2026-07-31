import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeTodayMeals extends StatelessWidget {
  const HomeTodayMeals({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final meals = [
      (
        Assets.homeOmelet,
        locale.calendar_breakfast,
        locale.home_meal_omelet_vegetables,
        locale.home_meal_omelet_calories,
        color.primary,
        Icons.wb_sunny_rounded,
      ),
      (
        Assets.homeLunch,
        locale.calendar_lunch,
        locale.search_meal_title,
        locale.home_meal_chicken_calories,
        color.secondary,
        Icons.wb_sunny_rounded,
      ),
      (
        Assets.homeSalmon,
        locale.calendar_dinner,
        locale.home_meal_herb_salmon,
        locale.home_meal_salmon_calories,
        color.primary,
        Icons.nightlight_round,
      ),
      (
        Assets.homeBreakfast,
        locale.calendar_breakfast,
        locale.search_meal_title,
        locale.home_meal_chicken_calories,
        color.primary,
        Icons.wb_sunny_rounded,
      ),
    ];
    return SizedBox(
      width: double.infinity,
      height: Spacing.homeTodayMealsHeight,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.homeFigmaBackgroundDoodleImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [color.surface.withValues(alpha: 0), color.surface],
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: Spacing.homeTodayMealsTitleTop,
              start: Spacing.screenH,
              child: Text(
                title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size20,
                  color: color.onPrimary,
                ),
              ),
            ),
            PositionedDirectional(
              top: Spacing.homeTodayMealsListTop,
              start: 0,
              end: 0,
              child: SizedBox(
                height: Spacing.homeMealCardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenH,
                  ),
                  itemCount: meals.length,
                  separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
                  itemBuilder: (_, index) {
                    final meal = meals[index];
                    return SizedBox(
                      width: Spacing.homeMealCardWidth,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.surface,
                          borderRadius: BorderRadius.circular(
                            Spacing.homeMealCardRadius,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.shadow.withValues(alpha: 0.12),
                              blurRadius: Spacing.sm,
                              offset: const Offset(0, Spacing.xs),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(Spacing.xs),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Spacing.homeMealImageRadius,
                                ),
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      meal.$1,
                                      width: double.infinity,
                                      height: Spacing.homeMealCardImageHeight,
                                      fit: BoxFit.cover,
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Padding(
                                        padding: const EdgeInsets.all(
                                          Spacing.xs,
                                        ),
                                        child: Container(
                                          height: Spacing.homeMealBadgeHeight,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Spacing.sm,
                                          ),
                                          decoration: BoxDecoration(
                                            color: meal.$5,
                                            borderRadius: BorderRadius.circular(
                                              Spacing.radiusPill,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                meal.$6,
                                                size: Spacing
                                                    .homeMealBadgeIconSize,
                                                color: color.onPrimary,
                                              ),
                                              const SizedBox(width: Spacing.xs),
                                              Text(
                                                meal.$2,
                                                style: getBoldStyle(
                                                  fontFamily:
                                                      FontConstant.alexandria,
                                                  fontSize: FontSize.size8,
                                                  color: color.onPrimary,
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
                            const SizedBox(height: Spacing.xs),
                            Text(
                              meal.$3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.onSurface,
                              ),
                            ),
                            Text(
                              meal.$4,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size8,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      ),
      (
        Assets.homeLunch,
        locale.calendar_lunch,
        locale.search_meal_title,
        locale.home_meal_chicken_calories,
      ),
      (
        Assets.homeSalmon,
        locale.calendar_dinner,
        locale.home_meal_herb_salmon,
        locale.home_meal_salmon_calories,
      ),
      (
        Assets.homeBreakfast,
        locale.calendar_breakfast,
        locale.search_meal_title,
        locale.home_meal_chicken_calories,
      ),
    ];
    return Stack(
      children: [
        //  Positioned.fill(child: ColoredBox(color: color.primary)),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.screenH,
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.sm),
                child: Text(
                  title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size18,
                    color: color.onPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.xs),
            SizedBox(
              height: Spacing.homeMealCardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                ),
                itemCount: meals.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: Spacing.sm),
                itemBuilder: (_, index) {
                  final meal = meals[index];
                  return SizedBox(
                    width: Spacing.homeMealCardWidth,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(meal.$1, fit: BoxFit.cover),
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Container(
                                    margin: const EdgeInsets.all(
                                      Spacing.xs,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Spacing.xs,
                                    ),
                                    decoration: BoxDecoration(
                                      color: color.primary,
                                      borderRadius: BorderRadius.circular(
                                        Spacing.radiusPill,
                                      ),
                                    ),
                                    child: Text(
                                      meal.$2,
                                      style: getBoldStyle(
                                        fontFamily: FontConstant.alexandria,
                                        fontSize: FontSize.size8,
                                        color: color.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
          ],
        ),
      ],
    );
  }
}

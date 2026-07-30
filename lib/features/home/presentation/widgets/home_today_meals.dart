import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeTodayMeals extends StatelessWidget {
  const HomeTodayMeals({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    const meals = [
      (Assets.homeOmelet, 'الفطور', 'أومليت بالخضار', '430 سعرة'),
      (Assets.homeLunch, 'الغداء', 'دجاج مشوي مع كينوا', '650 سعرة'),
      (Assets.homeSalmon, 'العشاء', 'سلمون بالأعشاب', '520 سعرة'),
      (Assets.homeBreakfast, 'الفطور', 'دجاج مشوي مع كينوا', '650 سعرة'),
    ];
    return Container(
      color: color.primary,
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.homeHorizontalPadding,
            ),
            child: Text(
              title,
              style: AppTextStyles.h4.copyWith(color: color.onPrimary),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          SizedBox(
            height: Spacing.homeMealCardHeight,
            child: ListView.separated(
              reverse: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.homeHorizontalPadding,
              ),
              itemCount: meals.length,
              separatorBuilder: (_, _) => const SizedBox(width: Spacing.sm),
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
                                alignment: AlignmentDirectional.topEnd,
                                child: Container(
                                  margin: const EdgeInsets.all(Spacing.xs),
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
                                    style: AppTextStyles.overline.copyWith(
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
                          style: AppTextStyles.caption.copyWith(
                            color: color.onSurface,
                          ),
                        ),
                        Text(
                          meal.$4,
                          style: AppTextStyles.overline.copyWith(
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
    );
  }
}

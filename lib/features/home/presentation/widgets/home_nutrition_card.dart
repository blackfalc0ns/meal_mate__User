import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/text_styles.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class HomeNutritionCard extends StatelessWidget {
  const HomeNutritionCard({
    super.key,
    required this.title,
    required this.calories,
    required this.remainingLabel,
    required this.goalLabel,
    required this.detailsLabel,
  });
  final String title, calories, remainingLabel, goalLabel, detailsLabel;
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return SizedBox(
      height: Spacing.homeNutritionHeight,
      child: Card(
        color: color.primaryContainer,
        clipBehavior: Clip.antiAlias,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Semantics(
            label: locale.home_main_nutrients,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: color.primary,
                    child: Center(
                      child: Text(
                        calories,
                        style: AppTextStyles.h1.copyWith(
                          color: color.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(Spacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.labelLarge.copyWith(
                            color: color.primary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          remainingLabel,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: color.onSurface,
                          ),
                        ),
                        Text(
                          goalLabel,
                          style: AppTextStyles.caption.copyWith(
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            detailsLabel,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: color.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

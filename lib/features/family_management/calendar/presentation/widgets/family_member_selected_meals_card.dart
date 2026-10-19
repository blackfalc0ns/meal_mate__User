import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_member_calendar_entity.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/family_member_selected_meal_item.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/widgets/staggered_slide_item.dart';

class FamilyMemberSelectedMealsCard extends StatelessWidget {
  const FamilyMemberSelectedMealsCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.countLabel,
    required this.meals,
  });

  final String title;
  final String subtitle;
  final String countLabel;
  final List<FamilyCalendarSelectedMealEntity> meals;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(
          Spacing.familyMemberCalendarSelectedMealsRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          Spacing.familyMemberCalendarSelectedMealsPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.date_range_rounded,
                  size: Spacing.iconSm,
                  color: color.primary,
                ),
                const SizedBox(width: Spacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        locale: Locale(locale.localeName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),
                      Text(
                        subtitle,
                        locale: Locale(locale.localeName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: 4,
                    ),
                    child: Text(
                      countLabel,
                      locale: Locale(locale.localeName),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.xs),
            if (meals.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                child: Center(
                  child: Text(
                    locale.family_member_no_meals_selected,
                    locale: Locale(locale.localeName),
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              )
            else
              for (var index = 0; index < meals.length; index++)
                StaggeredSlideItem(
                  key: ValueKey('${meals[index].name}_$index'),
                  index: index,
                  child: FamilyMemberSelectedMealItem(
                    meal: meals[index],
                    showDivider: index < meals.length - 1,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

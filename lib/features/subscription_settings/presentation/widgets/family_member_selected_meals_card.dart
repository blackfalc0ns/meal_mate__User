import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_selected_meal_item.dart';

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

    return SizedBox(
      height: Spacing.familyMemberCalendarSelectedMealsHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(color: color.outline),
          borderRadius: BorderRadius.circular(
            Spacing.familyMemberCalendarSelectedMealsRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            Spacing.familyMemberCalendarSelectedMealsPadding,
          ),
          child: Column(
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
                        const SizedBox(height: Spacing.xs),
                        Text(
                          subtitle,
                          locale: Locale(locale.localeName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Spacing.familyMemberCalendarCountPillWidth,
                    height: Spacing.familyMemberCalendarCountPillHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: color.primaryContainer,
                        border: Border.all(color: color.primaryContainer),
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Center(
                        child: Text(
                          countLabel,
                          locale: Locale(locale.localeName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size8,
                            color: color.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              for (var index = 0; index < meals.length; index++)
                FamilyMemberSelectedMealItem(
                  meal: meals[index],
                  showDivider: index < meals.length - 1,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

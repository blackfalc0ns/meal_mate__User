import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_member_calendar_entity.dart';

class FamilyMemberSelectedMealItem extends StatelessWidget {
  const FamilyMemberSelectedMealItem({
    super.key,
    required this.meal,
    required this.showDivider,
  });

  final FamilyCalendarSelectedMealEntity meal;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final Color tagBgColor;
    final Color tagTextColor;

    final typeLower = meal.typeLabel.toLowerCase();
    if (typeLower.contains('فطور') || typeLower.contains('breakfast')) {
      tagBgColor = color.secondaryContainer;
      tagTextColor = color.secondary;
    } else if (typeLower.contains('عشاء') || typeLower.contains('dinner')) {
      tagBgColor = color.tertiaryContainer;
      tagTextColor = color.onTertiaryContainer;
    } else {
      tagBgColor = color.primaryContainer;
      tagTextColor = color.primary;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.xs),
          child: Row(
            children: [
              AppCachedNetworkImage(
                imageUrl: meal.imageUrl,
                width: Spacing.familyMemberCalendarSelectedMealImageSize,
                height: Spacing.familyMemberCalendarSelectedMealImageSize,
                borderRadius: BorderRadius.circular(
                  Spacing.familyMemberCalendarSelectedMealImageRadius,
                ),
                fit: BoxFit.cover,
                errorWidget: meal.imageAsset.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Spacing.familyMemberCalendarSelectedMealImageRadius,
                        ),
                        child: Image.asset(
                          meal.imageAsset,
                          width:
                              Spacing.familyMemberCalendarSelectedMealImageSize,
                          height:
                              Spacing.familyMemberCalendarSelectedMealImageSize,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width:
                            Spacing.familyMemberCalendarSelectedMealImageSize,
                        height:
                            Spacing.familyMemberCalendarSelectedMealImageSize,
                        decoration: BoxDecoration(
                          color: color.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            Spacing.familyMemberCalendarSelectedMealImageRadius,
                          ),
                        ),
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: color.onSurfaceVariant,
                          size: Spacing.iconMd,
                        ),
                      ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: tagBgColor,
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusPill,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                              vertical: 2,
                            ),
                            child: Text(
                              meal.typeLabel,
                              locale: Locale(locale.localeName),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size9,
                                color: tagTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Flexible(
                          child: Text(
                            meal.name,
                            locale: Locale(locale.localeName),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xxs),
                    Text(
                      meal.description,
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
              const SizedBox(width: Spacing.sm),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.05),
                  border: Border.all(
                    color: color.primary.withValues(alpha: 0.35),
                  ),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: Spacing.iconSm,
                        color: color.primary,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        meal.chosenLabel,
                        locale: Locale(locale.localeName),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: Spacing.sm,
            thickness: Spacing.border,
            color: color.outlineVariant.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_meal_entity.dart';

class FamilyReviewMealSlotCard extends StatelessWidget {
  const FamilyReviewMealSlotCard({
    super.key,
    required this.meal,
    required this.restaurantName,
    required this.onEdit,
  });

  final CalendarMealEntity meal;
  final String restaurantName;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final (slotIcon, slotColor, slotLabel) = _resolveSlotInfo(color, locale);

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
            child: (meal.imageUrl != null && meal.imageUrl!.isNotEmpty)
                ? AppCachedNetworkImage(
                    imageUrl: meal.imageUrl!,
                    width: 54.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  )
                : (meal.imageAsset.isNotEmpty
                      ? Image.asset(
                          meal.imageAsset,
                          width: 54.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 54.0,
                          height: 50.0,
                          color: color.surfaceContainerHighest,
                          child: Icon(
                            Icons.restaurant_rounded,
                            color: color.onSurfaceVariant,
                            size: Spacing.iconMd,
                          ),
                        )),
          ),
          const SizedBox(width: Spacing.xs),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(slotIcon, size: 14.0, color: slotColor),
              const SizedBox(height: Spacing.xxs / 2),
              Text(
                slotLabel,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size8,
                  color: slotColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  meal.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs / 2),
                Text(
                  restaurantName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.xs),
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(Spacing.radiusXs),
            child: Container(
              width: 35.0,
              height: 38.0,
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(Spacing.radiusXs),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit_outlined, size: 14.0, color: color.primary),
                  const SizedBox(height: Spacing.xxs / 2),
                  Text(
                    locale.family_review_edit_button,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color, String) _resolveSlotInfo(
    ColorScheme color,
    AppLocalizations locale,
  ) {
    final s = meal.slot.trim().toLowerCase();
    if (s == 'breakfast' || s == 'إفطار' || s == 'الإفطار') {
      return (
        Icons.wb_sunny_rounded,
        color.primary,
        locale.family_slot_breakfast,
      );
    } else if (s == 'lunch' || s == 'غداء' || s == 'الغداء') {
      return (
        Icons.wb_sunny_rounded,
        color.secondary,
        locale.family_slot_lunch,
      );
    } else if (s == 'dinner' || s == 'عشاء' || s == 'العشاء') {
      return (
        Icons.nightlight_round,
        color.tertiary,
        locale.family_slot_dinner,
      );
    } else if (s == 'snack' || s == 'سناك') {
      return (Icons.cookie_outlined, color.tertiary, locale.family_slot_snack);
    }
    return (
      Icons.restaurant_rounded,
      color.primary,
      meal.slot.isNotEmpty ? meal.slot : meal.mealType,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.sm),
      padding: const EdgeInsets.all(Spacing.md),
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
                    width: Spacing.avatarMd,
                    height: Spacing.avatarMd,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: Spacing.avatarMd,
                    height: Spacing.avatarMd,
                    color: color.surfaceContainerHighest,
                    child: Icon(
                      Icons.fastfood_rounded,
                      color: color.onSurfaceVariant,
                      size: Spacing.iconMd,
                    ),
                  ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xs / 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Text(
                    meal.slot.isNotEmpty ? meal.slot : meal.mealType,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.primary,
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.xs / 2),
                Text(
                  meal.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs / 4),
                Text(
                  restaurantName,
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
          InkWell(
            onTap: onEdit,
            borderRadius: BorderRadius.circular(Spacing.radiusPill),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.sm,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: Spacing.iconSm * 0.8,
                    color: color.primary,
                  ),
                  const SizedBox(width: Spacing.xs / 2),
                  Text(
                    locale.family_review_edit_button,
                    style: getMediumStyle(
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
    );
  }
}

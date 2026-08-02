import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyFridayDeliveryCard extends StatelessWidget {
  const FamilyFridayDeliveryCard({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return InkWell(
      onTap: () => onChanged(!selected),
      borderRadius: BorderRadius.circular(Spacing.sm),
      child: Container(
        height: Spacing.familyFridayCardHeight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        decoration: BoxDecoration(
          color: color.surface,
          border: Border.all(color: color.outlineVariant),
          borderRadius: BorderRadius.circular(Spacing.sm),
        ),
        child: Row(
          children: [
            Container(
              width: Spacing.iconMd,
              height: Spacing.iconMd,
              decoration: BoxDecoration(
                color: selected ? color.primary : color.surface,
                borderRadius: BorderRadius.circular(Spacing.xs),
                border: Border.all(color: color.primary),
              ),
              child: selected
                  ? Icon(
                      Icons.check_rounded,
                      color: color.onPrimary,
                      size: Spacing.iconMd,
                    )
                  : null,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.family_friday_delivery_title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurface,
                    ),
                  ),
                                    const SizedBox(height: Spacing.xs),

                  Text(
                    locale.family_friday_delivery_subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

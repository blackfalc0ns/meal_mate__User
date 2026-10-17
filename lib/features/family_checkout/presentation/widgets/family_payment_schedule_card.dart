import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyPaymentScheduleCard extends StatelessWidget {
  const FamilyPaymentScheduleCard({
    super.key,
    required this.title,
    required this.dateText,
    this.isEditable = false,
    this.onTap,
  });

  final String title;
  final String dateText;
  final bool isEditable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final cardContent = Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.xxs,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            border: Border.all(
              color: color.primary.withValues(alpha: 0.3),
              width: Spacing.border,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: Spacing.iconXs,
                    color: color.primary,
                  ),
                  const SizedBox(width: Spacing.xxs),
                  Flexible(
                    child: Text(
                      title,
                      style: getMediumStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xs),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xs,
                  vertical: Spacing.xxs,
                ),
                decoration: BoxDecoration(
                  color: color.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Spacing.buttonRadius),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    dateText,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.primary,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isEditable)
          PositionedDirectional(
            top: Spacing.xs,
            end: Spacing.xs,
            child: Container(
              padding: const EdgeInsets.all(Spacing.xxs),
              decoration: BoxDecoration(
                color: color.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_rounded,
                size: Spacing.iconXs,
                color: color.primary,
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Spacing.cardRadius),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}

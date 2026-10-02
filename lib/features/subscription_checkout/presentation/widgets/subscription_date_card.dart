import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionDateCard extends StatelessWidget {
  const SubscriptionDateCard({
    super.key,
    required this.label,
    required this.date,
    this.isEditable = false,
    this.onTap,
  });

  final String label;
  final String date;
  final bool isEditable;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    final content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xss,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(
          color: isEditable ? color.primary : color.outlineVariant,
          width: Spacing.border,
        ),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: Spacing.iconXs,
                color: color.primary,
              ),

              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),

              if (isEditable) ...[
                Container(
                  width: Spacing.iconSm,
                  height: Spacing.iconSm,
                  decoration: BoxDecoration(
                    color: color.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.edit_rounded,
                    size: Spacing.iconXs - Spacing.xxs,
                    color: color.primary,
                  ),
                ),
                const SizedBox(width: Spacing.xxs),
              ],
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: Spacing.xxs,
              horizontal: Spacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(Spacing.radiusSm),
            ),
            alignment: Alignment.center,
            child: Text(
              date,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(Spacing.radiusMd),
          onTap: onTap,
          child: content,
        ),
      );
    }

    return content;
  }
}

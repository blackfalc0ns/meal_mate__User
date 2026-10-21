import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class RedeemPackageDateCard extends StatelessWidget {
  const RedeemPackageDateCard({
    super.key,
    required this.selectedDate,
    required this.onTapChangeDate,
    this.includeFriday,
    this.onToggleFriday,
  });

  final String selectedDate;
  final VoidCallback onTapChangeDate;
  final bool? includeFriday;
  final ValueChanged<bool>? onToggleFriday;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      margin: const EdgeInsets.only(bottom: Spacing.md),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusLg),
        border: Border.all(
          color: color.outlineVariant.withValues(alpha: 0.5),
          width: Spacing.border,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTapChangeDate,
            borderRadius: BorderRadius.circular(Spacing.radiusMd),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: color.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        locale.subscription_start_date_picker_label,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selectedDate,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_calendar_rounded,
                  size: 18,
                  color: color.primary,
                ),
              ],
            ),
          ),
          if (includeFriday != null && onToggleFriday != null) ...[
            Divider(
              height: Spacing.lg,
              color: color.outlineVariant.withValues(alpha: 0.4),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  locale.subscription_add_friday,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                Switch.adaptive(
                  value: includeFriday!,
                  activeTrackColor: color.primary,
                  onChanged: onToggleFriday,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

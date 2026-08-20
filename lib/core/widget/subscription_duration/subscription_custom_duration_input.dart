import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionCustomDurationInput extends StatelessWidget {
  const SubscriptionCustomDurationInput({
    super.key,
    required this.label,
    required this.isSelected,
    required this.value,
    required this.minDays,
    required this.maxDays,
    required this.errorText,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  final String label;
  final bool isSelected;
  final int value;
  final int minDays;
  final int maxDays;
  final String? errorText;
  final VoidCallback onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: Spacing.monthlyPlanDurationCustomGroupWidth,
      child: Column(
        children: [
          SizedBox(
            width: Spacing.monthlyPlanCustomDurationWidth,
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: Spacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _customControl(
                color: color,
                icon: Icons.add_rounded,
                onPressed: onIncrement,
              ),
              SizedBox(
                width: Spacing.monthlyPlanCustomDurationWidth,
                height: Spacing.monthlyPlanDurationCustomInputHeight,
                child: OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(
                      color: isSelected ? color.primary : color.outlineVariant,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.monthlyPlanDurationOptionRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    value.toString(),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size15,
                      color: isSelected ? color.primary : color.onSurface,
                    ),
                  ),
                ),
              ),
              _customControl(
                color: color,
                icon: Icons.remove_rounded,
                onPressed: onDecrement,
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            errorText ?? locale.subscription_days_range_hint(minDays, maxDays),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size8,
              color: errorText == null ? color.onSurfaceVariant : color.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _customControl({
    required ColorScheme color,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: Spacing.monthlyPlanDurationControlWidth,
      height: Spacing.monthlyPlanDurationControlWidth,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: Spacing.monthlyPlanDurationControlWidth,
          height: Spacing.monthlyPlanDurationControlWidth,
        ),
        icon: Icon(
          icon,
          color: onPressed == null ? color.outline : color.onSurface,
          size: Spacing.monthlyPlanDurationControlSize,
        ),
      ),
    );
  }
}

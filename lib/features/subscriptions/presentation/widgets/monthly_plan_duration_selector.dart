import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/monthly_plan_duration_option_card.dart';

class MonthlyPlanDurationSelector extends StatelessWidget {
  const MonthlyPlanDurationSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.includesFriday,
    required this.onFridayChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final bool includesFriday;
  final ValueChanged<bool> onFridayChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final options = [
      _DurationOption(
        label: locale.subscription_month_period,
        duration: locale.subscription_month_duration,
      ),
      _DurationOption(
        label: locale.subscription_half_month_period,
        duration: locale.subscription_half_month_duration,
      ),
      _DurationOption(
        label: locale.subscription_week_period,
        duration: locale.subscription_week_duration,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.sm,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                locale.subscription_choose_plan_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size14,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(width: Spacing.xs),
              Icon(
                Icons.calendar_month_outlined,
                size: Spacing.iconMd,
                color: color.primary,
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              for (var index = 0; index < options.length; index++) ...[
                Expanded(
                  child: MonthlyPlanDurationOptionCard(
                    label: options[index].label,
                    duration: options[index].duration,
                    isSelected: index == selectedIndex,
                    onTap: () => onSelected(index),
                  ),
                ),
                if (index != options.length - 1)
                  const SizedBox(width: Spacing.sm),
              ],
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locale.calendar_friday,
                  style: getMediumStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Spacing.xs),
                Checkbox(
                  value: includesFriday,
                  onChanged: (value) => onFridayChanged(value ?? false),
                  activeColor: color.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DurationOption {
  const _DurationOption({required this.label, required this.duration});

  final String label;
  final String duration;
}

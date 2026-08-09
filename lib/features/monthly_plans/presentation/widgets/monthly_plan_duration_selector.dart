import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_duration_option.dart';

class MonthlyPlanDurationSelector extends StatefulWidget {
  const MonthlyPlanDurationSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.includesFriday,
    required this.onFridayChanged,
  });

  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final bool includesFriday;
  final ValueChanged<bool> onFridayChanged;

  @override
  State<MonthlyPlanDurationSelector> createState() =>
      _MonthlyPlanDurationSelectorState();
}

class _MonthlyPlanDurationSelectorState
    extends State<MonthlyPlanDurationSelector> {
  int _customDays = 30;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Center(
      child: SizedBox(
        width: Spacing.monthlyPlanDurationCardWidth,
        height: Spacing.monthlyPlanDurationHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.surface,
            border: Border.all(color: color.outlineVariant),
            borderRadius: BorderRadius.circular(
              Spacing.monthlyPlanDurationCardRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.15),
                blurRadius: Spacing.xs,
                offset: const Offset(0, Spacing.xs),
              ),
            ],
          ),
          child: Stack(
            children: [
              PositionedDirectional(
                top: Spacing.monthlyPlanDurationHeaderTop,
                start: Spacing.monthlyPlanDurationHeaderEnd,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      color: color.primary,
                      size: Spacing.lg,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.subscription_duration_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              _option(
                start: Spacing.monthlyPlanDurationMonthOptionLeft,
                label: locale.subscription_month_period,
                days: 26,
                index: 0,
              ),
              _option(
                start: Spacing.monthlyPlanDurationHalfMonthOptionLeft,
                label: locale.subscription_half_month_period,
                days: 12,
                index: 1,
              ),
              _option(
                start: Spacing.monthlyPlanDurationWeekOptionLeft,
                label: locale.subscription_week_period,
                days: 6,
                index: 2,
              ),
              Positioned(
                left: Spacing.monthlyPlanDurationCustomInputLeft,
                top: Spacing.monthlyPlanDurationOptionTop,
                width: Spacing.monthlyPlanCustomDurationWidth,
                child: Text(
                  locale.subscription_custom_duration,
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
              Positioned(
                left: Spacing.monthlyPlanDurationCustomInputLeft,
                top: Spacing.monthlyPlanDurationControlTop,
                width: Spacing.monthlyPlanCustomDurationWidth,
                height: Spacing.monthlyPlanDurationCustomInputHeight,
                child: OutlinedButton(
                  onPressed: () => widget.onSelected(3),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: BorderSide(color: color.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.monthlyPlanDurationOptionRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    '$_customDays',
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size15,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ),
              _customControl(
                start: Spacing.monthlyPlanDurationMinusLeft,
                icon: Icons.remove_rounded,
                onPressed: _customDays > 1
                    ? () => setState(() => _customDays--)
                    : null,
              ),
              _customControl(
                start: Spacing.monthlyPlanDurationPlusLeft,
                icon: Icons.add_rounded,
                onPressed: _customDays < 30
                    ? () => setState(() => _customDays++)
                    : null,
              ),
              Positioned(
                top: Spacing.monthlyPlanDurationHintTop,
                left: Spacing.monthlyPlanDurationMinusLeft,
                width: Spacing.monthlyPlanDurationCustomGroupWidth,
                child: Center(
                  child: Text(
                    locale.subscription_days_range_hint,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size8,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Spacing.monthlyPlanDurationFridayTop,
                left: 0,
                right: 0,
                child: Center(
                  child: InkWell(
                    onTap: () => widget.onFridayChanged(!widget.includesFriday),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutBack,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: Icon(
                            widget.includesFriday
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            key: ValueKey(widget.includesFriday),
                            color: widget.includesFriday
                                ? color.primary
                                : color.outline,
                            size: Spacing.monthlyPlanDurationControlSize,
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.subscription_add_friday,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _option({
    required double start,
    required String label,
    required int days,
    required int index,
  }) {
    return Positioned(
      left: start,
      top: Spacing.monthlyPlanDurationOptionTop,
      width: Spacing.monthlyPlanDurationOptionWidth,
      child: MonthlyPlanDurationOption(
        label: label,
        days: days,
        isSelected: widget.selectedIndex == index,
        onTap: () => widget.onSelected(index),
      ),
    );
  }

  Widget _customControl({
    required double start,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Positioned(
      left: start,
      top: Spacing.monthlyPlanDurationControlTop,
      width: Spacing.monthlyPlanDurationControlWidth,
      height: Spacing.monthlyPlanDurationControlWidth,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: Spacing.monthlyPlanDurationControlWidth,
          height: Spacing.monthlyPlanDurationControlWidth,
        ),
        icon: Icon(icon, size: Spacing.monthlyPlanDurationControlSize),
      ),
    );
  }
}

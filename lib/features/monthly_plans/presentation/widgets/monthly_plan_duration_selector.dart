import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_duration_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_custom_duration_input.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_duration_option.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/widgets/monthly_plan_duration_selector_skeleton.dart';

class MonthlyPlanDurationSelector extends StatefulWidget {
  const MonthlyPlanDurationSelector({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.includesFriday,
    required this.onFridayChanged,
    required this.customDurationDays,
    required this.onCustomDurationChanged,
    required this.durations,
    required this.isFridayEnabled,
    required this.isLoading,
  });

  final int? selectedIndex;
  final ValueChanged<int> onSelected;
  final bool includesFriday;
  final ValueChanged<bool> onFridayChanged;
  final int? customDurationDays;
  final ValueChanged<int?> onCustomDurationChanged;
  final List<SubscriptionDurationEntity> durations;
  final bool isFridayEnabled;
  final bool isLoading;

  @override
  State<MonthlyPlanDurationSelector> createState() =>
      _MonthlyPlanDurationSelectorState();
}

class _MonthlyPlanDurationSelectorState
    extends State<MonthlyPlanDurationSelector> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final presetDurations = _presetDurations;
    final customDuration = _customDuration;
    final customIndex = customDuration == null
        ? null
        : widget.durations.indexOf(customDuration);

    return Center(
      child: SizedBox(
        width:double.infinity,
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
          child: widget.isLoading
              ? const MonthlyPlanDurationSelectorSkeleton()
              : Stack(
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
                    for (var index = 0; index < presetDurations.length; index++)
                      _option(
                        start: _durationStart(index),
                        label: presetDurations[index].name(locale.localeName),
                        days: presetDurations[index].totalServiceDays,
                        index: widget.durations.indexOf(presetDurations[index]),
                      ),
                    if (customDuration != null && customIndex != null)
                      Positioned(
                        left: Spacing.monthlyPlanDurationMinusLeft,
                        top: Spacing.monthlyPlanDurationOptionTop,
                        width: Spacing.monthlyPlanDurationCustomGroupWidth,
                        height:
                            Spacing.monthlyPlanDurationFridayTop -
                            Spacing.monthlyPlanDurationOptionTop,
                        child: MonthlyPlanCustomDurationInput(
                          label: customDuration.name(locale.localeName),
                          isSelected: widget.selectedIndex == customIndex,
                          value: _customDurationValue(customDuration),
                          minDays: customDuration.minDays!,
                          maxDays: customDuration.maxDays!,
                          errorText: _customDurationError(customDuration),
                          onTap: () => _selectCustomDuration(
                            customIndex,
                            customDuration,
                          ),
                          onIncrement: _nextCustomDuration(
                            customIndex,
                            customDuration,
                          ),
                          onDecrement: _previousCustomDuration(
                            customIndex,
                            customDuration,
                          ),
                        ),
                      ),
                    Positioned(
                      top: Spacing.monthlyPlanDurationFridayTop,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: InkWell(
                          onTap: widget.isFridayEnabled
                              ? () => widget.onFridayChanged(
                                  !widget.includesFriday,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(
                            Spacing.radiusPill,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 220),
                                switchInCurve: Curves.easeOutBack,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) =>
                                    FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
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

  double _durationStart(int index) {
    return switch (index) {
      0 => Spacing.monthlyPlanDurationMonthOptionLeft,
      1 => Spacing.monthlyPlanDurationHalfMonthOptionLeft,
      _ => Spacing.monthlyPlanDurationWeekOptionLeft,
    };
  }

  List<SubscriptionDurationEntity> get _presetDurations => widget.durations
      .where(
        (duration) =>
            !duration.isCustom &&
            duration.durationDays != null &&
            duration.durationDays! > 0,
      )
      .take(3)
      .toList();

  SubscriptionDurationEntity? get _customDuration {
    for (final duration in widget.durations) {
      if (duration.isCustom &&
          duration.minDays != null &&
          duration.maxDays != null) {
        return duration;
      }
    }
    return null;
  }

  int _customDurationValue(SubscriptionDurationEntity duration) {
    final days = widget.customDurationDays;
    if (days != null) return days;
    final totalServiceDays = duration.totalServiceDays;
    if (totalServiceDays > 0) return totalServiceDays;
    return duration.minDays!;
  }

  VoidCallback? _nextCustomDuration(
    int customIndex,
    SubscriptionDurationEntity duration,
  ) {
    final value = _customDurationValue(duration);
    if (value >= duration.maxDays!) return null;
    return () => _changeCustomDuration(customIndex, value + 1);
  }

  VoidCallback? _previousCustomDuration(
    int customIndex,
    SubscriptionDurationEntity duration,
  ) {
    final value = _customDurationValue(duration);
    if (value <= duration.minDays!) return null;
    return () => _changeCustomDuration(customIndex, value - 1);
  }

  void _selectCustomDuration(
    int customIndex,
    SubscriptionDurationEntity duration,
  ) {
    widget.onSelected(customIndex);
    if (widget.customDurationDays == null) {
      widget.onCustomDurationChanged(_customDurationValue(duration));
    }
  }

  void _changeCustomDuration(int customIndex, int value) {
    widget.onSelected(customIndex);
    widget.onCustomDurationChanged(value);
  }

  String? _customDurationError(SubscriptionDurationEntity duration) {
    if (widget.selectedIndex != widget.durations.indexOf(duration)) return null;
    final days = _customDurationValue(duration);

    final minDays = duration.minDays!;
    final maxDays = duration.maxDays!;
    final locale = context.localization;

    if (days < minDays || days > maxDays) {
      return locale.subscription_custom_duration_invalid_error(
        minDays,
        maxDays,
      );
    }

    final isPresetDuration = widget.durations.any(
      (duration) => !duration.isCustom && duration.durationDays == days,
    );
    if (isPresetDuration) {
      return locale.subscription_custom_duration_duplicate_error;
    }

    return null;
  }
}

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_custom_duration_input.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_item.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_option.dart';
import 'package:meal_meat_user/core/widget/subscription_duration/subscription_duration_selector_skeleton.dart';

class SubscriptionDurationSelector extends StatefulWidget {
  const SubscriptionDurationSelector({
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
  final List<SubscriptionDurationItem> durations;
  final bool isFridayEnabled;
  final bool isLoading;

  @override
  State<SubscriptionDurationSelector> createState() =>
      _SubscriptionDurationSelectorState();
}

class _SubscriptionDurationSelectorState
    extends State<SubscriptionDurationSelector> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    if (widget.isLoading) {
      return const SubscriptionDurationSelectorSkeleton();
    }

    final presetDurations = _presetDurations;
    final customDuration = _customDuration;
    final customIndex = customDuration == null
        ? null
        : widget.durations.indexOf(customDuration);

    return Center(
      child: SizedBox(
        width: double.infinity,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.sm,
              vertical: Spacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(height: Spacing.xs),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (
                        var index = 0;
                        index < presetDurations.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(width: Spacing.sm),
                        _option(
                          label: _durationLabel(
                            presetDurations[index],
                            locale.localeName,
                          ),
                          days: _durationDays(presetDurations[index]),
                          index: widget.durations.indexOf(
                            presetDurations[index],
                          ),
                        ),
                      ],
                      if (customDuration != null && customIndex != null) ...[
                        const SizedBox(width: Spacing.xs),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: SubscriptionCustomDurationInput(
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
                        ),
                      ],
                    ],
                  ),
                ),
                Center(
                  child: InkWell(
                    onTap: widget.isFridayEnabled
                        ? () => widget.onFridayChanged(!widget.includesFriday)
                        : null,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _option({
    required String label,
    required int days,
    required int index,
  }) {
    return SizedBox(
      width: Spacing.monthlyPlanDurationOptionWidth,
      child: SubscriptionDurationOption(
        label: label,
        days: days,
        isSelected: widget.selectedIndex == index,
        onTap: () => widget.onSelected(index),
      ),
    );
  }

  int _durationDays(SubscriptionDurationItem duration) {
    final base = duration.totalServiceDays > 0
        ? duration.totalServiceDays
        : (duration.durationDays ?? 0);
    if (widget.includesFriday) {
      final fridays = _fridaysCount(duration, base);
      return base + fridays;
    }
    return base;
  }

  static int _fridaysCount(SubscriptionDurationItem duration, int baseDays) {
    if (duration.fridayDays > 0) {
      return duration.fridayDays;
    }
    if (baseDays == 6) return 1;
    if (baseDays == 12) return 2;
    if (baseDays == 26) return 4;
    if (baseDays > 0) return (baseDays / 6).round();
    return 0;
  }

  String _durationLabel(SubscriptionDurationItem duration, String localeName) {
    if (duration.isCustom) {
      return duration.name(localeName);
    }
    if (widget.includesFriday) {
      final days = _durationDays(duration);
      if (localeName == 'ar') {
        if (days >= 3 && days <= 10) {
          return '$days أيام';
        }
        return '$days يوماً';
      } else {
        return days == 1 ? '1 Day' : '$days Days';
      }
    }
    return duration.name(localeName);
  }

  List<SubscriptionDurationItem> get _presetDurations => widget.durations
      .where(
        (duration) =>
            !duration.isCustom &&
            duration.durationDays != null &&
            duration.durationDays! > 0,
      )
      .take(3)
      .toList();

  SubscriptionDurationItem? get _customDuration {
    for (final duration in widget.durations) {
      if (duration.isCustom &&
          duration.minDays != null &&
          duration.maxDays != null) {
        return duration;
      }
    }
    return null;
  }

  int _customDurationValue(SubscriptionDurationItem duration) {
    final days = widget.customDurationDays;
    if (days != null) return days;
    final totalServiceDays = duration.totalServiceDays;
    if (totalServiceDays > 0) return totalServiceDays;
    return duration.minDays!;
  }

  VoidCallback? _nextCustomDuration(
    int customIndex,
    SubscriptionDurationItem duration,
  ) {
    final value = _customDurationValue(duration);
    final max = duration.maxDays!;
    if (value >= max) return null;
    return () {
      final next = value + 1;
      widget.onCustomDurationChanged(next);
      if (widget.selectedIndex != customIndex) {
        widget.onSelected(customIndex);
      }
    };
  }

  VoidCallback? _previousCustomDuration(
    int customIndex,
    SubscriptionDurationItem duration,
  ) {
    final value = _customDurationValue(duration);
    final min = duration.minDays!;
    if (value <= min) return null;
    return () {
      final prev = value - 1;
      widget.onCustomDurationChanged(prev);
      if (widget.selectedIndex != customIndex) {
        widget.onSelected(customIndex);
      }
    };
  }

  void _selectCustomDuration(
    int customIndex,
    SubscriptionDurationItem duration,
  ) {
    final current = _customDurationValue(duration);
    widget.onCustomDurationChanged(current);
    widget.onSelected(customIndex);
  }

  String? _customDurationError(SubscriptionDurationItem duration) {
    final customDays = widget.customDurationDays;
    if (customDays == null) return null;
    final min = duration.minDays!;
    final max = duration.maxDays!;
    if (customDays < min || customDays > max) {
      return context.localization.subscription_days_range_hint(min, max);
    }
    return null;
  }
}

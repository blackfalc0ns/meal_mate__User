import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionDurationOption extends StatelessWidget {
  const SubscriptionDurationOption({
    super.key,
    required this.label,
    required this.days,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int days;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      children: [
        SizedBox(
          width: Spacing.monthlyPlanDurationOptionWidth,
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
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            Spacing.monthlyPlanDurationOptionRadius,
          ),
          child: AnimatedContainer(
            width: Spacing.monthlyPlanDurationOptionWidth,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: Spacing.monthlyPlanDurationOptionHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? color.primary : color.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(
                Spacing.monthlyPlanDurationOptionRadius,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: Spacing.xl,
                      child: ClipRect(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          layoutBuilder: (currentChild, previousChildren) =>
                              Stack(
                                alignment: Alignment.center,
                                children: [...previousChildren, ?currentChild],
                              ),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, -1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                          child: Text(
                            days.toString(),
                            key: ValueKey(days),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size17,
                              color: isSelected
                                  ? color.primary
                                  : color.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      locale.subscription_day,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                PositionedDirectional(
                  top: Spacing.xs,
                  start: Spacing.xs,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.calendar_month_outlined,
                      key: ValueKey(isSelected),
                      color: isSelected
                          ? color.primary
                          : color.onSurfaceVariant,
                      size: Spacing.monthlyPlanDurationStatusIconSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

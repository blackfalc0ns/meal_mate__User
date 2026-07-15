import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanDurationOption extends StatelessWidget {
  const MonthlyPlanDurationOption({
    super.key,
    required this.label,
    required this.days,
    required this.fridayDays,
    required this.isSelected,
    required this.includesFriday,
    required this.onTap,
  });

  final String label;
  final int days;
  final int fridayDays;
  final bool isSelected;
  final bool includesFriday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final displayedDays = days + (includesFriday ? fridayDays : 0);

    return Column(
      children: [
        Text(
          label,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size8,
            color: color.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Spacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            Spacing.monthlyPlanDurationOptionRadius,
          ),
          child: AnimatedContainer(width: Spacing.monthlyPlanDurationOptionWidth,
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsGeometry.directional(start: Spacing.xs),
                        child: Text(
                          displayedDays.toString(),
                          key: ValueKey(displayedDays),
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size15,
                            color: isSelected ? color.primary : color.onSurface,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      locale.subscription_day,
                      style: getBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size6,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: Spacing.xs,
                  right: Spacing.xs,
                  child: Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.calendar_month_outlined,
                    color: isSelected ? color.primary : color.onSurfaceVariant,
                    size: Spacing.monthlyPlanDurationStatusIconSize,
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

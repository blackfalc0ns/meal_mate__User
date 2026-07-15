import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanHeroBackButton extends StatelessWidget {
  const MonthlyPlanHeroBackButton({
    super.key,
    required this.scale,
    required this.onBack,
  });

  final double scale;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return PositionedDirectional(
      top: Spacing.monthlyPlanHeroBackTop * scale,
      end: Spacing.monthlyPlanHeroBackEnd * scale,
      child: Material(
        color: color.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onBack,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: Spacing.monthlyPlanHeroBackSize * scale,
            height: Spacing.monthlyPlanHeroBackSize * scale,
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: Spacing.iconMd * scale,
              color: color.onSurface,
              semanticLabel: locale.go_back,
            ),
          ),
        ),
      ),
    );
  }
}

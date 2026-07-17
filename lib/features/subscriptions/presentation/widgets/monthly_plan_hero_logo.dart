import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class MonthlyPlanHeroLogo extends StatelessWidget {
  const MonthlyPlanHeroLogo({super.key, required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: Spacing.lg),
      child: Center(
        child: ColoredBox(
          color: color.surface.withValues(alpha: 0),
          child: SvgPicture.asset(
            Assets.monthlyProductLogo,
            width: Spacing.monthlyPlanHeroLogoWidth * scale,
            height: Spacing.monthlyPlanHeroLogoHeight * scale,
          ),
        ),
      ),
    );
  }
}

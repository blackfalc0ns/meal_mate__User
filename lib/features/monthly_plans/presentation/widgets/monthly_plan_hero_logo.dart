import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class MonthlyPlanHeroLogo extends StatelessWidget {
  const MonthlyPlanHeroLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Spacing.lg),
      child: Center(
        child: SvgPicture.asset(
          Assets.monthlyProductLogo,
          width: Spacing.monthlyPlanHeroLogoWidth,
          height: Spacing.monthlyPlanHeroLogoHeight,
        ),
      ),
    );
  }
}

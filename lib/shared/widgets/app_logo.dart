import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = Spacing.xxl - (Spacing.hairline * 6),
    this.showTagline = false,
    this.alignment = CrossAxisAlignment.start,
  });

  final double size;
  final bool showTagline;
  final CrossAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      width: size * 4.38,
      height: size,
      child: ColoredBox(
        color: color.surface,
        child: SvgPicture.asset(
          Assets.mealMateLogo,
          fit: BoxFit.contain,
          semanticsLabel: locale.app_brand_name,
        ),
      ),
    );
  }
}

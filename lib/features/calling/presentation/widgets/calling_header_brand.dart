import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CallingHeaderBrand extends StatelessWidget {
  const CallingHeaderBrand({super.key, required this.title, this.timerText});

  final String title;
  final String? timerText;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.logo,
          width: Spacing.callingLogoWidth,
          height: Spacing.callingLogoHeight,
        ),
        const SizedBox(height: Spacing.sm),
        Text(
          title,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size14,
            color: color.callBrandGreen,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: Spacing.xs),
        Text(
          locale.calling_app_name,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size22,
            color: color.callBrandDarkGreen,
          ),
          textAlign: TextAlign.center,
        ),
        if (timerText != null) ...[
          const SizedBox(height: Spacing.xs),
          Text(
            timerText!,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.callBrandGreen,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

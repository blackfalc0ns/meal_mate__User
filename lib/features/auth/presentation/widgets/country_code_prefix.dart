import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class CountryCodePrefix extends StatelessWidget {
  const CountryCodePrefix({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.keyboard_arrow_down,
            size: 18,
            color: AppColors.textPrimary,
          ),
          Text(
            '965+',
            style: getSemiBoldStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: FontSize.size14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: Spacing.xs),
           CountryFlag.fromCountryCode(
            'KW',
            theme: ImageTheme(
              width: Spacing.iconMd,
              height: Spacing.base,
              shape: RoundedRectangle(Spacing.radiusXs),
            ),
          ),
        ],
      ),
    );
  }
}

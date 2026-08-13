import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/utils/constants.dart';

class ProfileLanguageBottomSheet extends StatelessWidget {
  const ProfileLanguageBottomSheet({super.key, required this.selectedCode});

  final String selectedCode;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final languageOptions = [
      (
        code: AppConstants.arKey,
        countryCode: 'SA',
        title: locale.profile_settings_language_arabic,
      ),
      (
        code: AppConstants.enKey,
        countryCode: 'US',
        title: locale.profile_settings_language_english,
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.screenH),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: Spacing.lg),
            Container(
              width: Spacing.searchFilterSheetHandleWidth,
              height: Spacing.searchFilterSheetHandleHeight,
              decoration: BoxDecoration(
                color: color.outlineVariant,
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  color: color.primary,
                  size: Spacing.iconMd,
                ),
                const SizedBox(width: Spacing.xs),
                Text(
                  locale.profile_settings_language_sheet_title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            for (final option in languageOptions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CountryFlag.fromCountryCode(
                  option.countryCode,
                  theme: ImageTheme(
                    width: Spacing.iconLg,
                    height: Spacing.iconMd,
                    shape: RoundedRectangle(Spacing.radiusXs),
                  ),
                ),
                title: Text(
                  option.title,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                ),
                trailing: selectedCode == option.code
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: color.primary,
                        size: Spacing.iconMd,
                      )
                    : null,
                onTap: () => Navigator.pop(context, option.code),
              ),
            const SizedBox(height: Spacing.sm),
          ],
        ),
      ),
    );
  }
}

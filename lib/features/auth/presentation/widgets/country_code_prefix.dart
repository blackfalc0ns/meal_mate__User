import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';

class CountryCodePrefix extends StatelessWidget {
  const CountryCodePrefix({super.key, this.callingCode, this.onTap});

  final CallingCodeEntity? callingCode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final countryCode = callingCode?.countryCode ?? 'KW';
    final dialCode = callingCode?.dialCode ?? '+965';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.keyboard_arrow_down,
              size: Spacing.iconSm + Spacing.xs / 2,
              color: color.onSurface,
            ),
            Text(
              dialCode,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size14,
                color: color.onSurface,
              ),
            ),
            const SizedBox(width: Spacing.xs),
            CountryFlag.fromCountryCode(
              countryCode,
              theme: ImageTheme(
                width: Spacing.iconMd,
                height: Spacing.base,
                shape: RoundedRectangle(Spacing.radiusXs),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

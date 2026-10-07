import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class ProfileAboutIdentityCard extends StatelessWidget {
  const ProfileAboutIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Spacing.cardPadding),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.cardRadius),
        border: Border.all(color: color.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: AppLogo(size: Spacing.xl)),
          const SizedBox(height: Spacing.md),
          Text(
            locale.profile_about_tagline,
            style: getSemiBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.primary,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            locale.profile_about_desc,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: color.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

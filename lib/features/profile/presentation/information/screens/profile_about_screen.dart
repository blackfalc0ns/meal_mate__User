import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/presentation/information/widgets/profile_about_identity_card.dart';

class ProfileAboutScreen extends StatelessWidget {
  const ProfileAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final features = [
      (
        icon: Icons.restaurant_menu_rounded,
        title: locale.profile_about_feature1_title,
        desc: locale.profile_about_feature1_desc,
      ),
      (
        icon: Icons.calendar_month_rounded,
        title: locale.profile_about_feature2_title,
        desc: locale.profile_about_feature2_desc,
      ),
      (
        icon: Icons.verified_rounded,
        title: locale.profile_about_feature3_title,
        desc: locale.profile_about_feature3_desc,
      ),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_about_title,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.profilePrivacyScreenHorizontalPadding,
          ).copyWith(top: Spacing.profilePrivacyContentTopPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileAboutIdentityCard(),
              const SizedBox(height: Spacing.md),
              ...features.map(
                (f) => Container(
                  margin: const EdgeInsets.only(bottom: Spacing.sm),
                  padding: const EdgeInsets.all(Spacing.cardPadding),
                  decoration: BoxDecoration(
                    color: color.surface,
                    borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    border: Border.all(
                      color: color.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: Spacing.avatarSm,
                        height: Spacing.avatarSm,
                        decoration: BoxDecoration(
                          color: color.secondaryContainer,
                          borderRadius: BorderRadius.circular(Spacing.radiusSm),
                        ),
                        child: Icon(
                          f.icon,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              f.title,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size12,
                                color: color.onSurface,
                              ),
                            ),
                            const SizedBox(height: Spacing.xxs),
                            Text(
                              f.desc,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Spacing.sm),
              Container(
                padding: const EdgeInsets.all(Spacing.cardPadding),
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(Spacing.cardRadius),
                  border: Border.all(
                    color: color.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.profile_about_contact_prompt,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(height: Spacing.xxs),
                          Text(
                            locale.profile_settings_contact_us_subtitle,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size10,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    AppButton.filled(
                      isExpanded: false,
                      text: locale.profile_about_contact_button,
                      onPressed: () => unawaited(
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.profileContactUs),
                      ),
                      height: Spacing.buttonSmallHeight,
                      borderRadius: Spacing.radiusSm,
                      color: color.primary,
                      textColor: color.onPrimary,
                      fontSize: FontSize.size11,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_header.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_logout_button.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_settings_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        showBackButton: false,
        automaticallyImplyLeading: false,
       
        titleWidget: SizedBox(
          width: Spacing.profileAppBarLogoWidth,
          height:
      Spacing.profileAppBarLogoHeight,
          child: SvgPicture.asset(Assets.mealMateLogo),
        ),
        leading: IconButton(
          onPressed: () {},
          constraints: const BoxConstraints.tightFor(
            width: Spacing.profileHeaderActionSize,
            height: Spacing.profileHeaderActionSize,
          ),
          padding: EdgeInsets.zero,
          icon: Icon(
            Icons.settings_rounded,
            color: color.onSurface,
            size: Spacing.profileHeaderIconSize,
          ),
        ),
        actions: [
          Badge(
            backgroundColor: color.tertiary,
            smallSize: Spacing.md,
            child: IconButton(
              onPressed: () {},
              constraints: const BoxConstraints.tightFor(
                width: Spacing.profileHeaderActionSize,
                height: Spacing.profileHeaderActionSize,
              ),
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.notifications_rounded,
                color: color.onSurface,
                size: Spacing.profileHeaderIconSize,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.profileScreenHorizontalPadding,
          ),
          child: Column(
            children: [
              ProfileHeader(semanticsLabel: locale.nav_profile),
              const SizedBox(height: Spacing.profileStatsTopGap),
              const ProfileStatsCard(),
              const SizedBox(height: Spacing.profileSettingsTopGap),
              const ProfileSettingsCard(),
              const SizedBox(height: Spacing.profileLogoutTopGap),
              const ProfileLogoutButton(),
              const SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}

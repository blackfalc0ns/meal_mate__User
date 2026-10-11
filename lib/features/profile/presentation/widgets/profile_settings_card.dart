import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_settings_tile.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final items = [
      (
        icon: Icons.person_outline_rounded,
        title: locale.profile_personal_info,
        subtitle: locale.profile_personal_info_subtitle,
        onTap: () async {
          final profile = context.read<ProfileViewModel>().state.profile.data;
          if (profile == null) return;

          final navigator = Navigator.of(context);
          final viewModel = context.read<ProfileViewModel>();
          final updated = await navigator.pushNamed(
            AppRoutes.personalInformation,
            arguments: profile,
          );
          if (updated == true) {
            viewModel.doIntent(const GetCustomerProfileEvent());
          }
        },
      ),
      (
        icon: Icons.restaurant_menu_rounded,
        title: locale.profile_dietary_preferences,
        subtitle: locale.profile_dietary_preferences_subtitle,
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.dietaryPreferences),
      ),
      (
        icon: Icons.credit_card_rounded,
        title: locale.profile_billing,
        subtitle: locale.profile_billing_subtitle,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.profileBilling),
      ),
      (
        icon: Icons.campaign_rounded,
        title: locale.profile_influencer_partner,
        subtitle: locale.profile_influencer_partner_subtitle,
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.influencerDashboard),
      ),
      (
        icon: Icons.account_balance_wallet_rounded,
        title: locale.payment_method_wallet,
        subtitle: locale.payment_method_wallet_balance,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.wallet),
      ),
      (
        icon: Icons.location_on_outlined,
        title: locale.profile_addresses,
        subtitle: locale.profile_addresses_subtitle,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.addresses),
      ),
      (
        icon: Icons.shield_outlined,
        title: locale.profile_security,
        subtitle: locale.profile_security_subtitle,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.securityPrivacy),
      ),
    ];

    return Container(
      height: Spacing.profileSettingsHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.profileCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.1),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          return AppSettingsTile(
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            showDivider: index != items.length - 1,
            onTap: item.onTap,
          );
        }),
      ),
    );
  }
}

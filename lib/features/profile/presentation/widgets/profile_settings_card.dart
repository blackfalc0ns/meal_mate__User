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
        Icons.person_outline_rounded,
        locale.profile_personal_info,
        locale.profile_personal_info_subtitle,
      ),
      (
        Icons.track_changes_rounded,
        locale.profile_goals,
        locale.profile_goals_subtitle,
      ),
      (
        Icons.restaurant_menu_rounded,
        locale.profile_dietary_preferences,
        locale.profile_dietary_preferences_subtitle,
      ),
      (
        Icons.credit_card_rounded,
        locale.profile_billing,
        locale.profile_billing_subtitle,
      ),
      (
        Icons.account_balance_wallet_rounded,
        locale.payment_method_wallet,
        locale.payment_method_wallet_balance,
      ),
      (
        Icons.location_on_outlined,
        locale.profile_addresses,
        locale.profile_addresses_subtitle,
      ),
      (
        Icons.shield_outlined,
        locale.profile_security,
        locale.profile_security_subtitle,
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
            icon: item.$1,
            title: item.$2,
            subtitle: item.$3,
            showDivider: index != items.length - 1,
            onTap: index == 0
                ? () async {
                    final profile = context
                        .read<ProfileViewModel>()
                        .state
                        .profile
                        .data;
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
                  }
                : index == 3
                ? () =>
                      Navigator.of(context).pushNamed(AppRoutes.profileBilling)
                : index == 4
                ? () => Navigator.of(context).pushNamed(AppRoutes.wallet)
                : index == items.length - 1
                ? () =>
                      Navigator.of(context).pushNamed(AppRoutes.securityPrivacy)
                : index == 5
                ? () => Navigator.of(context).pushNamed(AppRoutes.addresses)
                : index == 2
                ? () => Navigator.of(
                    context,
                  ).pushNamed(AppRoutes.dietaryPreferences)
                : index == 1
                ? () => Navigator.of(context).pushNamed(AppRoutes.healthGoals)
                : null,
          );
        }),
      ),
    );
  }
}

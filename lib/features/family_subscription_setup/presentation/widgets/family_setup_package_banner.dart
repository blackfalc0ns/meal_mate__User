import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/manager/family_subscription_setup_state.dart';

class FamilySetupPackageBanner extends StatelessWidget {
  const FamilySetupPackageBanner({super.key, required this.state});

  final FamilyPlanState state;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final packageName =
        state.selectedPackage?.name(locale.localeName) ??
        state.currentFlow?.packageName(locale.localeName) ??
        '';

    if (packageName.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(Spacing.radiusMd),
        border: Border.all(color: color.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded, color: color.primary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  packageName,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.primary,
                  ),
                ),
                Text(
                  locale.family_package_members_range(
                    state.minMembers,
                    state.maxMembers,
                  ),
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () =>
                context.pushNamed(AppRoutes.familyPackageSelection),
            child: Text(
              locale.family_change_package,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

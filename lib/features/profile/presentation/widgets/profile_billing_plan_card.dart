import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_billing_action.dart';

class ProfileBillingPlanCard extends StatelessWidget {
  const ProfileBillingPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.profileBillingPlanHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.primaryContainer.withValues(alpha: 0.6),
            color.secondaryContainer,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(Spacing.profileBillingCardRadius),
        border: Border.all(color: color.surface),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -Spacing.lg,
            left: -Spacing.md,
            child: Image.asset(
              Assets.profileBillingPlanBottle,
              width: Spacing.xxxl * 3 + Spacing.xxl,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: Spacing.xl + Spacing.xs,
            right: Spacing.base,
            child: SvgPicture.asset(
              Assets.logo,
              width: Spacing.iconMd,
              height: Spacing.iconMd,
            ),
          ),
          Positioned(
            top: Spacing.xxl - Spacing.xs,
            right: Spacing.xxxl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locale.billing_plan_name,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size19,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  locale.billing_plan_tier,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size13,
                    color: color.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(Spacing.radiusXs),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      SvgPicture.asset(
                        Assets.profileBillingCheck,
                        width: Spacing.md,
                        height: Spacing.md,
                      ),
                      const SizedBox(width: Spacing.xs),
                      Text(
                        locale.billing_active,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: Spacing.xxxl * 2 + Spacing.lg,
            right: Spacing.base,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    SvgPicture.asset(
                      Assets.profileBillingCalendar,
                      width: Spacing.iconSm,
                      height: Spacing.iconSm,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.billing_renewal_date,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: Spacing.sm),
                  child: Text(
                    locale.billing_days_remaining,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Spacing.base,
            right: Spacing.base,
            bottom: Spacing.md,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(height: Spacing.xs, color: color.outlineVariant),
                const SizedBox(height: Spacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.billing_plan_usage,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: locale.billing_plan_usage_current,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.primary,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: locale.billing_plan_usage_remaining,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  child: LinearProgressIndicator(
                    value: .73,
                    minHeight: Spacing.xss,
                    color: color.primary,
                    backgroundColor: color.surface,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingUpgradeTier,
                        label: locale.billing_upgrade_tier,
                        actionColor: color.primary,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingFreeze,
                        label: locale.billing_freeze,
                        actionColor: color.tertiary,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingRenew,
                        label: locale.billing_renew,
                        actionColor: color.primary,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: ProfileBillingAction(
                        iconAsset: Assets.profileBillingCancel,
                        label: locale.billing_cancel,
                        actionColor: color.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.all(Spacing.base),
      decoration: BoxDecoration(
        color: color.primaryContainer,
        borderRadius: BorderRadius.circular(Spacing.profileBillingCardRadius),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Image.asset(
              Assets.profileBillingPlanBottle,
              width: Spacing.xxxl * 2,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: Spacing.xxxl * 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.billing_plan_name,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size19,
                      color: color.onSurface,
                    ),
                  ),
                  Text(
                    locale.billing_plan_tier,
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.surface,
                      borderRadius: BorderRadius.circular(Spacing.radiusXs),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          locale.billing_active,
                          style: getMediumStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size10,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      Assets.profileBillingCalendar,
                      width: Spacing.iconSm,
                      height: Spacing.iconSm,
                    ),
                    const SizedBox(width: Spacing.xs),
                    Text(
                      locale.billing_renewal_date,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  locale.billing_days_remaining,
                  style: getMediumStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size11,
                    color: color.primary,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   
                    Text(
                      locale.billing_plan_usage,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                     Text(
                      locale.billing_plan_usage_value,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size10,
                        color: color.primary,
                      ),
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
                        icon: Icons.cancel_rounded,
                        label: locale.billing_cancel,
                        actionColor: color.error,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: ProfileBillingAction(
                        icon: Icons.ac_unit_rounded,
                        label: locale.billing_freeze,
                        actionColor: color.tertiary,
                      ),
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: ProfileBillingAction(
                        icon: Icons.autorenew_rounded,
                        label: locale.billing_renew,
                        actionColor: color.primary,
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

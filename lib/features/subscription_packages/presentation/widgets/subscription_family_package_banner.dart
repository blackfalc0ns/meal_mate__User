import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class SubscriptionFamilyPackageBanner extends StatelessWidget {
  const SubscriptionFamilyPackageBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Material(
      color: color.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionProgramCardRadius,
        ),
        child: Container(
          height: Spacing.subscriptionFamilyBannerHeight,
          decoration: BoxDecoration(
            color: color.primaryContainer.withValues(alpha: 0.16),
            border: Border.all(color: color.primary),
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.07),
                blurRadius: Spacing.lg,
                offset: const Offset(0, Spacing.xs),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: Spacing.md,
                      end: Spacing.md,
                      bottom: Spacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.family_plan_title,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size17,
                            color: color.primary,
                          ),
                        ),
                        Text(
                          locale.family_plan_subtitle,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: Spacing.lg,
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: color.primary),
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusPill,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.groups,
                                size: Spacing.iconSm,
                                color: color.primary,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Text(
                                locale.subscription_view_family_package,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.alexandria,
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
                ClipRect(
                  child: SizedBox(
                    width: Spacing.subscriptionFamilyPreviewWidth,
                    height: Spacing.subscriptionFamilyPreviewHeight,
                    child: OverflowBox(
                      alignment: Alignment.topCenter,
                      maxWidth: Spacing.subscriptionFamilyPreviewWidth,
                      maxHeight: double.infinity,
                      child: Transform.translate(
                        offset: const Offset(
                          0,
                          -Spacing.subscriptionFamilyPreviewTopOffset,
                        ),
                        child: Image.asset(
                          Assets.subscriptionFamilyPackagePreview,
                          width: Spacing.subscriptionFamilyPreviewWidth,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

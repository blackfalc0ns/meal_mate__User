import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class CurrentAddressCard extends StatelessWidget {
  const CurrentAddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.addressesCurrentCardHeight,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.07),
            blurRadius: Spacing.xs,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Spacing.addressesCardRadius),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(
                Spacing.addressesCardContentPadding,
              ),
              child: Container(
                width: Spacing.profileSettingsIconContainer,
                height: Spacing.profileSettingsIconContainer,
                decoration: BoxDecoration(
                  color: color.secondaryContainer,
                  borderRadius: BorderRadius.circular(Spacing.radiusSm),
                ),
                child: Icon(
                  Icons.home_rounded,
                  color: color.primary,
                  size: Spacing.iconMd,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Spacing.md,
                  bottom: Spacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.xs,
                            vertical: Spacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: color.secondaryContainer,
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusXs,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: color.primary,
                                size: Spacing.xs,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Text(
                                locale.addresses_default,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size8,
                                  color: color.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Text(
                          locale.addresses_current_home,
                          style: getBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size13,
                            color: color.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      locale.addresses_current_home_details,
                      textAlign: TextAlign.end,
                      style: getLightStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size11,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: color.secondaryContainer,
                        borderRadius: BorderRadius.circular(Spacing.radiusSm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            locale.addresses_access_instructions,
                            style: getMediumStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size9,
                              color: color.primary,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Icon(
                            Icons.location_on_rounded,
                            color: color.primary,
                            size: Spacing.md,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: Spacing.addressesMapSize,
              height: Spacing.addressesMapSize,
              child: Image.asset(
                Assets.profileDefaultAddressMap,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

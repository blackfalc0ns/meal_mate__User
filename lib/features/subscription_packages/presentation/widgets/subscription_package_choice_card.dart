import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_restaurant_logo_stack.dart';

class SubscriptionPackageChoiceCard extends StatelessWidget {
  const SubscriptionPackageChoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.isPopular = false,
    this.price,
    this.currency,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isPopular;
  final String? price;
  final String? currency;
  final VoidCallback? onTap;

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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: Spacing.subscriptionPackageChoiceFigmaHeight,
              padding: const EdgeInsets.only(
                top: Spacing.md,
                right: Spacing.md,
                bottom: Spacing.xxl,
                left: Spacing.md,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.primaryContainer.withValues(alpha: 0.14)
                    : color.surface,
                borderRadius: BorderRadius.circular(
                  Spacing.subscriptionProgramCardRadius,
                ),
                border: Border.all(
                  color: isSelected ? color.primary : color.surface,
                  width: isSelected
                      ? Spacing.border + Spacing.hairline
                      : Spacing.hairline,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.07),
                    blurRadius: Spacing.lg,
                    offset: const Offset(0, Spacing.xs),
                  ),
                ],
              ),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  SizedBox(
                    width: Spacing.subscriptionPackageChoiceImageWidth,
                    height: Spacing.subscriptionPackageChoiceImageHeight,
                    child: Image.asset(
                      Assets.subscriptionPackageMealBox,
                      fit: BoxFit.contain,
                      semanticLabel: title,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Container(
                              // width: Spacing.lg,
                              height: Spacing.xxl,
                              decoration: BoxDecoration(
                                color: color.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: color.primary,
                                size: Spacing.iconSm,
                              ),
                            ),
                            const SizedBox(width: Spacing.xs),
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getSemiBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size14,
                                  color: color.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: Spacing.sm),
                        const SubscriptionRestaurantLogoStack(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: Spacing.xxxl + Spacing.xxxl - Spacing.xs,
              left: Spacing.xxxl + Spacing.xxxl - Spacing.xs,
              bottom: Spacing.xss,
              child: Container(
                height: Spacing.subscriptionPackageChoiceButtonHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? color.primary : color.surface,
                  border: Border.all(color: color.primary),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: Text(
                  locale.subscription_choose_plan_button,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: isSelected ? color.onPrimary : color.primary,
                  ),
                ),
              ),
            ),
            if (isPopular)
              Positioned(
                top: -Spacing.md,
                left: Spacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.sm,
                    vertical: Spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: color.primary,
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        size: Spacing.iconSm,
                        color: color.onPrimary,
                      ),
                      const SizedBox(width: Spacing.xs),

                      Text(
                        locale.subscription_details_most_selected,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

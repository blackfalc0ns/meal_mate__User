import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_restaurant_logo_stack.dart';

class SubscriptionPackageChoiceCard extends StatelessWidget {
  const SubscriptionPackageChoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.fallbackImageAsset,
    this.isPopular = false,
    this.imageUrl,
    this.restaurantLogoUrls = const [],
    this.badgeLabel,
    this.price,
    this.currency,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final String fallbackImageAsset;
  final bool isPopular;
  final String? imageUrl;
  final List<String?> restaurantLogoUrls;
  final String? badgeLabel;
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
              padding: const EdgeInsetsDirectional.only(
                top: Spacing.md,
                end: Spacing.md,
                bottom: Spacing.xxl,
                start: Spacing.md,
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
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
                                maxLines: 2,
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
                        const SizedBox(height: Spacing.sm),
                        SubscriptionRestaurantLogoStack(
                          logoUrls: restaurantLogoUrls,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),

                  SizedBox(
                    width: Spacing.subscriptionPackageChoiceImageWidth,
                    height: Spacing.subscriptionPackageChoiceImageHeight,
                    child: AppCachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.contain,
                      semanticLabel: title,
                    ),
                  ),
                ],
              ),
            ),
            PositionedDirectional(
              end: Spacing.xxxl + Spacing.xxxl - Spacing.xs,
              start: Spacing.xxxl + Spacing.xxxl - Spacing.xs,
              bottom: Spacing.xss,
              child: Container(
                height: Spacing.subscriptionPackageChoiceButtonHeight,
                alignment: AlignmentDirectional.center,
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
                        badgeLabel ?? locale.subscription_details_most_selected,
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

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
    this.isPopular = false,
    this.imageUrl,
    this.restaurantLogoUrls = const [],
    this.badgeLabel,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final bool isPopular;
  final String? imageUrl;
  final List<String?> restaurantLogoUrls;
  final String? badgeLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.fastOutSlowIn,
          constraints: const BoxConstraints(
            minHeight: Spacing.subscriptionPackageChoiceFigmaHeight,
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
                  ? Spacing.familySelectedBorderWidth
                  : Spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.primary.withValues(alpha: 0.12)
                    : color.shadow.withValues(alpha: 0.07),
                blurRadius: isSelected ? Spacing.xl : Spacing.lg,
                offset: Offset(0, isSelected ? Spacing.sm : Spacing.xs),
              ),
            ],
          ),
          child: Material(
            color: color.surface.withValues(alpha: 0),
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(
                Spacing.subscriptionProgramCardRadius,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: Spacing.md,
                  end: Spacing.md,
                  bottom: Spacing.xxl,
                  start: Spacing.md,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: Spacing.xl,
                                  height: Spacing.xl,
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
                            const SizedBox(height: Spacing.xxs),
                            Text(
                              subtitle,
                              maxLines: isSelected ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size11,
                                color: color.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: Spacing.xs),
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
              ),
            ),
          ),
        ),
        PositionedDirectional(
          start: 0,
          end: 0,
          bottom: Spacing.xss,
          child: Center(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.fastOutSlowIn,
                width: Spacing.subscriptionPackageChoiceButtonWidth,
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
          ),
        ),
        if (isPopular)
          PositionedDirectional(
            top: -Spacing.sm,
            end: Spacing.md,
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
    );
  }
}

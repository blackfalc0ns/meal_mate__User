import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_restaurant_logo_stack.dart';

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: Spacing.subscriptionProgramCardHeight + Spacing.xs,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.primaryContainer.withValues(alpha: 0.14)
                : color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected
                  ? Spacing.border + Spacing.hairline
                  : Spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.07),
                blurRadius: Spacing.lg,
                offset: const Offset(0, Spacing.xss),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Spacing.radiusMd),
                  child: Image.asset(
                    AssetsFake.monthlyPackageBox,
                    fit: BoxFit.contain,
                    alignment: const Alignment(0.05, 0.42),
                    semanticLabel: title,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getMediumStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size15,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        Icon(
                          Icons.calendar_month_outlined,
                          size: Spacing.iconSm,
                          color: color.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size8,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    const SubscriptionRestaurantLogoStack(),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.sm,
                          vertical: Spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: color.primary,
                          borderRadius: BorderRadius.circular(Spacing.radiusXs),
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getSemiBoldStyle(
                                fontFamily: FontConstant.ibmPlexSansArabic,
                                fontSize: FontSize.size7,
                                color: color.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    if (price != null && currency != null) ...[
                      Text(
                        price!,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size17,
                          color: color.primary,
                        ),
                      ),
                      Text(
                        currency!,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size7,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                    ],
                    Container(
                      height: Spacing.xxl - Spacing.xs,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? color.primary : color.surface,
                        border: Border.all(color: color.primary),
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      child: Text(
                        locale.subscription_choose_plan_button,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size11,
                          color: isSelected ? color.onPrimary : color.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

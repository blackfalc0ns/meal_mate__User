import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/widgets/subscription_program_arrow_button.dart';

class SubscriptionProgramGoalCard extends StatelessWidget {
  const SubscriptionProgramGoalCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.primaryFeature,
    required this.secondaryFeature,
    required this.badgeIcon,
    required this.primaryFeatureIcon,
    required this.secondaryFeatureIcon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final String imageAsset;
  final String primaryFeature;
  final String secondaryFeature;
  final IconData badgeIcon;
  final IconData primaryFeatureIcon;
  final IconData secondaryFeatureIcon;
  final bool isSelected;
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: Spacing.subscriptionProgramCardHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? color.surfaceContainerHighest.withValues(alpha: 0.24)
                : color.surface,
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            border: Border.all(
              color: isSelected
                  ? color.primary
                  : color.outlineVariant.withValues(alpha: 0.7),
              width: isSelected ? Spacing.border : Spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.05),
                offset: const Offset(0, Spacing.xss),
                blurRadius: Spacing.sm,
              ),
            ],
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: Spacing.xxl,
                          height: Spacing.xxl,
                          decoration: BoxDecoration(
                            color: color.primaryContainer.withValues(
                              alpha: 0.6,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            badgeIcon,
                            size: Spacing.iconSm,
                            color: color.primary,
                            semanticLabel: locale.nav_subscription,
                          ),
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size17,
                              color: color.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.xxxl,
                      ),
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: getRegularStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size9,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(
                          primaryFeatureIcon,
                          size: Spacing.iconSm,
                          color: color.primary,
                          semanticLabel: locale.nav_subscription,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Flexible(
                          child: Text(
                            primaryFeature,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: getRegularStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size8,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        SizedBox(
                          height: Spacing.base,
                          child: VerticalDivider(
                            width: Spacing.border,
                            thickness: Spacing.border,
                            color: color.outlineVariant,
                          ),
                        ),
                        const SizedBox(width: Spacing.md),
                        Icon(
                          secondaryFeatureIcon,
                          size: Spacing.iconSm,
                          color: color.primary,
                          semanticLabel: locale.nav_subscription,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Flexible(
                          child: Text(
                            secondaryFeature,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: getRegularStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: FontSize.size8,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Flexible(
                flex: 0,
                child: SizedBox(
                  width: Spacing.subscriptionProgramImageWidth,
                  height: Spacing.subscriptionProgramImageHeight,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    semanticLabel: title,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              const SubscriptionProgramArrowButton(),
            ],
          ),
        ),
      ),
    );
  }
}

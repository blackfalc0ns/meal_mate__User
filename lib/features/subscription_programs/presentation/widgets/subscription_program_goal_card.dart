import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_arrow_button.dart';

class SubscriptionProgramGoalCard extends StatelessWidget {
  const SubscriptionProgramGoalCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.fallbackImageAsset,
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
  final String? imageUrl;
  final String fallbackImageAsset;
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
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: Spacing.sm),
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.sm,
                      ),
                      child: Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ),
               //     const Spacer(),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.sm,
                      ),
                      child: Row(
                        children: [
                        
                          Flexible(
                            child: Text(
                              primaryFeature,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color:   color.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          SizedBox(
                            height: Spacing.base,
                            child: VerticalDivider(
                              width: Spacing.border,
                              thickness: Spacing.border,
                              color:   color.primary,
                            ),
                          ),

                          const SizedBox(width: Spacing.xs),
                          Flexible(
                            child: Text(
                              secondaryFeature,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color:
                                color.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  child: AppCachedNetworkImage(
                    imageUrl: imageUrl,
                    width: Spacing.subscriptionProgramImageWidth,
                    height: Spacing.subscriptionProgramImageHeight,
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

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';

class SubscriptionProgramGoalCard extends StatelessWidget {
  const SubscriptionProgramGoalCard({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.primaryFeature,
    required this.secondaryFeature,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String description;
  final String? imageUrl;
  final String primaryFeature;
  final String secondaryFeature;
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
          duration: const Duration(milliseconds: 280),
          curve: Curves.fastOutSlowIn,
          clipBehavior: Clip.antiAlias,
          height: isSelected
              ? Spacing.subscriptionProgramCardHeight + Spacing.lg
              : Spacing.subscriptionProgramCardHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.sm,
            vertical: Spacing.sm,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              Spacing.subscriptionProgramCardRadius,
            ),
            border: Border.all(
              color: isSelected ? color.primary : color.outlineVariant,
              width: isSelected ? Spacing.border : Spacing.hairline,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.primary.withValues(alpha: 0.08)
                    : color.shadow.withValues(alpha: 0.05),
                offset: Offset(0, isSelected ? Spacing.xs : Spacing.xss),
                blurRadius: isSelected ? Spacing.md : Spacing.sm,
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.sm,
                      ),
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
                    const SizedBox(height: Spacing.xs),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: Spacing.sm,
                      ),
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 280),
                        firstCurve: Curves.easeOut,
                        secondCurve: Curves.easeIn,
                        sizeCurve: Curves.fastOutSlowIn,
                        crossFadeState: isSelected
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: Text(
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
                        secondChild: Text(
                          description,
                          textAlign: TextAlign.start,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xs),
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
                                color: color.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.md),
                          SizedBox(
                            height: Spacing.base,
                            child: VerticalDivider(
                              width: Spacing.border,
                              thickness: Spacing.border,
                              color: color.primary,
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
                                color: color.primary,
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
              SizedBox(
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
              const SizedBox(width: Spacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}

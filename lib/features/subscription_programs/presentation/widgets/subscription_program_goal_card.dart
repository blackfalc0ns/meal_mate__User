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
    this.canSelect = true,
    this.disabledNotice,
    this.onTap,
  });

  final String title;
  final String description;
  final String? imageUrl;
  final String primaryFeature;
  final String secondaryFeature;
  final bool isSelected;
  final bool canSelect;
  final String? disabledNotice;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.fastOutSlowIn,
      constraints: BoxConstraints(
        minHeight: isSelected
            ? Spacing.subscriptionProgramCardHeight + Spacing.base
            : Spacing.subscriptionProgramCardHeight,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionProgramCardRadius,
        ),
        border: Border.all(
          color: !canSelect
              ? color.outlineVariant.withValues(alpha: 0.25)
              : isSelected
              ? color.primary
              : color.outlineVariant.withValues(alpha: 0.35),
          width: isSelected ? Spacing.border : Spacing.hairline,
        ),
        boxShadow: [
          BoxShadow(
            color: !canSelect
                ? color.shadow.withValues(alpha: 0.02)
                : isSelected
                ? color.primary.withValues(alpha: 0.12)
                : color.shadow.withValues(alpha: 0.06),
            offset: Offset(0, isSelected ? Spacing.xs : Spacing.xss),
            blurRadius: isSelected ? Spacing.lg : Spacing.base,
            spreadRadius: Spacing.zero,
          ),
        ],
      ),
      child: Material(
        color: color.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(
          Spacing.subscriptionProgramCardRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            Spacing.subscriptionProgramCardRadius,
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 280),
            opacity: canSelect ? 1.0 : 0.65,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.base,
                vertical: Spacing.md,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: getBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 280),
                          firstCurve: Curves.easeOut,
                          secondCurve: Curves.easeIn,
                          sizeCurve: Curves.fastOutSlowIn,
                          alignment: AlignmentDirectional.topStart,
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
                            ).copyWith(height: 1.35),
                          ),
                          secondChild: Text(
                            description,
                            textAlign: TextAlign.start,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.onSurfaceVariant,
                            ).copyWith(height: 1.35),
                          ),
                        ),
                        const SizedBox(height: Spacing.sm),
                        if (!canSelect)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                size: Spacing.iconXs,
                                color: color.error,
                              ),
                              const SizedBox(width: Spacing.xs),
                              Flexible(
                                child: Text(
                                  disabledNotice ??
                                      locale
                                          .subscription_program_no_restaurants_in_area,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size10,
                                    color: color.error,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              if (primaryFeature.isNotEmpty)
                                Flexible(
                                  child: Text(
                                    primaryFeature,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size10,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              if (primaryFeature.isNotEmpty &&
                                  secondaryFeature.isNotEmpty) ...[
                                const SizedBox(width: Spacing.sm),
                                SizedBox(
                                  height: Spacing.md,
                                  child: VerticalDivider(
                                    width: Spacing.border,
                                    thickness: Spacing.border,
                                    color: color.outlineVariant,
                                  ),
                                ),
                                const SizedBox(width: Spacing.sm),
                              ],
                              if (secondaryFeature.isNotEmpty)
                                Flexible(
                                  child: Text(
                                    secondaryFeature,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: getRegularStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size10,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

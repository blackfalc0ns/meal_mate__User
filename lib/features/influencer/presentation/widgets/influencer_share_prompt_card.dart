import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerSharePromptCard extends StatelessWidget {
  const InfluencerSharePromptCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.codeTitle,
    required this.code,
    required this.shareIconAsset,
    required this.copyIconAsset,
  });

  final String title;
  final String subtitle;
  final String codeTitle;
  final String code;
  final String shareIconAsset;
  final String copyIconAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerSharePromptHeight,
      padding: const EdgeInsets.all(
        Spacing.influencerSharePromptContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(
          Spacing.influencerSharePromptRadius,
        ),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.influencerSharePromptBorder,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: Spacing.zero,
            top: Spacing.zero,
            bottom: Spacing.zero,
            child: SizedBox(
              width: Spacing.influencerShareCouponWidth,
              height: Spacing.influencerShareCouponHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color.surface.withValues(alpha: 0),
                  borderRadius: BorderRadius.circular(
                    Spacing.influencerShareCouponRadius,
                  ),
                  border: Border.all(color: color.outlineVariant),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      codeTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size7,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: Spacing.xss),
                    SizedBox(
                      width:
                          Spacing.influencerShareCouponWidth -
                          (Spacing.influencerSharePromptContentPadding * 2),
                      height: Spacing.lg,
                      child: Stack(
                        children: [
                          Positioned(
                            left: Spacing.zero,
                            top: Spacing.zero,
                            bottom: Spacing.zero,
                            child: Text(
                              code,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size15,
                                color: color.primary,
                              ),
                            ),
                          ),
                          Positioned(
                            right: Spacing.zero,
                            top: Spacing.zero,
                            bottom: Spacing.zero,
                            child: SvgPicture.asset(
                              copyIconAsset,
                              width: Spacing.influencerCopyIconSize,
                              height: Spacing.influencerCopyIconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: Spacing.influencerShareCouponWidth + Spacing.md,
            top: Spacing.sm,
            bottom: Spacing.sm,
            child: Container(
              width: Spacing.hairline,
              color: color.outlineVariant,
            ),
          ),
          Positioned(
            left: Spacing.influencerShareCouponWidth + Spacing.md + Spacing.md,
            right: Spacing.zero,
            top: Spacing.zero,
            bottom: Spacing.zero,
            child: Stack(
              children: [
                Positioned(
                  right: Spacing.zero,
                  top: Spacing.zero,
                  bottom: Spacing.zero,
                  child: Center(
                    child: Container(
                      key: const ValueKey('influencer-share-action-circle'),
                      width: Spacing.iconXl,
                      height: Spacing.iconXl,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color.surface,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        shareIconAsset,
                        width: Spacing.influencerShareIconSize,
                        height: Spacing.influencerShareIconSize,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: Spacing.zero,
                  right: Spacing.iconXl + Spacing.sm,
                  top: Spacing.zero,
                  bottom: Spacing.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size8,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size7,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

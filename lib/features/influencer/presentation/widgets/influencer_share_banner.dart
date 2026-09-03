import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerShareBanner extends StatelessWidget {
  const InfluencerShareBanner({
    super.key,
    required this.shareLinks,
    required this.imageAsset,
    required this.trendIconAsset,
  });

  final InfluencerShareLinksEntity shareLinks;
  final String imageAsset;
  final String trendIconAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        Spacing.influencerShareLinksBannerRadius,
      ),
      child: SizedBox(
        height: Spacing.influencerShareLinksBannerHeight,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(imageAsset, fit: BoxFit.cover),
            PositionedDirectional(
              top: Spacing.lg,
              start: Spacing.base,
              child: SizedBox(
                width: Spacing.influencerShareCouponWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shareLinks.bannerTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onPrimary,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            shareLinks.bannerHighlight,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size19,
                              color: color.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: Spacing.xs),
                        SvgPicture.asset(
                          trendIconAsset,
                          width: Spacing.iconMd,
                          height: Spacing.iconMd,
                          colorFilter: ColorFilter.mode(
                            color.onPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.base),
                    Text(
                      shareLinks.bannerSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onPrimary,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      shareLinks.bannerFooter,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
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

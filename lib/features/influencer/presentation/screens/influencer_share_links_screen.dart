import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_banner.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_discount_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_quick_stats_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_referral_card.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_share_social_tile.dart';

class InfluencerShareLinksScreen extends StatelessWidget {
  const InfluencerShareLinksScreen({super.key, this.showScaffold = true});

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();
    final shareLinks = dashboard.shareLinks;

    final body = SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.screenH,
          top: Spacing.md,
          end: Spacing.screenH,
          bottom: Spacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              shareLinks.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
             
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size17,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              shareLinks.subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.base),
            InfluencerShareBanner(
              shareLinks: shareLinks,
              imageAsset: dashboard.shareBannerAsset,
              trendIconAsset: dashboard.trendIconAsset,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerShareDiscountCard(
              shareLinks: shareLinks,
              qrAsset: dashboard.qrAsset,
              copyIconAsset: dashboard.copyIconAsset,
            ),
            const SizedBox(height: Spacing.base),
            InfluencerShareReferralCard(
              shareLinks: shareLinks,
              copyIconAsset: dashboard.copyIconAsset,
            ),
            const SizedBox(height: Spacing.lg),
            Text(
              shareLinks.shareNowTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
           
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              shareLinks.shareNowSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
             
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (
                    var index = 0;
                    index < shareLinks.socialPlatforms.length;
                    index++
                  ) ...[
                    InfluencerShareSocialTile(
                      platform: shareLinks.socialPlatforms[index],
                    ),
                    if (index < shareLinks.socialPlatforms.length - 1)
                      const SizedBox(width: Spacing.md),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),
            InfluencerShareQuickStatsCard(shareLinks: shareLinks),
          ],
        ),
      ),
    );

    if (!showScaffold) {
      return body;
    }

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: shareLinks.title,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: body,
    );
  }
}

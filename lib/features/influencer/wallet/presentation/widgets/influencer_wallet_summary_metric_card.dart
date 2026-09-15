import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../models/influencer_wallet_view_data.dart';

class InfluencerWalletSummaryMetricCard extends StatelessWidget {
  const InfluencerWalletSummaryMetricCard({super.key, required this.metric});

  final InfluencerWalletSummaryMetricViewData metric;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerWalletSummaryMetricHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.influencerWalletSummaryMetricPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerWalletSummaryMetricRadius,
        ),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    metric.value,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size14,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(width: Spacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(bottom: Spacing.xs),
                    child: Text(
                      metric.currency,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size8,
                        color: color.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset(_svgAsset, width: _iconSize, height: _iconSize),
        ],
      ),
    );
  }

  String get _svgAsset {
    return switch (metric.icon) {
      InfluencerWalletSummaryIcon.earnings =>
        AssetsFake.influencerWalletTrendUp,
      InfluencerWalletSummaryIcon.withdrawn =>
        AssetsFake.influencerWalletDownload,
    };
  }

  double get _iconSize => Spacing.influencerWalletSummaryMetricIconSize;
}

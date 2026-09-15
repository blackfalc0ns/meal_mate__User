import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../models/influencer_wallet_view_data.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/widgets/influencer_wallet_summary_metric_card.dart';

class InfluencerWalletMonthlySummaryCard extends StatelessWidget {
  const InfluencerWalletMonthlySummaryCard({
    super.key,
    required this.title,
    required this.metrics,
  });

  final String title;
  final List<InfluencerWalletSummaryMetricViewData> metrics;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerWalletMonthlySummaryHeight,
      width: double.infinity,
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.influencerWalletMonthlySummaryContentPadding,
        top: Spacing.influencerWalletMonthlySummaryPaddingTop,
        end: Spacing.influencerWalletMonthlySummaryContentPadding,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerWalletSectionCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.lg,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AssetsFake.influencerWalletCalendar,
                width: Spacing.influencerWalletMonthlySummaryHeaderHeight,
                height: Spacing.influencerWalletMonthlySummaryHeaderHeight,
              ),
              const SizedBox(width: Spacing.xs),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            children: [
              for (var index = 0; index < metrics.length; index++) ...[
                Expanded(
                  child: InfluencerWalletSummaryMetricCard(
                    metric: metrics[index],
                  ),
                ),
                if (index < metrics.length - 1)
                  const SizedBox(
                    width: Spacing.influencerWalletMonthlySummaryGridGap,
                  ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

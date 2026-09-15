import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../models/influencer_social_item_view_data.dart';

class InfluencerSocialConnectionCard extends StatelessWidget {
  const InfluencerSocialConnectionCard({
    super.key,
    required this.item,
  });

  final InfluencerSocialItemViewData item;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isConnected = item.isConnected;

    return Container(
      height: Spacing.influencerSocialCardHeight,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.influencerSocialCardRadius),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.influencerSocialCardBorder,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            item.iconAsset,
            width: Spacing.influencerSocialIconSize,
            height: Spacing.influencerSocialIconSize,
          ),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size12,
                    color: color.onSurface,
                  ),
                ),
                const SizedBox(height: Spacing.xss),
                Text(
                  isConnected ? item.handle! : item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: isConnected ? color.primary : color.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Spacing.xs),
          GestureDetector(
            onTap: item.onTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: Spacing.influencerSocialAddButtonWidth,
              height: Spacing.influencerSocialAddButtonHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(
                  Spacing.influencerSocialAddButtonRadius,
                ),
                border: Border.all(
                  color: color.primary,
                  width: Spacing.border,
                ),
              ),
              child: Text(
                isConnected
                    ? locale.influencer_social_edit
                    : locale.influencer_social_add,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

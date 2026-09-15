import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_dashed_border.dart';
import 'package:qr_flutter/qr_flutter.dart';

class InfluencerShareDiscountCard extends StatelessWidget {
  const InfluencerShareDiscountCard({
    super.key,
    required this.shareLinks,
    required this.qrData,
    required this.copyIconAsset,
  });

  final InfluencerShareLinksEntity shareLinks;
  final String qrData;
  final String copyIconAsset;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Container(
      height: Spacing.influencerShareLinksCardHeight,
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.influencerShareLinksCardRadius,
        ),
        border: Border.all(color: color.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.08),
            blurRadius: Spacing.md,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: Spacing.zero,
            top: Spacing.zero,
            bottom: Spacing.zero,
            child: Container(
              width: Spacing.influencerShareLinksQrPanelWidth,
              decoration: BoxDecoration(
                color: color.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(
                  Spacing.influencerShareLinksQrPanelRadius,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    shareLinks.qrLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size9,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    child: QrImageView(
                      data: qrData,
                      semanticsLabel: qrData,
                      size: Spacing.influencerShareLinksQrImageSize,
                      padding: EdgeInsets.zero,
                      backgroundColor: color.surface,
                      eyeStyle: QrEyeStyle(color: color.onSurface),
                      dataModuleStyle: QrDataModuleStyle(
                        color: color.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: Spacing.zero,
            top: Spacing.zero,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Spacing.influencerShareLinksIconBoxSize,
                  height: Spacing.influencerShareLinksIconBoxSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: color.primary,
                    size: Spacing.iconSm,
                  ),
                ),
                const SizedBox(width: Spacing.sm),

                Text(
                  shareLinks.discountCodeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getMediumStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size10,
                    color: color.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: Spacing.zero,
            top: Spacing.xxl,
            child: InfluencerDashedBorder(
              color: color.primaryContainer,
              borderRadius: BorderRadius.circular(
                Spacing.influencerShareLinksCouponRadius,
              ),
              child: Container(
                width: Spacing.influencerShareLinksCouponWidth,
                height: Spacing.influencerShareLinksCouponHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.surface,
                  borderRadius: BorderRadius.circular(
                    Spacing.influencerShareLinksCouponRadius,
                  ),
                ),
                child: Text(
                  shareLinks.discountCode,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size16,
                    color: color.primary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: Spacing.xxl,
            bottom: Spacing.xs,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.xs,
              ),
              decoration: BoxDecoration(
                color: color.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(Spacing.radiusPill),
              ),
              child: RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size7,
                    color: color.onSurface,
                  ),
                  children: [
                    TextSpan(text: shareLinks.discountBadgePrefix),
                    TextSpan(
                      text: shareLinks.discountBadgeValue,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size7,
                        color: color.primary,
                      ),
                    ),
                    TextSpan(text: shareLinks.discountBadgeSuffix),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left:
                Spacing.influencerShareLinksQrPanelWidth +
                Spacing.influencerShareLinksIconBoxSize,
            top: Spacing.xxl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Spacing.influencerShareLinksCopyIconSize,
                  height: Spacing.influencerShareLinksCopyIconSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: color.primaryContainer.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    copyIconAsset,
                    width: Spacing.iconMd,
                    height: Spacing.iconMd,
                  ),
                ),
                const SizedBox(height: Spacing.xs),
                Text(
                  shareLinks.copyCodeLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size7,
                    color: color.onSurface,
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

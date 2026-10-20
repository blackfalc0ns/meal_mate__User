import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class OffersInviteBanner extends StatelessWidget {
  const OffersInviteBanner({
    super.key,
    this.onTap,
    this.code,
    this.rewardRate,
  });

  final VoidCallback? onTap;
  final String? code;
  final double? rewardRate;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final percent = rewardRate != null && rewardRate! > 0
        ? (rewardRate! <= 1.0
            ? (rewardRate! * 100).toInt()
            : rewardRate!.toInt())
        : null;

    final discountText = percent != null
        ? '${locale.offers_invite_subtitle.contains('%') ? '' : 'خصم '}$percent%'
        : locale.offers_invite_subtitle;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.offersInviteBannerRadius),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: Spacing.md,
            horizontal: Spacing.lg,
          ),
          decoration: BoxDecoration(
            color: color.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(Spacing.offersInviteBannerRadius),
            border: Border.all(
              color: color.primary.withValues(alpha: 0.18),
              width: Spacing.border,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PositionedDirectional(
                top: 2,
                start: 4,
                child: Icon(
                  Icons.eco_outlined,
                  size: 20,
                  color: color.primary.withValues(alpha: 0.15),
                ),
              ),
              PositionedDirectional(
                bottom: 2,
                end: 6,
                child: Icon(
                  Icons.eco_rounded,
                  size: 22,
                  color: color.primary.withValues(alpha: 0.15),
                ),
              ),
              PositionedDirectional(
                top: 8,
                end: 18,
                child: Icon(
                  Icons.spa_outlined,
                  size: 14,
                  color: color.primary.withValues(alpha: 0.12),
                ),
              ),
              PositionedDirectional(
                bottom: 12,
                start: 16,
                child: Icon(
                  Icons.spa_rounded,
                  size: 14,
                  color: color.primary.withValues(alpha: 0.12),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    locale.offers_invite_title,
                    textAlign: TextAlign.center,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    discountText,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size22,
                      color: color.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.lg,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary,
                      borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      boxShadow: [
                        BoxShadow(
                          color: color.primary.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      locale.offers_invite_button,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: color.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

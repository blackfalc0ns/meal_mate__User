import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersInviteBanner extends StatelessWidget {
  const OffersInviteBanner({super.key, required this.banner});

  final InviteBannerEntity banner;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: Spacing.offersInviteBannerHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: color.tertiaryContainer,
        borderRadius: BorderRadius.circular(Spacing.offersInviteBannerRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PositionedDirectional(
            end: -Spacing.xl,
            bottom: -Spacing.sm,
            width: Spacing.offersInvitePeopleWidth,
            child: Image.asset(banner.imageAsset, fit: BoxFit.contain),
          ),
          PositionedDirectional(
            start: Spacing.md,
            top: Spacing.md,
            width: Spacing.offersInviteGiftWidth,
            child: Image.asset(banner.trailingImageAsset, fit: BoxFit.contain),
          ),
          PositionedDirectional(
            start: Spacing.xxxl + Spacing.xxl,
            top: Spacing.lg,
            child: SizedBox(
              width: Spacing.xxxl * 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    banner.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                  Text(
                    banner.subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size28,
                      color: color.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  SizedBox(
                    height: Spacing.offersCouponButtonHeight,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color.primary,
                        foregroundColor: color.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.base,
                        ),
                        shape: const StadiumBorder(),
                        elevation: 0,
                      ),
                      child: Text(
                        banner.buttonLabel,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size13,
                          color: color.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Semantics(label: locale.offers_invite_button),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OfferDealCard extends StatelessWidget {
  const OfferDealCard({super.key, required this.offer, this.onTap});

  final OfferDealEntity offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      button: true,
      label: offer.title,
      child: Material(
        color: color.surface.withValues(alpha: 0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
          child: Ink(
            width: Spacing.offersDealCardWidth,
            height: Spacing.offersDealCardHeight,
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
              border: Border.all(
                color: color.outlineVariant,
                width: Spacing.border,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
              child: Stack(
                children: [
                  PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: Container(
                      height: Spacing.offersDealBadgeHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: offer.accentColor,
                        borderRadius: const BorderRadiusDirectional.only(
                          topEnd: Radius.circular(Spacing.offersDealCardRadius),
                          bottomStart: Radius.circular(Spacing.sm),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        offer.discountLabel,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          fontSize: FontSize.size12,
                          color: color.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: Spacing.md,
                      start: Spacing.xs,
                      end: Spacing.xs,
                      bottom: Spacing.offersDealFooterHeight,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Spacing.offersDealImageHeight,
                          child: Center(
                            child: Hero(
                              tag: offer,
                              child: Image.asset(
                                offer.imageAsset,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          offer.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size16,
                            color: color.onSurface,
                          ),
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          offer.subtitle,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getRegularStyle(
                            fontFamily: FontConstant.ibmPlexSansArabic,
                            fontSize: FontSize.size9,
                            color: color.onSurfaceVariant,
                          ).copyWith(height: 1.25),
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    end: 0,
                    bottom: 0,
                    child: Container(
                      height: Spacing.offersDealFooterHeight,
                      color: offer.footerColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                offer.deliveryPrefixLabel ??
                                    locale.offers_countdown_label,
                                textAlign: TextAlign.end,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size10,
                                  color: color.onPrimary,
                                ),
                              ),
                              Text(
                                offer.deliveryLabel,
                                textAlign: TextAlign.end,
                                style: getMediumStyle(
                                  fontFamily: FontConstant.ibmPlexSansArabic,
                                  fontSize: FontSize.size11,
                                  color: color.onPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: Spacing.xs),
                          Icon(
                            Icons.schedule_rounded,
                            size: Spacing.iconLg,
                            color: color.onPrimary,
                            semanticLabel: locale.offers_countdown_label,
                          ),
                        ],
                      ),
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

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferDealCard extends StatelessWidget {
  const OfferDealCard({super.key, required this.offer, this.onTap});

  final OfferEntity offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final discountText = offer.formattedDiscount().isNotEmpty
        ? offer.formattedDiscount()
        : (offer.discountRate != null && offer.discountRate! > 0
              ? '${(offer.discountRate! * 100).toInt()}%'
              : '');

    return Material(
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
                if (discountText.isNotEmpty)
                  PositionedDirectional(
                    end: 0,
                    top: 0,
                    child: Container(
                      height: Spacing.offersDealBadgeHeight,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: color.primary,
                        borderRadius: const BorderRadiusDirectional.only(
                          topEnd: Radius.circular(Spacing.offersDealCardRadius),
                          bottomStart: Radius.circular(Spacing.sm),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        discountText,
                        textAlign: TextAlign.center,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
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
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Spacing.offersDealImageHeight,
                        child: Center(
                          child:
                              offer.bannerImageUrl != null &&
                                  offer.bannerImageUrl!.isNotEmpty
                              ? Image.network(
                                  offer.bannerImageUrl!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => Icon(
                                    Icons.local_offer_rounded,
                                    size: 36,
                                    color: color.primary,
                                  ),
                                )
                              : Icon(
                                  Icons.local_offer_rounded,
                                  size: 36,
                                  color: color.primary,
                                ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        offer.title(lang),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getSemiBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        offer.description(lang),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size10,
                          color: color.onSurfaceVariant,
                        ).copyWith(height: 1.20),
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
                    color: color.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: Spacing.iconMd,
                          color: color.onPrimary,
                          semanticLabel: locale.nav_offers,
                        ),
                        const SizedBox(width: Spacing.xs),
                        Text(
                          offer.promoCode != null && offer.promoCode!.isNotEmpty
                              ? offer.promoCode!
                              : locale.offer_deal_free_delivery,
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size11,
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
        ),
      ),
    );
  }
}

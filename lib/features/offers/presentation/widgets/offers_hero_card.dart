import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OffersHeroCard extends StatelessWidget {
  const OffersHeroCard({super.key, this.offer, this.onTap});

  final OfferEntity? offer;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final String discountHighlight;
    if (offer != null &&
        offer!.discountRate != null &&
        offer!.discountRate! > 0) {
      discountHighlight = '${(offer!.discountRate! * 100).toInt()}%';
    } else if (offer != null &&
        offer!.discountAmount != null &&
        offer!.discountAmount! > 0) {
      discountHighlight =
          '${offer!.discountAmount!.toInt()} ${lang == 'ar' ? 'د.ك' : 'KWD'}';
    } else {
      discountHighlight = '';
    }

    final cleanTitle = offer?.title(lang) ?? locale.offers_hero_subtitle;
    final description = offer?.isAvailable == false
        ? ErrorMessagePresenter.mapCode(
            context,
            offer?.availabilityReasonCode ?? 'offers.customer.unavailable',
          )
        : offer?.description(lang) ?? locale.offers_hero_description;

    final headline = discountHighlight.isNotEmpty
        ? (lang == 'ar' ? 'خصم $discountHighlight' : '$discountHighlight OFF')
        : locale.offers_hero_title;

    final bannerUrl = offer?.bannerImageUrl;

    return Semantics(
      label: headline,
      button: true,
      child: Material(
        color: color.surface.withValues(alpha: 0),
        child: InkWell(
          onTap: offer?.isAvailable == false ? null : onTap,
          borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.md),
            decoration: BoxDecoration(
              color: color.surface,
              borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
              border: Border.all(
                color: color.outlineVariant.withValues(alpha: 0.5),
                width: Spacing.border,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.shadow.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Network background image if available
                if (bannerUrl != null && bannerUrl.isNotEmpty)
                  PositionedDirectional(
                    end: 0,
                    bottom: 0,
                    top: 0,
                    child: Opacity(
                      opacity: 0.22,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Spacing.offersHeroRadius,
                        ),
                        child: AppCachedNetworkImage(
                          imageUrl: bannerUrl,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(
                            Spacing.offersHeroRadius,
                          ),
                          errorWidget: const SizedBox.shrink(),
                          loadingWidget: const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Row: Logo & Orange Circular Discount Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.mealMateLogo,
                          width: Spacing.offersHeroLogoWidth,
                        ),
                        if (discountHighlight.isNotEmpty)
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color.tertiary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: color.tertiary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  discountHighlight,
                                  textAlign: TextAlign.center,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size10,
                                    color: color.onTertiary,
                                  ),
                                ),
                                Text(
                                  lang == 'ar' ? 'خصم' : 'OFF',
                                  textAlign: TextAlign.center,
                                  style: getMediumStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size8,
                                    color: color.onTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.xs),

                    // Main Headline from backend
                    Text(
                      headline,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.primary,
                      ),
                    ),
                    const SizedBox(height: Spacing.xxs),

                    // Title from backend
                    Text(
                      cleanTitle,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xxs),

                    // Description from backend
                    Text(
                      description,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.sm),

                    // Button: اشترك الآن (Figma Orange Button)
                    Container(
                      width: Spacing.offersHeroButtonWidth,
                      height: Spacing.offersHeroButtonHeight,
                      decoration: BoxDecoration(
                        color: color.tertiary,
                        borderRadius: BorderRadius.circular(Spacing.radiusPill),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        locale.offers_hero_button,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


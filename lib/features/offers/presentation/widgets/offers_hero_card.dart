import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
      discountHighlight = '30%';
    }

    final cleanTitle = offer != null && offer!.title(lang).isNotEmpty
        ? offer!
            .title(lang)
            .replaceAll('[معاينة] ', '')
            .replaceAll('[معاينة]', '')
            .trim()
        : locale.offers_hero_subtitle;

    final rawDesc = offer != null && offer!.description(lang).isNotEmpty
        ? offer!.description(lang)
        : locale.offers_hero_description;
    final cleanDesc = rawDesc
        .replaceAll('بيانات معاينة معزولة لعرضها في تطبيق الجوال.', '')
        .trim();
    final description = cleanDesc.isNotEmpty ? cleanDesc : rawDesc;

    final headlinePrefix =
        locale.offers_hero_title.contains('خصم') ? 'خصم ' : 'Discount ';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Spacing.offersHeroRadius),
      child: Container(
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
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background if network image available
            if (offer?.bannerImageUrl != null &&
                offer!.bannerImageUrl!.isNotEmpty)
              PositionedDirectional(
                end: 0,
                bottom: 0,
                child: Opacity(
                  opacity: 0.12,
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(Spacing.offersHeroRadius),
                    child: Image.network(
                      offer!.bannerImageUrl!,
                      width: Spacing.offersHeroImageWidth,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Row: Logo & Circular Discount Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      Assets.mealMateLogo,
                      width: Spacing.offersHeroLogoWidth,
                    ),
                    Container(
                      width: 50,
                      height: 50,
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
                              fontSize: FontSize.size11,
                              color: color.onTertiary,
                            ),
                          ),
                          Text(
                            lang == 'ar' ? 'خصم' : 'OFF',
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size9,
                              color: color.onTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.xs),

                // Main headline
                Text(
                  '$headlinePrefix$discountHighlight',
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size18,
                    color: color.primary,
                  ),
                ),
                Text(
                  cleanTitle,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size14,
                    color: color.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Spacing.xxs),
                Text(
                  description,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Spacing.sm),

                // Button: اشترك الآن
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
    );
  }
}

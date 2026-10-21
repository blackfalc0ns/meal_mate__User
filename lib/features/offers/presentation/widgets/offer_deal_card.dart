import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_cached_network_image.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_countdown_bar.dart';

class OfferDealCard extends StatelessWidget {
  const OfferDealCard({super.key, required this.offer, this.onTap});

  final OfferEntity offer;
  final VoidCallback? onTap;

  Widget _buildPlaceholder(Color accentColor) {
    return Center(
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          offer.promoCode != null
              ? Icons.confirmation_number_outlined
              : Icons.local_offer_rounded,
          color: accentColor,
          size: Spacing.iconMd,
        ),
      ),
    );
  }

  Widget _buildHighlightedTitle(
    String title,
    Color accentColor,
    Color defaultColor,
  ) {
    final parts = title.trim().split(' ');
    if (parts.length >= 2) {
      final firstPart = parts.sublist(0, parts.length - 1).join(' ');
      final lastPart = parts.last;
      return Text.rich(
        TextSpan(
          text: '$firstPart ',
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size11,
            color: defaultColor,
          ),
          children: [
            TextSpan(
              text: lastPart,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: accentColor,
              ),
            ),
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      );
    }
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: getBoldStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size11,
        color: defaultColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final lang = Localizations.localeOf(context).languageCode;

    final isOrangeTheme =
        (offer.discountRate != null && offer.discountRate! >= 0.25) ||
        (offer.campaignId != null && offer.campaignId!.isNotEmpty);

    final accentColor = isOrangeTheme ? color.tertiary : color.primary;
    final onAccentColor = isOrangeTheme ? color.onTertiary : color.onPrimary;

    final cleanTitle = offer.title(lang);
    final descriptionText = offer.isAvailable
        ? offer.description(lang)
        : ErrorMessagePresenter.mapCode(
            context,
            offer.availabilityReasonCode ?? 'offers.customer.unavailable',
          );

    final String? badgeLabel;
    if (offer.discountRate != null && offer.discountRate! > 0) {
      final rate = offer.discountRate!;
      final pct = rate > 1.0 ? rate.round() : (rate * 100).round();
      badgeLabel = '-$pct%';
    } else if (offer.discountAmount != null && offer.discountAmount! > 0) {
      badgeLabel =
          '-${offer.discountAmount!.toInt()} ${lang == 'ar' ? 'د.ك' : 'KWD'}';
    } else if (offer.formattedDiscount().isNotEmpty) {
      badgeLabel = '-${offer.formattedDiscount()}';
    } else {
      badgeLabel = null;
    }

    return Material(
      color: color.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: offer.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
        child: Container(
          width: Spacing.offersDealCardWidth,
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.5),
              width: Spacing.border,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Badge (flush with topEnd corner)
              if (badgeLabel != null)
                Align(
                  alignment: isOrangeTheme
                      ? Alignment.topCenter
                      : AlignmentDirectional.topEnd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: isOrangeTheme
                          ? const BorderRadius.vertical(
                              bottom: Radius.circular(Spacing.xs),
                            )
                          : const BorderRadiusDirectional.only(
                              topEnd:
                                  Radius.circular(Spacing.offersDealCardRadius),
                              bottomStart: Radius.circular(Spacing.sm),
                            ),
                    ),
                    child: Text(
                      badgeLabel,
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size11,
                        color: onAccentColor,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(height: Spacing.xs),

              // Product / Meal Image from Network or Branded Placeholder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: Spacing.xxs,
                  ),
                  child: AppCachedNetworkImage(
                    imageUrl: offer.bannerImageUrl,
                    fit: BoxFit.contain,
                    errorWidget: _buildPlaceholder(accentColor),
                  ),
                ),
              ),

              // Title with highlighted keyword
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                child: _buildHighlightedTitle(
                  cleanTitle,
                  accentColor,
                  color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xxs),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                child: Text(
                  descriptionText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size9,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xs),

              // Bottom Countdown / Coupon Footer Bar (flush with bottom edge)
              OfferDealCountdownBar(
                endsAt: offer.endsAt,
                serverNowUtc: offer.serverNowUtc,
                serverObservedAtUtc: offer.serverObservedAtUtc,
                promoCode: offer.promoCode,
                accentColor: accentColor,
                onAccentColor: onAccentColor,
                bottomRadius: Spacing.offersDealCardRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

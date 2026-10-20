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

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final discountText = offer.discountRate != null && offer.discountRate! > 0
        ? '-${(offer.discountRate! * 100).toInt()}%'
        : (offer.discountAmount != null && offer.discountAmount! > 0
              ? '-${offer.discountAmount!.toInt()} ${lang == 'ar' ? 'د.ك' : 'KWD'}'
              : (offer.formattedDiscount().isNotEmpty
                    ? '-${offer.formattedDiscount()}'
                    : ''));

    final isOrangeTheme =
        (offer.discountRate != null && offer.discountRate! >= 0.25) ||
        (offer.campaignId != null);

    final accentColor = isOrangeTheme ? color.tertiary : color.primary;
    final onAccentColor =
        isOrangeTheme ? color.onTertiary : color.onPrimary;

    final cleanTitle = offer
        .title(lang)
        .replaceAll('[معاينة] ', '')
        .replaceAll('[معاينة]', '')
        .trim();

    final rawDesc = offer.description(lang);
    final cleanDesc = rawDesc
        .replaceAll('بيانات معاينة معزولة لعرضها في تطبيق الجوال.', '')
        .trim();
    final descriptionText = cleanDesc.isNotEmpty ? cleanDesc : rawDesc;

    final duration = offer.remainingDuration;
    final hasTimer = duration > Duration.zero;
    final String timerDigits;
    if (hasTimer) {
      if (duration.inDays > 0) {
        timerDigits =
            '${duration.inDays} ${lang == 'ar' ? 'يوم' : 'd'} : ${duration.inHours % 24} ${lang == 'ar' ? 'ساعة' : 'h'}';
      } else {
        timerDigits = _formatDuration(duration);
      }
    } else if (offer.promoCode != null && offer.promoCode!.isNotEmpty) {
      timerDigits = offer.promoCode!;
    } else {
      timerDigits = locale.offers_featured_button;
    }

    return Material(
      color: color.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
        child: Container(
          width: Spacing.offersDealCardWidth,
          padding: const EdgeInsets.all(Spacing.sm),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.offersDealCardRadius),
            border: Border.all(
              color: color.outlineVariant.withValues(alpha: 0.6),
              width: Spacing.border,
            ),
            boxShadow: [
              BoxShadow(
                color: color.shadow.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Top Discount Badge (Solid colored pill like Figma)
              if (discountText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.xs,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(Spacing.xs),
                  ),
                  child: Text(
                    discountText,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: onAccentColor,
                    ),
                  ),
                )
              else
                const SizedBox(height: Spacing.md),

              // Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cleanTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxs),
                  Text(
                    descriptionText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size10,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              // Bottom Countdown / Action Pill
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xs,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
                child: hasTimer
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            locale.offers_countdown_label,
                            style: getMediumStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size8,
                              color: onAccentColor.withValues(alpha: 0.92),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 10,
                                color: onAccentColor,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  timerDigits,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size9,
                                    color: onAccentColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            offer.promoCode != null
                                ? Icons.confirmation_number_outlined
                                : Icons.arrow_forward_rounded,
                            size: Spacing.iconSm,
                            color: onAccentColor,
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Flexible(
                            child: Text(
                              timerDigits,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size9,
                                color: onAccentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

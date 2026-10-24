import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/services/promo_code_session.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_coupon_border_painter.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferQuickPreviewSheet extends StatelessWidget {
  const OfferQuickPreviewSheet({super.key, required this.offer});

  final OfferEntity offer;

  String _formatDuration(Duration duration, dynamic locale, String lang) {
    if (duration == Duration.zero) return locale.offer_countdown_expired;
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final daysStr = days.toString().padLeft(2, '0');
    final hoursStr = hours.toString().padLeft(2, '0');
    final dayWord = lang == 'ar' ? 'يوم' : 'days';
    final hourWord = lang == 'ar' ? 'ساعة' : 'hrs';
    return '${locale.offer_countdown_prefix} : $daysStr $dayWord : $hoursStr $hourWord';
  }

  void _onRedeem(BuildContext context) {
    final locale = context.localization;
    final promoCode = offer.promoCode?.trim().toUpperCase();

    if (promoCode != null && promoCode.isNotEmpty) {
      PromoCodeSession.setActivePromoCode(promoCode);
      unawaited(Clipboard.setData(ClipboardData(text: promoCode)));
      CustomSnackbar.showSuccess(
        context: context,
        message: locale.offer_details_copy_code,
      );
    }

    Navigator.of(context).pop();

    if (offer.isDirectPurchase) {
      unawaited(
        Navigator.of(context).pushNamed(
          AppRoutes.redeemPackage,
          arguments: offer,
        ),
      );
    } else {
      unawaited(
        Navigator.of(context).pushNamed(AppRoutes.subscriptionProgramSelection),
      );
    }
  }

  void _copyCode(BuildContext context) {
    final locale = context.localization;
    final promoCode = offer.promoCode?.trim().toUpperCase();
    if (promoCode == null || promoCode.isEmpty) return;

    unawaited(Clipboard.setData(ClipboardData(text: promoCode)));
    PromoCodeSession.setActivePromoCode(promoCode);
    CustomSnackbar.showSuccess(
      context: context,
      message: locale.offer_details_copy_code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    final title = offer.title(lang);
    final description = offer.description(lang);
    final discountStr = offer.formattedDiscount();
    final promoCode = offer.promoCode?.trim().toUpperCase() ?? '';
    final terms = offer.terms(lang);
    final termsText = (terms != null && terms.trim().isNotEmpty)
        ? terms
        : locale.offer_details_info_terms_description;

    final durationText = _formatDuration(offer.remainingDuration, locale, lang);
    final discountLabel = lang == 'ar' ? 'خصم' : 'Discount';

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.lg),
        ),
      ),
      padding: const EdgeInsets.only(
        left: Spacing.lg,
        right: Spacing.lg,
        top: Spacing.sm,
        bottom: Spacing.lg,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: Spacing.sm),
                decoration: BoxDecoration(
                  color: color.outlineVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
            ),

            // Top Header: Close button (X) and Title
            Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: color.onSurface,
                      size: 22,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xl),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size16,
                      color: color.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),

            // Hero section with Dish image and big discount
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text side (Title, Discount, Subtitle)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // "خصم 20%"
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            discountLabel,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size14,
                              color: color.onSurface,
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            discountStr.isNotEmpty ? discountStr : '20%',
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size28,
                              color: color.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xxs),

                      // Title
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size14,
                          color: color.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.xxs),

                      // Subtitle
                      Text(
                        description.isNotEmpty
                            ? description
                            : locale.offer_details_hero_description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size11,
                          color: color.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.md),

                // Dish image
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.shadow.withValues(alpha: 0.08),
                        blurRadius: Spacing.sm,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: (offer.bannerImageUrl != null &&
                            offer.bannerImageUrl!.trim().isNotEmpty)
                        ? Image.network(
                            offer.bannerImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Image.asset(
                              'assets/images/meal_details/figma/meal_details_hero.png',
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/images/meal_details/figma/meal_details_hero.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.base),

            // Grouped Info Box with 4 rows & dividers
            DecoratedBox(
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(Spacing.radiusLg),
                border: Border.all(
                  color: color.outlineVariant.withValues(alpha: 0.5),
                  width: Spacing.border,
                ),
              ),
              child: Column(
                children: [
                  // Row 1: تفاصيل العرض
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          color: color.primary,
                          size: 22,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.offer_details_info_title,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size12,
                                  color: color.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                description.isNotEmpty
                                    ? description
                                    : (discountStr.isNotEmpty
                                        ? '$discountLabel $discountStr'
                                        : locale.offer_details_info_summary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: color.outlineVariant.withValues(alpha: 0.35),
                  ),

                  // Row 2: مدة العرض
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: color.primary,
                          size: 22,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.offer_details_info_duration_label,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size12,
                                  color: color.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                durationText,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size11,
                                  color: color.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: color.outlineVariant.withValues(alpha: 0.35),
                  ),

                  // Row 3: رمز الخصم
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.confirmation_number_outlined,
                          color: color.primary,
                          size: 22,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            locale.offer_details_code_label,
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.primary,
                            ),
                          ),
                        ),
                        if (promoCode.isNotEmpty) ...[
                          // Dashed code badge
                          CustomPaint(
                            painter: OfferDetailsCouponBorderPainter(
                              color: color.primary,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.md,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: color.primary.withValues(alpha: 0.06),
                                borderRadius:
                                    BorderRadius.circular(Spacing.radiusSm),
                              ),
                              child: Text(
                                promoCode,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size13,
                                  color: color.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),

                          // Copy button
                          InkWell(
                            onTap: () => _copyCode(context),
                            borderRadius:
                                BorderRadius.circular(Spacing.radiusSm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.sm,
                                vertical: Spacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: color.surface,
                                borderRadius:
                                    BorderRadius.circular(Spacing.radiusSm),
                                border: Border.all(
                                  color: color.outlineVariant,
                                  width: Spacing.border,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    locale.offer_details_info_copy_code,
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size11,
                                      color: color.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: Spacing.xs),
                                  Icon(
                                    Icons.copy_rounded,
                                    size: 14,
                                    color: color.onSurface,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: color.outlineVariant.withValues(alpha: 0.35),
                  ),

                  // Row 4: الشروط والأحكام
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: color.primary,
                          size: 22,
                        ),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.offer_details_info_terms_label,
                                style: getBoldStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size12,
                                  color: color.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                termsText,
                                style: getRegularStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size10,
                                  color: color.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.lg),

            // Bottom CTA button
            AppButton(
              text: locale.offers_coupon_button,
              onPressed: !offer.isAvailable ||
                      offer.isExpired ||
                      offer.isSoldOut ||
                      offer.purchaseMode == OfferPurchaseMode.unknown
                  ? null
                  : () => _onRedeem(context),
            ),
          ],
        ),
      ),
    );
  }
}

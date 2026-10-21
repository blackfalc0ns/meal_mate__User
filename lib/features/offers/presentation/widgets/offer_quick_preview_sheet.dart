import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferQuickPreviewSheet extends StatelessWidget {
  const OfferQuickPreviewSheet({super.key, required this.offer});

  final OfferEntity offer;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final lang = Localizations.localeOf(context).languageCode;

    return Container(
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Spacing.lg),
        ),
      ),
      padding: const EdgeInsets.all(Spacing.lg),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: color.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    offer.title(lang),
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size16,
                      color: color.onSurface,
                    ),
                  ),
                ),
                if (offer.formattedDiscount().isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.sm,
                      vertical: Spacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: color.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(Spacing.xs),
                    ),
                    child: Text(
                      offer.formattedDiscount(),
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              offer.isAvailable
                  ? offer.description(lang)
                  : ErrorMessagePresenter.mapCode(
                      context,
                      offer.availabilityReasonCode ??
                          'offers.customer.unavailable',
                    ),
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size13,
                color: color.onSurfaceVariant,
              ),
            ),
            if (offer.promoCode != null && offer.promoCode!.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: color.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Spacing.sm),
                  border: Border.all(
                    color: color.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      locale.offer_details_code_label,
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: Spacing.sm),
                    Text(
                      offer.promoCode!,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size14,
                        color: color.primary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        unawaited(
                          Clipboard.setData(
                            ClipboardData(text: offer.promoCode!),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(locale.offer_details_copy_code),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.xs),
                        child: Icon(
                          Icons.copy_rounded,
                          size: 18,
                          color: color.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (offer.terms(lang) != null && offer.terms(lang)!.isNotEmpty) ...[
              const SizedBox(height: Spacing.md),
              Text(
                offer.terms(lang)!,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.outline,
                ),
              ),
            ],
            const SizedBox(height: Spacing.xl),
            AppButton(
              text: offer.isCouponOnly
                  ? locale.offers_coupon_button
                  : locale.offer_details_plan_section_title,
              onPressed:
                  (!offer.isAvailable ||
                      (offer.isCouponOnly &&
                          offer.promoCode?.trim().isNotEmpty != true) ||
                      offer.isExpired ||
                      offer.isSoldOut ||
                      offer.purchaseMode == OfferPurchaseMode.unknown)
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      if (offer.isDirectPurchase) {
                        unawaited(
                          Navigator.of(context).pushNamed(
                            AppRoutes.redeemPackage,
                            arguments: offer,
                          ),
                        );
                      } else if (offer.isCouponOnly) {
                        if (offer.promoCode != null &&
                            offer.promoCode!.isNotEmpty) {
                          unawaited(
                            Navigator.of(context).pushNamed(
                              AppRoutes.promoCodeInput,
                              arguments: offer.promoCode,
                            ),
                          );
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }
}

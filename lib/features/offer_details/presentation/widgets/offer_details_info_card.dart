import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_coupon_box.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_row.dart';

class OfferDetailsInfoCard extends StatelessWidget {
  const OfferDetailsInfoCard({
    super.key,
    this.details,
    this.summaryText,
    this.durationText,
    this.couponCode,
    this.termsText,
    this.accentColor,
    this.onCopyCode,
    this.showSummaryRow = true,
    this.showCouponSection = true,
  });

  final OfferDetailsData? details;
  final String? summaryText;
  final String? durationText;
  final String? couponCode;
  final String? termsText;
  final Color? accentColor;
  final VoidCallback? onCopyCode;
  final bool showSummaryRow;
  final bool showCouponSection;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final rows =
        details?.infoRows ??
        [
          if (showSummaryRow)
            OfferDetailsInfoRowData(
              label: locale.offer_details_info_title,
              value: summaryText ?? locale.offer_details_info_summary,
              icon: OfferDetailsIconType.tag,
            ),
          OfferDetailsInfoRowData(
            label: locale.offer_details_info_duration_label,
            value: durationText ?? locale.offer_details_hero_timer_label,
            icon: OfferDetailsIconType.calendar,
          ),
          OfferDetailsInfoRowData(
            label: locale.offer_details_info_terms_label,
            value: termsText ?? locale.offer_details_info_terms_description,
            icon: OfferDetailsIconType.document,
          ),
        ];
    final resolvedCouponCode = details?.couponCode ?? couponCode;

    return Container(
      height: 250,
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.base,
        end: Spacing.base,
        top: Spacing.sm,
        bottom: Spacing.base,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        border: Border.all(color: color.outlineVariant),
        borderRadius: BorderRadius.circular(Spacing.offerDetailsInfoCardRadius),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.1),
            blurRadius: Spacing.sm,
            offset: const Offset(0, Spacing.xs),
          ),
        ],
      ),
      child: Column(
        children: [
          ...List.generate(rows.length, (index) {
            final row = rows[index];
            final isLast = index == rows.length - 1;

            return Column(
              children: [
                OfferDetailsInfoRow(row: row),
                if (!isLast)
                  Divider(
                    height: Spacing.border,
                    thickness: Spacing.border,
                    color: color.outlineVariant.withValues(alpha: 0.45),
                  ),
              ],
            );
          }),
          if (showCouponSection && resolvedCouponCode != null) ...[
            const SizedBox(height: Spacing.base),
            Semantics(
              label: locale.offer_details_info_copy_code,
              child: OfferDetailsCouponBox(code: resolvedCouponCode),
            ),
          ],
        ],
      ),
    );
  }
}

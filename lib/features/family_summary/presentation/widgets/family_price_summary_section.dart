import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_price_details_card.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';

class FamilyPriceSummarySection extends StatelessWidget {
  const FamilyPriceSummarySection({
    super.key,
    required this.summary,
    this.pendingCheckout,
  });

  final FamilySummaryEntity? summary;
  final FamilyPendingCheckoutEntity? pendingCheckout;

  @override
  Widget build(BuildContext context) {
    final details = _priceDetails(context);

    if (details == null && pendingCheckout == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (pendingCheckout?.holdExpiresAtUtc != null) ...[
          const SizedBox(height: Spacing.sm),
          _buildHoldStatus(context, pendingCheckout!),
        ],
        if (details != null) ...[
          const SizedBox(height: Spacing.lg),
          FamilyPriceDetailsCard(details: details),
        ],
      ],
    );
  }

  Widget _buildHoldStatus(
    BuildContext context,
    FamilyPendingCheckoutEntity pending,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isHoldActive = !pending.isHoldExpired;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: isHoldActive
            ? color.tertiary.withValues(alpha: 0.08)
            : color.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(
          color: isHoldActive
              ? color.tertiary.withValues(alpha: 0.3)
              : color.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isHoldActive ? Icons.timer_outlined : Icons.timer_off_outlined,
            size: Spacing.iconSm,
            color: isHoldActive ? color.tertiary : color.error,
          ),
          const SizedBox(width: Spacing.xs),
          Text(
            isHoldActive
                ? locale.billing_uncompleted_hold_active
                : locale.billing_uncompleted_hold_expired,
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size11,
              color: isHoldActive ? color.tertiary : color.error,
            ),
          ),
        ],
      ),
    );
  }

  FamilyPaymentPriceDetailsUiModel? _priceDetails(BuildContext context) {
    final locale = context.localization;
    final data = summary;
    if (data == null) {
      final pending = pendingCheckout;
      if (pending?.finalPrice == null) return null;
      final currency = resolveFamilyCurrency(locale, null);
      return FamilyPaymentPriceDetailsUiModel(
        badge: '',
        note: locale.family_payment_note,
        totalLabel: locale.family_total,
        totalValue: '${formatFamilyPrice(pending!.finalPrice!)} $currency',
        rows: [
          FamilyPaymentPriceRowUiModel(
            label: locale.family_total,
            value: formatFamilyPrice(pending.finalPrice!),
            isStrong: true,
          ),
        ],
      );
    }

    final currency = resolveFamilyCurrency(locale, data.currencyCode);
    final discountPercentInt = (data.familyDiscountPercent * 100).round();
    final discountLabel = discountPercentInt > 0
        ? locale.family_package_discount_badge('$discountPercentInt%')
        : '';

    return FamilyPaymentPriceDetailsUiModel(
      badge: discountLabel,
      note: locale.family_payment_note,
      totalLabel: locale.family_total,
      totalValue: '${formatFamilyPrice(data.finalPrice)} $currency',
      rows: [
        FamilyPaymentPriceRowUiModel(
          label: data.managerPrepaid
              ? locale.family_new_members_subtotal
              : locale.family_price_duration_total,
          value: formatFamilyPrice(
            data.managerPrepaid ? data.newMembersSubtotal : data.subtotal,
          ),
        ),
        if (data.managerPrepaid)
          FamilyPaymentPriceRowUiModel(
            label: locale.family_primary_member,
            value: locale.billing_paid,
            showCurrency: false,
          ),
        if (data.familyDiscountAmount > 0)
          FamilyPaymentPriceRowUiModel(
            label: discountPercentInt > 0
                ? locale.family_package_discount_badge('$discountPercentInt%')
                : locale.family_price_discount,
            value: '-${formatFamilyPrice(data.familyDiscountAmount)}',
            isDiscount: true,
          ),
        if (data.coupon != null &&
            data.coupon!.isValid &&
            data.coupon!.discountAmount > 0)
          FamilyPaymentPriceRowUiModel(
            label: '${locale.offer_details_code_label} (${data.coupon!.code})',
            value: '-${formatFamilyPrice(data.coupon!.discountAmount)}',
            isDiscount: true,
          ),
        FamilyPaymentPriceRowUiModel(
          label: locale.family_total,
          value: formatFamilyPrice(data.finalPrice),
          isStrong: true,
        ),
      ],
    );
  }
}

typedef FamilyPaymentPriceSection = FamilyPriceSummarySection;

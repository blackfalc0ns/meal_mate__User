import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_price_details_card.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyPriceSummarySection extends StatelessWidget {
  const FamilyPriceSummarySection({super.key, required this.summary});

  final FamilySummaryEntity? summary;

  @override
  Widget build(BuildContext context) {
    final details = _priceDetails(context);

    if (details == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: Spacing.lg),
        FamilyPriceDetailsCard(details: details),
      ],
    );
  }

  FamilyPaymentPriceDetailsUiModel? _priceDetails(BuildContext context) {
    final locale = context.localization;
    final data = summary;
    if (data == null) return null;

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

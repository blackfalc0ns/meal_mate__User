import 'package:json_annotation/json_annotation.dart';

part 'subscription_pricing_preview_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionPricingPreviewResponseDto {
  const SubscriptionPricingPreviewResponseDto({
    this.basePlanPrice,
    this.fridayAddonPrice,
    this.grossAmount,
    this.grossPrice,
    this.campaignDiscountApplied,
    this.offerDiscount,
    this.promoCodeDiscountApplied,
    this.codeDiscount,
    this.totalDiscountApplied,
    this.vatAmount,
    this.walletCreditApplied,
    this.walletCredit,
    this.finalCustomerPrice,
    this.currencyCode,
    this.currency,
    this.serviceDatesCount,
    this.serviceDaysCount,
    this.fridayCount,
    this.fridayDaysCount,
  });

  final double? basePlanPrice;
  final double? fridayAddonPrice;
  final double? grossAmount;
  final double? grossPrice;
  final double? campaignDiscountApplied;
  final double? offerDiscount;
  final double? promoCodeDiscountApplied;
  final double? codeDiscount;
  final double? totalDiscountApplied;
  final double? vatAmount;
  final double? walletCreditApplied;
  final double? walletCredit;
  final double? finalCustomerPrice;
  final String? currencyCode;
  final String? currency;
  final int? serviceDatesCount;
  final int? serviceDaysCount;
  final int? fridayCount;
  final int? fridayDaysCount;

  double get resolvedGross => grossAmount ?? grossPrice ?? basePlanPrice ?? 0.0;
  double get resolvedOfferDiscount =>
      campaignDiscountApplied ?? offerDiscount ?? 0.0;
  double get resolvedCodeDiscount =>
      promoCodeDiscountApplied ?? codeDiscount ?? 0.0;
  double get resolvedTotalDiscount =>
      totalDiscountApplied ?? (resolvedOfferDiscount + resolvedCodeDiscount);
  double get resolvedWalletCredit => walletCreditApplied ?? walletCredit ?? 0.0;
  double get resolvedFinalPrice => finalCustomerPrice ?? 0.0;
  String get resolvedCurrency => currencyCode ?? currency ?? 'KWD';
  int get resolvedServiceDays => serviceDatesCount ?? serviceDaysCount ?? 0;
  int get resolvedFridayDays => fridayCount ?? fridayDaysCount ?? 0;

  factory SubscriptionPricingPreviewResponseDto.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SubscriptionPricingPreviewResponseDtoFromJson(json);
}

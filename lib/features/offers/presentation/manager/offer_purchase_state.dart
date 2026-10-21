import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';

class OfferPurchaseState {
  const OfferPurchaseState({
    this.isOptionsLoading = false,
    this.isSummaryLoading = false,
    this.isMethodsLoading = false,
    this.isCheckoutLoading = false,
    this.options,
    this.offerDetails,
    this.earliestStartDate,
    this.selectedOption,
    this.summary,
    this.methods = const [],
    this.selectedMethod,
    this.promoCode,
    this.termsAccepted = false,
    this.quoteExpiresAtLocal,
    this.checkout,
    this.failure,
  });

  final bool isOptionsLoading;
  final bool isSummaryLoading;
  final bool isMethodsLoading;
  final bool isCheckoutLoading;
  final OfferPurchaseOptionsEntity? options;
  final OfferEntity? offerDetails;
  final DateTime? earliestStartDate;
  final OfferPurchaseOptionEntity? selectedOption;
  final SubscriptionSummaryEntity? summary;
  final List<PaymentMethodEntity> methods;
  final PaymentMethodEntity? selectedMethod;
  final String? promoCode;
  final bool termsAccepted;
  final DateTime? quoteExpiresAtLocal;
  final PaymentCheckoutEntity? checkout;
  final Failure? failure;

  bool get canPay =>
      !isCheckoutLoading &&
      !isOptionsLoading &&
      !isSummaryLoading &&
      selectedOption != null &&
      selectedOption!.canCheckout &&
      summary?.canCheckout == true &&
      summary?.quoteId?.isNotEmpty == true &&
      quoteExpiresAtLocal?.isAfter(DateTime.now()) == true &&
      termsAccepted &&
      selectedMethod?.isAvailable == true &&
      selectedMethod?.id != null &&
      summary!.finalPrice > 0;

  OfferPurchaseState copyWith({
    bool? isOptionsLoading,
    bool? isSummaryLoading,
    bool? isMethodsLoading,
    bool? isCheckoutLoading,
    OfferPurchaseOptionsEntity? options,
    OfferEntity? offerDetails,
    DateTime? earliestStartDate,
    OfferPurchaseOptionEntity? selectedOption,
    bool clearSelectedOption = false,
    SubscriptionSummaryEntity? summary,
    bool clearSummary = false,
    List<PaymentMethodEntity>? methods,
    PaymentMethodEntity? selectedMethod,
    bool clearSelectedMethod = false,
    String? promoCode,
    bool clearPromoCode = false,
    bool? termsAccepted,
    DateTime? quoteExpiresAtLocal,
    bool clearQuoteExpiry = false,
    PaymentCheckoutEntity? checkout,
    bool clearCheckout = false,
    Failure? failure,
    bool clearFailure = false,
  }) => OfferPurchaseState(
    isOptionsLoading: isOptionsLoading ?? this.isOptionsLoading,
    isSummaryLoading: isSummaryLoading ?? this.isSummaryLoading,
    isMethodsLoading: isMethodsLoading ?? this.isMethodsLoading,
    isCheckoutLoading: isCheckoutLoading ?? this.isCheckoutLoading,
    options: options ?? this.options,
    offerDetails: offerDetails ?? this.offerDetails,
    earliestStartDate: earliestStartDate ?? this.earliestStartDate,
    selectedOption: clearSelectedOption
        ? null
        : selectedOption ?? this.selectedOption,
    summary: clearSummary ? null : summary ?? this.summary,
    methods: methods ?? this.methods,
    selectedMethod: clearSelectedMethod
        ? null
        : selectedMethod ?? this.selectedMethod,
    promoCode: clearPromoCode ? null : promoCode ?? this.promoCode,
    termsAccepted: termsAccepted ?? this.termsAccepted,
    quoteExpiresAtLocal: clearQuoteExpiry
        ? null
        : quoteExpiresAtLocal ?? this.quoteExpiresAtLocal,
    checkout: clearCheckout ? null : checkout ?? this.checkout,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

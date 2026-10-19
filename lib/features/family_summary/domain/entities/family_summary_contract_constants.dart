abstract final class FamilySummaryContractConstants {
  static const int clientContractVersion = 1;
  static const String defaultSuccessCallbackUrl = 'mealmate://checkout/success';
  static const String defaultErrorCallbackUrl = 'mealmate://checkout/error';
  static const int defaultRenewalPaymentMethodId = 3;
}

typedef FamilyCheckoutContractConstants = FamilySummaryContractConstants;

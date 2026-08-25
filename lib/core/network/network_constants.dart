abstract class NetworkConstants {
  static const String baseUrl = "http://maelmate.runasp.net";
  static const String authorization = 'Authorization';
  static const String bearer = "Bearer";
}

abstract class EndPoints {
  static const String login = '/api/v1/auth/customers/login';
  static const String register = '/api/v1/auth/customers/register';
  static const String verifyPhone = '/api/v1/auth/customers/verify-phone';
  static const String resendPhoneOtp =
      '/api/v1/auth/customers/resend-phone-otp';
  static const String forgotPassword = '/api/v1/auth/customers/forgot-password';
  static const String resetPassword = '/api/v1/auth/customers/reset-password';
  static const String resendPasswordOtp =
      '/api/v1/auth/customers/resend-password-otp';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String callingCodes = '/api/v1/catalog/calling-codes';
  static const String locations = '/api/v1/catalog/locations';
  static const String countryRegions =
      '/api/v1/catalog/countries/{countryCode}/regions';
  static const String customerProfile = '/api/v1/customers/me';
  static const String uploads = '/api/v1/uploads';
  static const String uploadContent = '/api/v1/uploads/content';
  static const String customerProfileImage =
      '/api/v1/customers/me/profile-image';
  static const String customerAddresses = '/api/v1/customers/me/addresses';
  static const String customerAddress =
      '/api/v1/customers/me/addresses/{addressId}';
  static const String customerPassword = '/api/v1/customers/me/password';
  static const String customerFoodPreferencesDisliked =
      '/api/v1/customers/me/food-preferences/disliked-ingredients';
  static const String customerFoodPreferencesAllergies =
      '/api/v1/customers/me/food-preferences/allergies';
  static const String customerFoodPreferencesDietary =
      '/api/v1/customers/me/food-preferences/dietary';
  static const String subscriptionTypes =
      '/api/v1/customer/subscription-flow/types';
  static const String subscriptionConversionOptions =
      '/api/v1/customer/subscriptions/current/conversion-options';
  static const String convertFromIndividual =
      '/api/v1/customer/family-subscription-flow/convert-from-individual';
  static const String familySubscriptionFlowAbandonDraft =
      '/api/v1/customer/family-subscription-flow/abandon-draft';
  static const String subscriptionPrograms =
      '/api/v1/customer/subscription-flow/programs';
  static const String subscriptionProgramBundles =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles';
  static const String subscriptionDurations =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/durations';
  static const String subscriptionTiers =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/tiers';
  static const String subscriptionTierRestaurants =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/tiers/{tier}/restaurants';
  static const String subscriptionRestaurantDetails =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/restaurants/{restaurantId}/details';
  static const String subscriptionSummary =
      '/api/v1/customer/subscription-flow/summary';
  static const String subscriptionReadiness =
      '/api/v1/customer/subscription-flow/readiness';
  static const String paymentMethods =
      '/api/v1/customer/subscription-flow/payment-methods';
  static const String subscriptionCheckout =
      '/api/v1/customer/subscriptions/checkout';
  static const String subscriptionPaymentStatus =
      '/api/v1/customer/subscriptions/{subscriptionId}/payment';
  static const String subscriptionCalendar =
      '/api/v1/customer/subscriptions/{subscriptionId}/calendar';
  static const String customerSubscriptionCurrent =
      '/api/v1/customer/subscriptions/current';
  static const String customerInvoices = '/api/v1/customer/invoices';
  static const String customerDefaultPaymentMethod =
      '/api/v1/customer/payment-methods/default';
  static const String customerSubscriptionFreezePolicy =
      '/api/v1/customer/subscriptions/freeze-policy';
  static const String familySubscriptionFlowPackages =
      '/api/v1/customer/family-subscription-flow/packages';
  static const String familySubscriptionFlowRelationships =
      '/api/v1/customer/family-subscription-flow/relationships';
  static const String familySubscriptionFlowPrograms =
      '/api/v1/customer/family-subscription-flow/programs';
  static const String familySubscriptionFlowProgramBundles =
      '/api/v1/customer/family-subscription-flow/programs/{programId}/bundles';
  static const String familySubscriptionFlowMetadata =
      '/api/v1/customer/family-subscription-flow/metadata';
  static const String familySubscriptionFlowCurrent =
      '/api/v1/customer/family-subscription-flow/current';
  static const String familySubscriptionFlowGroup =
      '/api/v1/customer/family-subscription-flow/group';
  static const String familySubscriptionFlowMembers =
      '/api/v1/customer/family-subscription-flow/members';
  static const String familySubscriptionFlowMember =
      '/api/v1/customer/family-subscription-flow/members/{memberId}';
  static const String familySubscriptionFlowMemberPlan =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/plan';
  static const String familySubscriptionFlowSummary =
      '/api/v1/customer/family-subscription-flow/summary';
  static const String familySubscriptionFlowPaymentMethods =
      '/api/v1/customer/family-subscription-flow/payment-methods';
  static const String familySubscriptionFlowCheckout =
      '/api/v1/customer/family-subscription-flow/checkout';
}

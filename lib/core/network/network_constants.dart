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
  static const String customerFoodPreferences =
      '/api/v1/customers/me/food-preferences';
  static const String customerFoodPreferencesCatalog =
      '/api/v1/customers/me/food-preferences/catalog';
  static const String customerFoodPreferencesAllergies =
      '/api/v1/customers/me/food-preferences/allergies';
  static const String subscriptionTypes =
      '/api/v1/customer/subscription-flow/types';
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
}

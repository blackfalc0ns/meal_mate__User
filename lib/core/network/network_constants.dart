abstract class NetworkConstants {
  static const String baseUrl = "https://api.trymealmate.com";
  static const String authorization = 'Authorization';
  static const String bearer = "Bearer";
}

abstract class EndPoints {
  static const String customerSupportOptions =
      '/api/v1/customer/support/options';
  static const String customerSupportIssues = '/api/v1/customer/support/issues';
  static const String customerSupportIssue = '$customerSupportIssues/{caseId}';
  static const String customerSupportIssueMessages =
      '$customerSupportIssue/messages';
  static const String supportDeliveredBoxes = '/api/v1/support/delivered-boxes';
  static const String eligibleSubscriptionStartDates =
      '/api/v1/customer/subscription-flow/eligible-start-dates';
  static const String customerCompensations = '/api/v1/customer/compensations';
  static const String compensationAlternativeDates =
      '$customerCompensations/{compensationId}/alternative-dates';
  static const String compensationChoose =
      '$customerCompensations/{compensationId}/choose';
  static const String login = '/api/v1/auth/customers/login';
  static const String register = '/api/v1/auth/customers/register';
  static const String verifyPhone = '/api/v1/auth/customers/verify-phone';
  static const String resendPhoneOtp =
      '/api/v1/auth/customers/resend-phone-otp';
  static const String forgotPassword = '/api/v1/auth/customers/forgot-password';
  static const String resetPassword = '/api/v1/auth/customers/reset-password';
  static const String resendPasswordOtp =
      '/api/v1/auth/customers/resend-password-otp';
  static const String familyFirstLoginVerifyOtp =
      '/api/v1/auth/customers/family-first-login/verify-otp';
  static const String familyFirstLoginSetPassword =
      '/api/v1/auth/customers/family-first-login/set-password';
  static const String familyFirstLoginResendOtp =
      '/api/v1/auth/customers/family-first-login/resend-otp';
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
  static const String customerAddressPreviewCoverage =
      '/api/v1/customers/me/addresses/preview-coverage';
  static const String customerExistingAddressPreviewCoverage =
      '/api/v1/customers/me/addresses/{addressId}/preview-coverage';
  static const String customerAddressSetDefault =
      '/api/v1/customers/me/addresses/{addressId}/set-default';
  static const String mapsGeocode = '/api/v1/maps/geocode';
  static const String mapsReverseGeocode = '/api/v1/maps/reverse-geocode';
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
  static const String subscriptionCatalogPrograms =
      '/api/v1/customer/subscription-flow/catalog/programs';
  static const String subscriptionProgramBundles =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles';
  static const String subscriptionCatalogProgramBundles =
      '/api/v1/customer/subscription-flow/catalog/programs/{programId}/bundles';
  static const String subscriptionDurations =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/durations';
  static const String subscriptionTiers =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/tiers';
  static const String subscriptionCatalogTiers =
      '/api/v1/customer/subscription-flow/catalog/programs/{programId}/bundles/{bundleId}/tiers';
  static const String subscriptionPrerequisites =
      '/api/v1/customer/subscription-flow/prerequisites';
  static const String subscriptionTierRestaurants =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/tiers/{tier}/restaurants';
  static const String subscriptionProgramTierRestaurants =
      '/api/v1/customer/subscription-flow/programs/{programId}/tiers/{tier}/restaurants';
  static const String subscriptionRestaurantDetails =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/restaurants/{restaurantId}/details';
  static const String subscriptionMealDetails =
      '/api/v1/customer/subscription-flow/programs/{programId}/bundles/{bundleId}/restaurants/{restaurantId}/meals/{mealId}';
  static const String subscriptionSummary =
      '/api/v1/customer/subscription-flow/summary';
  static const String subscriptionRestaurantAvailability =
      '/api/v1/customer/subscription-flow/restaurant-availability';
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
  static const String subscriptionCalendarDay =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}';
  static const String subscriptionCalendarRestaurants =
      '/api/v1/customer/subscriptions/{subscriptionId}/restaurants';
  static const String subscriptionCalendarDayRestaurants =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/restaurants';
  static const String subscriptionCalendarDayRestaurant =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/restaurant';
  static const String subscriptionCalendarRestaurantMeals =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/restaurants/{restaurantId}/meals';
  static const String subscriptionCalendarAvailableMeals =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/meals/available';
  static const String subscriptionCalendarDayMeals =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/meals/slot';
  static const String subscriptionCalendarAutoSelect =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/complete';
  static const String subscriptionCalendarConfirm =
      '/api/v1/customer/subscriptions/{subscriptionId}/days/{date}/confirm';
  static const String customerDeliveryWidget =
      '/api/v1/customer/delivery-widget';
  static const String customerSubscriptionDayDeliveryDetails =
      '/api/v1/customer/subscription-days/{subscriptionDayId}/delivery-details';
  static const String customerSubscriptionCurrent =
      '/api/v1/customer/subscriptions/current';
  static const String customerUncompletedSubscriptions =
      '/api/v1/customer/subscriptions/uncompleted';
  static const String customerSubscription =
      '/api/v1/customer/subscriptions/{subscriptionId}';
  static const String customerSubscriptionResume =
      '/api/v1/customer/subscriptions/{subscriptionId}/resume';
  static const String customerSubscriptionCurrentFreezeDetails =
      '/api/v1/customer/subscriptions/current/freeze-details';
  static const String customerSubscriptionFreezeDetails =
      '/api/v1/customer/subscriptions/{subscriptionId}/freeze-details';
  static const String customerInvoices = '/api/v1/customer/invoices';
  static const String customerDefaultPaymentMethod =
      '/api/v1/customer/payment-methods/default';
  static const String customerSubscriptionFreezePolicy =
      '/api/v1/customer/subscriptions/freeze-policy';
  static const String customerSubscriptionRenewalRequests =
      '/api/v1/customer/subscriptions/{subscriptionId}/renewal-requests';
  static const String customerSubscriptionFreezeRequests =
      '/api/v1/customer/subscriptions/{subscriptionId}/freeze-requests';
  static const String customerSubscriptionCancellationQuote =
      '/api/v1/customer/subscriptions/{subscriptionId}/cancellation-quote';
  static const String customerSubscriptionCancellationRequests =
      '/api/v1/customer/subscriptions/{subscriptionId}/cancellation-requests';
  static const String familySubscriptionFlowPackages =
      '/api/v1/customer/family-subscription-flow/packages';
  static const String familySubscriptionFlowRelationships =
      '/api/v1/customer/family-subscription-flow/relationships';
  static const String familySubscriptionFlowPrograms =
      '/api/v1/customer/family-subscription-flow/programs';
  static const String familySubscriptionFlowProgramBundles =
      '/api/v1/customer/family-subscription-flow/programs/{programId}/bundles';
  static const String familySubscriptionFlowProgramDurations =
      '/api/v1/customer/family-subscription-flow/programs/{programId}/durations';
  static const String familySubscriptionFlowProgramTiers =
      '/api/v1/customer/family-subscription-flow/programs/{programId}/tiers';
  static const String familySubscriptionFlowMetadata =
      '/api/v1/customer/family-subscription-flow/metadata';
  static const String familySubscriptionFlowCurrent =
      '/api/v1/customer/family-subscription-flow/current';
  static const String familySubscriptionFlowGroup =
      '/api/v1/customer/family-subscription-flow/group';
  static const String familySubscriptionFlowMembers =
      '/api/v1/customer/family-subscription-flow/members';
  static const String familySubscriptionFlowMemberLookup =
      '/api/v1/customer/family-subscription-flow/members/lookup';
  static const String familySubscriptionFlowMember =
      '/api/v1/customer/family-subscription-flow/members/{memberId}';
  static const String familySubscriptionFlowMemberPlan =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/plan';
  static const String familySubscriptionFlowMemberAllergies =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/allergies';
  static const String familySubscriptionFlowMemberDislikedIngredients =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/disliked-ingredients';
  static const String familySubscriptionFlowMemberDietary =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/dietary';
  static const String familySubscriptionFlowDislikedIngredients =
      '/api/v1/customer/family-subscription-flow/disliked-ingredients';
  static const String familySubscriptionFlowAllergies =
      '/api/v1/customer/family-subscription-flow/allergies';
  static const String familySubscriptionFlowDietary =
      '/api/v1/customer/family-subscription-flow/dietary';
  static const String familySubscriptionFlowCatalog =
      '/api/v1/customer/family-subscription-flow/food-preferences/catalog';
  static const String familyMemberAddresses =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/addresses';
  static const String familyMemberAddress =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/{addressId}';
  static const String familyMemberAddressPreview =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/preview-coverage';
  static const String familyMemberExistingAddressPreview =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/{addressId}/preview-coverage';
  static const String familyMemberAddressSetDefault =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/addresses/{addressId}/set-default';
  static const String familyMemberCheckoutSelection =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/checkout-selection';
  static const String familySubscriptionFlowMemberStartDate =
      '/api/v1/customer/family-subscription-flow/members/{memberId}/start-date';
  static const String familySubscriptionFlowSummary =
      '/api/v1/customer/family-subscription-flow/summary';
  static const String familySubscriptionFlowPaymentMethods =
      '/api/v1/customer/family-subscription-flow/payment-methods';
  static const String familySubscriptionFlowCheckout =
      '/api/v1/customer/family-subscription-flow/checkout';
  static const String familySubscriptionFlowRetryPayment =
      '/api/v1/customer/family-subscription-flow/retry-payment';
  static const String familyRenewalCheckout =
      '/api/v1/customer/family-subscription-flow/renewals/{renewalRequestId}/checkout';
  static const String customerSubscriptionDeliveryAddress =
      '/api/v1/customer/subscriptions/{subscriptionId}/delivery-address';
  static const String familyHome = '/api/v1/customer/family/home';
  static const String familyMe = '/api/v1/customer/family/me';
  static const String familyMembers = '/api/v1/customer/family/members';
  static const String familySwitcher = '/api/v1/customer/family/switcher';
  static const String familyMember =
      '/api/v1/customer/family/members/{memberId}';
  static const String familyMemberAccess =
      '/api/v1/customer/family/members/{memberId}/access';
  static const String familyMemberPermissions =
      '/api/v1/customer/family/members/{memberId}/permissions';
  static const String familyMemberCapabilities =
      '/api/v1/customer/family/members/{memberId}/capabilities';
  static const String familyMemberDetach =
      '/api/v1/customer/family/members/{memberId}/detach';
  static const String customerSubscriptionUpgradeOptions =
      '/api/v1/customer/subscriptions/{subscriptionId}/upgrade-options';
  static const String customerSubscriptionUpgradeSummary =
      '/api/v1/customer/subscriptions/{subscriptionId}/upgrade-summary';
  static const String customerSubscriptionUpgradeRequests =
      '/api/v1/customer/subscriptions/{subscriptionId}/upgrade-requests';
  static const String customerSubscriptionUpgradeStatus =
      '/api/v1/customer/subscriptions/{subscriptionId}/upgrade-requests/{upgradeId}';
  static const String customerSubscriptionAutoRenewal =
      '/api/v1/customer/subscriptions/{subscriptionId}/auto-renewal';
  static const String customerSubscriptionAutoRenewalConsent =
      '/api/v1/customer/subscriptions/{subscriptionId}/auto-renewal/consent';
  static const String customerSubscriptionInvoices =
      '/api/v1/customer/subscriptions/{subscriptionId}/invoices';
  static const String customerDeviceTokens =
      '/api/v1/customers/me/device-tokens';
  static const String customerNotifications =
      '/api/v1/customers/me/notifications';
  static const String customerNotificationRead =
      '/api/v1/customers/me/notifications/{id}/read';
  static const String customerNotificationsReadAll =
      '/api/v1/customers/me/notifications/read-all';
  static const String influencerBanks = '/api/v1/influencer-partner/banks';
  static const String influencerProfile = '/api/v1/influencer-partner/me';
  static const String influencerSocialLinks =
      '/api/v1/influencer-partner/me/social-links';
  static const String influencerHome = '/api/v1/influencer-partner/me/home';
  static const String influencerLinks = '/api/v1/influencer-partner/me/links';
  static const String influencerActivities =
      '/api/v1/influencer-partner/me/activities';
  static const String influencerWallet = '/api/v1/influencer-partner/me/wallet';
  static const String influencerBankAccount =
      '/api/v1/influencer-partner/me/bank-account';
  static const String influencerWithdrawals =
      '/api/v1/influencer-partner/me/withdrawals';
  static const String influencerWithdrawal =
      '/api/v1/influencer-partner/me/withdrawals/{id}';
  static const String influencerWithdrawalCancel =
      '/api/v1/influencer-partner/me/withdrawals/{id}/cancel';
  static const String influencerAnalytics =
      '/api/v1/influencer-partner/me/analytics';
  static const String customerOffersAvailable =
      '/api/v1/customer/offers/available';
  static const String customerOffersHub = '/api/v1/customer/offers/hub';
  static const String customerOfferDetails = '/api/v1/customer/offers/{id}';
  static const String customerOfferPurchaseDetails =
      '/api/v1/customer/offers/{offerId}/details';
  static const String customerOfferPurchaseOptions =
      '/api/v1/customer/offers/{offerId}/purchase-options';
  static const String customerOffersEligibleRestaurants =
      '/api/v1/customer/offers/{offerId}/eligible-restaurants';
  static const String customerOffersSaved = '/api/v1/customer/offers/saved';
  static const String customerOfferSave =
      '/api/v1/customer/offers/{offerId}/save';
  static const String customerOffersCalendar =
      '/api/v1/customer/offers/calendar';
  static const String customerOfferCalendarAdd =
      '/api/v1/customer/offers/{offerId}/calendar';
  static const String customerOfferCalendarDelete =
      '/api/v1/customer/offers/{offerId}/calendar/{date}';
  static const String customerOffersValidateDiscount =
      '/api/v1/customer/offers/validate-discount';
  static const String customerOffersEvaluate =
      '/api/v1/customer/offers/evaluate';
  static const String customerOffersRedeem = '/api/v1/customer/offers/redeem';
  static const String customerSubscriptionPricingPreview =
      '/api/v1/customer/subscription-pricing/preview';
  static const String customerSubscriptionConfirmation =
      '/api/v1/customer/subscriptions/{subscriptionId}/confirmation';
  static const String customerWallet = '/api/v1/customer/wallet';
  static const String customerWalletTransactions =
      '/api/v1/customer/wallet/transactions';
  static const String customerReferralsSummary =
      '/api/v1/customer/referrals/summary';
  static const String customerCampaignPricePreview =
      '/api/v1/customer/campaigns/price-preview';
  static const String customerCampaignSubscriptionCancel =
      '/api/v1/customer/campaigns/subscriptions/{id}/cancel';
  static const String customerCampaigns = '/api/v1/customer/campaigns';
  static const String customerCampaignDetails =
      '/api/v1/customer/campaigns/{campaignId}';
  static const String customerCampaignQuote =
      '/api/v1/customer/campaigns/quote';
  static const String customerCampaignCheckoutSession =
      '/api/v1/customer/campaigns/checkout-session';
  static const String customerCampaignPayment =
      '/api/v1/customer/campaigns/{sessionId}/payment';
}

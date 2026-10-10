import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/network_constants.dart';
import 'package:meal_meat_user/core/services/token_interceptor.dart';
import 'package:meal_meat_user/features/auth/data/models/request/login_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/logout_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/refresh_token_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/register_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/forgot_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/resend_password_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/resend_phone_otp_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/reset_password_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/verify_phone_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/calling_code_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/forgot_password_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/login_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/refresh_token_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/register_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/resend_password_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/resend_phone_otp_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/reset_password_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/verify_phone_response_dto.dart';
import 'package:meal_meat_user/features/change_password/data/models/request/change_customer_password_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/address_coverage_preview_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/request/map_reverse_geocode_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/address_coverage_preview_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/map_address_autofill_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/region_catalog_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/core/address/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/meal_details/data/models/response/subscription_meal_details_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_billing_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_catalog_response_dto.dart';
import 'package:meal_meat_user/core/upload_file/data/models/response/upload_file_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_restaurant_details_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_restaurants_page_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/core/subscription_tiers/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';
import 'package:meal_meat_user/features/family_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/family_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_save_meals_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/request/calendar_set_restaurant_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_available_meals_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_day_response_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_status_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_readiness_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_restaurant_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_programs_page_response_dto.dart';
import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_type_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_convert_from_individual_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_lookup_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_member_lookup_response_dto.dart';
import 'package:meal_meat_user/features/family_packages/data/models/response/family_size_package_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/family_allergies/data/models/request/family_member_allergies_request_dto.dart';
import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_conversion_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/request/subscription_upgrade_request_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_request_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_status_response_dto.dart';
import 'package:meal_meat_user/features/subscription_upgrade/data/models/response/subscription_upgrade_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_access_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/family_member_permissions_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_home_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_access_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_detail_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_permissions_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/family_member_summary_response_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_register_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/request/device_token_unregister_request_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/notifications_page_response_dto.dart';
import 'package:meal_meat_user/features/influencer/analytics/data/models/influencer_analytics_dto.dart';
import 'package:meal_meat_user/features/influencer/bank_account/data/models/influencer_bank_account_dto.dart';
import 'package:meal_meat_user/features/influencer/dashboard/data/models/influencer_dashboard_dto.dart';
import 'package:meal_meat_user/features/influencer/social_links/data/models/influencer_social_links_dto.dart';
import 'package:meal_meat_user/features/influencer/wallet/data/models/influencer_wallet_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/get_customer_available_offers_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/evaluate_offer_discount_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/request/create_campaign_checkout_session_request_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/offer_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/evaluate_offer_discount_response_dto.dart';
import 'package:meal_meat_user/features/offers/data/models/response/campaign_checkout_session_response_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/request/voice_device_register_request_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/request/voice_media_report_request_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_event_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_history_page_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_snapshot_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_device_register_response_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_ice_servers_response_dto.dart';
import 'package:meal_meat_user/features/calling/data/models/response/voice_call_display_dto.dart';
import 'package:meal_meat_user/features/notifications/data/models/response/device_token_register_response_dto.dart';

import 'package:retrofit/retrofit.dart';
part 'api_services.g.dart';

@RestApi()
@injectable
abstract class ApiServices {
  @factoryMethod
  factory ApiServices(Dio dio) = _ApiServices;

  @POST(EndPoints.login)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<LoginResponseDto> login(@Body() LoginRequestDto request);

  @POST(EndPoints.register)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<RegisterResponseDto> register(@Body() RegisterRequestDto request);

  @POST(EndPoints.verifyPhone)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<VerifyPhoneResponseDto> verifyPhone(
    @Body() VerifyPhoneRequestDto request,
  );

  @POST(EndPoints.resendPhoneOtp)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ResendPhoneOtpResponseDto> resendPhoneOtp(
    @Body() ResendPhoneOtpRequestDto request,
  );

  @POST(EndPoints.forgotPassword)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ForgotPasswordResponseDto> forgotPassword(
    @Body() ForgotPasswordRequestDto request,
  );

  @POST(EndPoints.resetPassword)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );

  @POST(EndPoints.resendPasswordOtp)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<ResendPasswordOtpResponseDto> resendPasswordOtp(
    @Body() ResendPasswordOtpRequestDto request,
  );

  @POST(EndPoints.refresh)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<RefreshTokenResponseDto> refreshToken(
    @Body() RefreshTokenRequestDto request,
  );

  @POST(EndPoints.logout)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<void> logout(@Body() LogoutRequestDto request);

  @GET(EndPoints.callingCodes)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<List<CallingCodeResponseDto>> getCallingCodes();

  @GET(EndPoints.locations)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<LocationsCatalogResponseDto> getLocationsCatalog(
    @Query('countryCode') String countryCode,
    @Query('areaId') String? areaId,
  );

  @GET(EndPoints.countryRegions)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<RegionCatalogResponseDto> getCountryRegions(
    @Path('countryCode') String countryCode,
  );

  @GET(EndPoints.customerProfile)
  Future<CustomerProfileResponseDto> getCustomerProfile();

  @PUT(EndPoints.customerProfile)
  Future<void> updateCustomerProfile(
    @Body() UpdateCustomerProfileRequestDto request,
  );

  @MultiPart()
  @POST(EndPoints.uploads)
  Future<UploadFileResponseDto> uploadFile(
    @Part(name: 'file') MultipartFile file,
    @Part(name: 'scope') String scope,
    @Part(name: 'folder') String folder,
  );

  @POST(EndPoints.customerProfileImage)
  Future<void> updateCustomerProfileImage(
    @Body() ProfileImageRequestDto request,
  );

  @DELETE(EndPoints.customerProfileImage)
  Future<void> deleteCustomerProfileImage();

  @GET(EndPoints.customerAddresses)
  Future<List<CustomerAddressResponseDto>> getCustomerAddresses();

  @POST(EndPoints.customerAddresses)
  Future<CustomerAddressResponseDto> addCustomerAddress(
    @Body() CustomerAddressRequestDto request,
  );

  @PUT(EndPoints.customerAddress)
  Future<CustomerAddressResponseDto> updateCustomerAddress(
    @Path('addressId') String addressId,
    @Body() CustomerAddressRequestDto request,
  );

  @DELETE(EndPoints.customerAddress)
  Future<void> deleteCustomerAddress(@Path('addressId') String addressId);

  @POST(EndPoints.customerAddressPreviewCoverage)
  Future<AddressCoveragePreviewResponseDto> previewNewAddressCoverage(
    @Body() AddressCoveragePreviewRequestDto request,
  );

  @GET(EndPoints.customerExistingAddressPreviewCoverage)
  Future<AddressCoveragePreviewResponseDto> previewExistingAddressCoverage(
    @Path('addressId') String addressId, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @POST(EndPoints.customerAddressSetDefault)
  Future<CustomerAddressResponseDto> confirmSetDefaultAddress(
    @Path('addressId') String addressId,
    @Body() Map<String, dynamic> body,
  );

  @POST(EndPoints.mapsGeocode)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<MapAddressAutofillResponseDto> geocode(
    @Body() MapGeocodeRequestDto request,
  );

  @POST(EndPoints.mapsReverseGeocode)
  @Extra({TokenInterceptor.skipAuthKey: true})
  Future<MapAddressAutofillResponseDto> reverseGeocode(
    @Body() MapReverseGeocodeRequestDto request,
  );

  @PUT(EndPoints.customerPassword)
  Future<void> changeCustomerPassword(
    @Body() ChangeCustomerPasswordRequestDto request,
  );

  @GET(EndPoints.customerFoodPreferencesDisliked)
  Future<FoodPreferencesResponseDto> getFoodPreferencesDislikedIngredients(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
    @Query('search') String? search,
  );

  @GET(EndPoints.customerFoodPreferencesAllergies)
  Future<FoodPreferencesResponseDto> getFoodPreferencesAllergies(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
    @Query('search') String? search,
  );

  @GET(EndPoints.customerFoodPreferencesDietary)
  Future<FoodPreferencesResponseDto> getFoodPreferencesDietary(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
    @Query('search') String? search,
  );

  @PUT(EndPoints.customerFoodPreferencesDisliked)
  Future<FoodPreferencesResponseDto> updateFoodPreferencesDislikedIngredients(
    @Body() FoodPreferencesDislikedIngredientsRequestDto request,
  );

  @PUT(EndPoints.customerFoodPreferencesAllergies)
  Future<FoodPreferencesResponseDto> updateFoodPreferencesAllergies(
    @Body() FoodPreferencesAllergiesRequestDto request,
  );

  @PUT(EndPoints.customerFoodPreferencesDietary)
  Future<FoodPreferencesResponseDto> updateFoodPreferencesDietary(
    @Body() FoodPreferencesDietaryRequestDto request,
  );

  @GET(EndPoints.subscriptionTypes)
  Future<List<SubscriptionTypeResponseDto>> getSubscriptionTypes();

  @GET(EndPoints.subscriptionConversionOptions)
  Future<SubscriptionConversionOptionsResponseDto>
  getSubscriptionConversionOptions();

  @POST(EndPoints.convertFromIndividual)
  Future<FamilyFlowCurrentResponseDto> convertFromIndividual(
    @Body() FamilyConvertFromIndividualRequestDto request,
  );

  @POST(EndPoints.familySubscriptionFlowAbandonDraft)
  Future<void> abandonFamilyDraft();

  @GET(EndPoints.subscriptionPrograms)
  Future<SubscriptionProgramsPageResponseDto> getSubscriptionPrograms({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET(EndPoints.subscriptionProgramBundles)
  Future<SubscriptionProgramBundlesResponseDto> getSubscriptionProgramBundles(
    @Path('programId') String programId, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET(EndPoints.subscriptionDurations)
  Future<List<SubscriptionDurationResponseDto>> getSubscriptionDurations(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Query('includeFriday') bool includeFriday,
  );

  @GET(EndPoints.subscriptionTiers)
  Future<List<SubscriptionTierResponseDto>> getSubscriptionTiers(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Query('durationDays') int? durationDays,
    @Query('includeFriday') bool includeFriday,
    @Query('familyMemberId') String? familyMemberId,
  );

  @GET(EndPoints.subscriptionPrerequisites)
  Future<void> checkSubscriptionPrerequisites();

  @GET(EndPoints.subscriptionTierRestaurants)
  Future<List<SubscriptionTierRestaurantBrowseResponseDto>>
  getSubscriptionTierRestaurants(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Path('tier') String tier,
    @Query('familyMemberId') String? familyMemberId, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET(EndPoints.subscriptionTierRestaurants)
  Future<SubscriptionTierRestaurantsPageResponseDto>
  getSubscriptionTierRestaurantsPage(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Path('tier') String tier,
    @Query('familyMemberId') String? familyMemberId, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET(EndPoints.subscriptionRestaurantDetails)
  Future<SubscriptionRestaurantDetailsResponseDto>
  getSubscriptionRestaurantDetails(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Path('restaurantId') String restaurantId,
  );

  @GET(EndPoints.subscriptionMealDetails)
  Future<SubscriptionMealDetailsResponseDto> getSubscriptionMealDetails(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Path('restaurantId') String restaurantId,
    @Path('mealId') String mealId,
  );

  @GET(EndPoints.subscriptionSummary)
  Future<SubscriptionSummaryResponseDto> getSubscriptionSummary(
    @Query('includeFriday') bool includeFriday,
    @Query('durationDays') int durationDays,
    @Query('tier') String tier,
    @Query('bundleId') String bundleId,
    @Query('programId') String programId,
    @Query('startDate') String startDate, {
    @Query('restaurantsPage') int? restaurantsPage,
    @Query('restaurantsPageSize') int? restaurantsPageSize,
    @Query('promoCode') String? promoCode,
  });

  @GET(EndPoints.subscriptionRestaurantAvailability)
  Future<SubscriptionRestaurantAvailabilityResponseDto>
  getSubscriptionRestaurantAvailability(
    @Query('includeFriday') bool includeFriday,
    @Query('durationDays') int durationDays,
    @Query('tier') String tier,
    @Query('bundleId') String bundleId,
    @Query('programId') String programId,
    @Query('startDate') String startDate, {
    @Query('restaurantsPage') int? restaurantsPage,
    @Query('restaurantsPageSize') int? restaurantsPageSize,
  });

  @GET(EndPoints.subscriptionReadiness)
  Future<SubscriptionReadinessResponseDto> getSubscriptionReadiness(
    @Query('includeFriday') bool includeFriday,
    @Query('durationDays') int durationDays,
    @Query('tier') String tier,
    @Query('bundleId') String bundleId,
    @Query('programId') String programId,
  );

  @GET(EndPoints.paymentMethods)
  Future<List<PaymentMethodResponseDto>> getPaymentMethods(
    @Query('amount') double amount,
  );

  @POST(EndPoints.subscriptionCheckout)
  Future<PaymentCheckoutResponseDto> checkoutSubscription(
    @Body() PaymentCheckoutRequestDto request,
  );

  @GET(EndPoints.subscriptionPaymentStatus)
  Future<PaymentStatusResponseDto> getSubscriptionPaymentStatus(
    @Path('subscriptionId') String subscriptionId,
  );

  @GET(EndPoints.subscriptionCalendar)
  Future<CalendarResponseDto> getSubscriptionCalendar(
    @Path('subscriptionId') String subscriptionId,
  );

  @GET(EndPoints.subscriptionCalendarDay)
  Future<CalendarDayResponseDto> getSubscriptionCalendarDay(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
  );

  @GET(EndPoints.subscriptionCalendarRestaurants)
  Future<CalendarRestaurantsResponseDto> getSubscriptionCalendarRestaurants(
    @Path('subscriptionId') String subscriptionId,
    @Query('query') String? query,
  );

  @GET(EndPoints.subscriptionCalendarDayRestaurants)
  Future<CalendarRestaurantsResponseDto> getSubscriptionCalendarDayRestaurants(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
    @Query('query') String? query, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @POST(EndPoints.subscriptionCalendarDayRestaurant)
  Future<CalendarDayResponseDto> setSubscriptionCalendarDayRestaurant(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
    @Body() CalendarSetRestaurantRequestDto request,
  );

  @GET(EndPoints.subscriptionCalendarRestaurantMeals)
  Future<CalendarAvailableMealsResponseDto>
  getSubscriptionCalendarRestaurantMeals(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
    @Path('restaurantId') String restaurantId, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('slot') String? slot,
  });

  @GET(EndPoints.subscriptionCalendarAvailableMeals)
  Future<CalendarAvailableMealsResponseDto>
  getSubscriptionCalendarAvailableMeals(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
  );

  @POST(EndPoints.subscriptionCalendarDayMeals)
  Future<CalendarDayResponseDto> saveSubscriptionCalendarDayMeals(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
    @Body() CalendarSaveMealsRequestDto request,
  );

  @POST(EndPoints.subscriptionCalendarAutoSelect)
  Future<CalendarDayResponseDto> autoSelectSubscriptionCalendarDay(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
  );

  @POST(EndPoints.subscriptionCalendarConfirm)
  Future<CalendarDayResponseDto> confirmSubscriptionCalendarDay(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
  );

  @GET(EndPoints.customerSubscriptionCurrent)
  Future<SubscriptionBillingCurrentResponseDto>
  getCurrentCustomerSubscription();

  @GET(EndPoints.customerUncompletedSubscriptions)
  Future<List<SubscriptionBillingUncompletedSubscriptionResponseDto>>
  getUncompletedCustomerSubscriptions();

  @DELETE(EndPoints.customerSubscription)
  Future<void> deleteUncompletedCustomerSubscription(
    @Path('subscriptionId') String subscriptionId,
  );

  @GET(EndPoints.customerSubscriptionResume)
  Future<SubscriptionBillingResumePreviewResponseDto>
  getCustomerSubscriptionResumePreview(
    @Path('subscriptionId') String subscriptionId,
  );

  @POST(EndPoints.customerSubscriptionResume)
  Future<SubscriptionBillingResumeResponseDto> resumeCustomerSubscription(
    @Path('subscriptionId') String subscriptionId,
    @Body() SubscriptionBillingResumeRequestDto request,
  );

  @GET(EndPoints.customerSubscriptionCurrentFreezeDetails)
  Future<SubscriptionBillingFreezeDetailsResponseDto>
  getCurrentCustomerSubscriptionFreezeDetails();

  @GET(EndPoints.customerSubscriptionFreezeDetails)
  Future<SubscriptionBillingFreezeDetailsResponseDto>
  getCustomerSubscriptionFreezeDetails(
    @Path('subscriptionId') String subscriptionId,
  );

  @GET(EndPoints.customerInvoices)
  Future<List<SubscriptionBillingInvoiceResponseDto>> getCustomerInvoices();

  @GET(EndPoints.customerDefaultPaymentMethod)
  Future<SubscriptionBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod();

  @GET(EndPoints.customerSubscriptionFreezePolicy)
  Future<SubscriptionBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy();

  @POST(EndPoints.customerSubscriptionRenewalRequests)
  Future<void> createCustomerSubscriptionRenewalRequest(
    @Path('subscriptionId') String subscriptionId,
  );

  @POST('{renewalPath}')
  Future<void> createFamilyMemberRenewalRequest(
    @Path('renewalPath') String renewalPath,
  );

  @POST(EndPoints.customerSubscriptionFreezeRequests)
  Future<SubscriptionBillingFreezeResponseDto>
  createCustomerSubscriptionFreezeRequest(
    @Path('subscriptionId') String subscriptionId,
    @Body() SubscriptionBillingFreezeRequestDto request,
  );

  @GET(EndPoints.customerSubscriptionCancellationQuote)
  Future<SubscriptionBillingCancellationQuoteResponseDto>
  getCustomerSubscriptionCancellationQuote(
    @Path('subscriptionId') String subscriptionId,
  );

  @POST(EndPoints.customerSubscriptionCancellationRequests)
  Future<SubscriptionBillingCancellationResultResponseDto>
  createCustomerSubscriptionCancellationRequest(
    @Path('subscriptionId') String subscriptionId,
    @Body() SubscriptionBillingCancellationRequestDto request,
  );

  @GET(EndPoints.familySubscriptionFlowPackages)
  Future<List<FamilySizePackageResponseDto>> getFamilySizePackages();

  @GET(EndPoints.familySubscriptionFlowRelationships)
  Future<List<FamilyRelationshipResponseDto>> getFamilyRelationships();

  @GET(EndPoints.familySubscriptionFlowCurrent)
  Future<FamilyFlowCurrentResponseDto> getFamilySubscriptionCurrent();

  @PUT(EndPoints.familySubscriptionFlowGroup)
  Future<FamilyFlowCurrentResponseDto> updateFamilyGroup(
    @Body() FamilyGroupWriteRequestDto request,
  );

  @POST(EndPoints.familySubscriptionFlowMembers)
  Future<FamilyFlowCurrentResponseDto> addFamilyMember(
    @Body() FamilyMemberWriteRequestDto request,
  );

  @POST(EndPoints.familySubscriptionFlowMemberLookup)
  Future<FamilyMemberLookupResponseDto> lookupFamilyMember(
    @Body() FamilyMemberLookupRequestDto request,
  );

  @PUT(EndPoints.familySubscriptionFlowMember)
  Future<FamilyFlowCurrentResponseDto> updateFamilyMember(
    @Path('memberId') String memberId,
    @Body() FamilyMemberWriteRequestDto request,
  );

  @DELETE(EndPoints.familySubscriptionFlowMember)
  Future<FamilyFlowCurrentResponseDto> deleteFamilyMember(
    @Path('memberId') String memberId,
  );

  @GET(EndPoints.familySubscriptionFlowPrograms)
  Future<List<FamilyProgramResponseDto>> getFamilyPrograms({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET(EndPoints.familySubscriptionFlowProgramBundles)
  Future<List<FamilyBundleResponseDto>> getFamilyProgramBundles(
    @Path('programId') String programId,
  );

  @GET(EndPoints.familySubscriptionFlowProgramDurations)
  Future<List<SubscriptionDurationResponseDto>> getFamilySubscriptionDurations(
    @Path('programId') String programId,
    @Query('includeFriday') bool includeFriday,
  );

  @GET(EndPoints.familySubscriptionFlowProgramTiers)
  Future<List<SubscriptionTierResponseDto>> getFamilySubscriptionTiers(
    @Path('programId') String programId,
    @Query('bundleId') String? bundleId,
    @Query('durationDays') int? durationDays,
    @Query('includeFriday') bool includeFriday,
    @Query('familyMemberId') String familyMemberId,
  );

  @PUT(EndPoints.familySubscriptionFlowMemberPlan)
  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    @Path('memberId') String memberId,
    @Body() FamilyMemberPlanWriteRequestDto request,
  );

  @PUT(EndPoints.familySubscriptionFlowMemberAllergies)
  Future<bool> saveFamilyMemberAllergies(
    @Path('memberId') String memberId,
    @Body() FamilyMemberAllergiesRequestDto request,
  );

  @PUT(EndPoints.familySubscriptionFlowMemberDislikedIngredients)
  Future<void> saveFamilyMemberDislikedIngredients(
    @Path('memberId') String memberId,
    @Body() FoodPreferencesDislikedIngredientsRequestDto request,
  );

  @PUT(EndPoints.familySubscriptionFlowMemberDietary)
  Future<void> saveFamilyMemberDietary(
    @Path('memberId') String memberId,
    @Body() Map<String, dynamic> request,
  );

  @GET(EndPoints.familySubscriptionFlowDislikedIngredients)
  Future<FoodPreferencesResponseDto> getFamilyDislikedIngredients({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('search') String? search,
  });

  @GET(EndPoints.familySubscriptionFlowAllergies)
  Future<FoodPreferencesResponseDto> getFamilyAllergies({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('search') String? search,
  });

  @GET(EndPoints.familySubscriptionFlowDietary)
  Future<FoodPreferencesResponseDto> getFamilyDietary({
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
    @Query('search') String? search,
  });

  @GET(EndPoints.familySubscriptionFlowCatalog)
  Future<FoodPreferencesCatalogResponseDto> getFamilyFoodPreferencesCatalog();

  @GET(EndPoints.familyMemberAddresses)
  Future<List<CustomerAddressResponseDto>> getFamilyMemberAddresses(
    @Path('memberId') String memberId,
  );

  @POST(EndPoints.familyMemberAddresses)
  Future<CustomerAddressResponseDto> addFamilyMemberAddress(
    @Path('memberId') String memberId,
    @Body() CustomerAddressRequestDto request,
  );

  @PUT(EndPoints.familyMemberAddress)
  Future<CustomerAddressResponseDto> updateFamilyMemberAddress(
    @Path('memberId') String memberId,
    @Path('addressId') String addressId,
    @Body() CustomerAddressRequestDto request,
  );

  @POST(EndPoints.familyMemberAddressPreview)
  Future<AddressCoveragePreviewResponseDto> previewFamilyMemberAddress(
    @Path('memberId') String memberId,
    @Body() AddressCoveragePreviewRequestDto request,
  );

  @GET(EndPoints.familyMemberExistingAddressPreview)
  Future<AddressCoveragePreviewResponseDto> previewExistingFamilyMemberAddress(
    @Path('memberId') String memberId,
    @Path('addressId') String addressId, {
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @POST(EndPoints.familyMemberAddressSetDefault)
  Future<CustomerAddressResponseDto> setDefaultFamilyMemberAddress(
    @Path('memberId') String memberId,
    @Path('addressId') String addressId,
    @Body() Map<String, dynamic> body,
  );

  @GET(EndPoints.familySubscriptionFlowSummary)
  Future<FamilySummaryResponseDto> getFamilySummary({
    @Query('memberId') String? memberId,
  });

  @GET(EndPoints.familySubscriptionFlowPaymentMethods)
  Future<List<PaymentMethodResponseDto>> getFamilyPaymentMethods(
    @Query('amount') double amount,
  );

  @POST(EndPoints.familySubscriptionFlowCheckout)
  Future<PaymentCheckoutResponseDto> checkoutFamilySubscription(
    @Body() FamilyCheckoutRequestDto request,
  );

  @GET(EndPoints.familyHome)
  Future<FamilyHomeResponseDto> getFamilyHome();

  @GET(EndPoints.familyMembers)
  Future<List<FamilyMemberSummaryResponseDto>> getFamilyMembers();

  @GET(EndPoints.familyMember)
  Future<FamilyMemberDetailResponseDto> getFamilyMember(
    @Path('memberId') String memberId,
  );

  @GET(EndPoints.familyMemberAccess)
  Future<FamilyMemberAccessResponseDto> getFamilyMemberAccess(
    @Path('memberId') String memberId,
  );

  @PUT(EndPoints.familyMemberAccess)
  Future<FamilyMemberAccessResponseDto> updateFamilyMemberAccess(
    @Path('memberId') String memberId,
    @Body() FamilyMemberAccessRequestDto request,
  );

  @GET(EndPoints.familyMemberPermissions)
  Future<FamilyMemberPermissionsResponseDto> getFamilyMemberPermissions(
    @Path('memberId') String memberId,
  );

  @PUT(EndPoints.familyMemberPermissions)
  Future<FamilyMemberPermissionsResponseDto> updateFamilyMemberPermissions(
    @Path('memberId') String memberId,
    @Body() FamilyMemberPermissionsRequestDto request,
  );

  @GET(EndPoints.customerSubscriptionUpgradeOptions)
  Future<SubscriptionUpgradeOptionsResponseDto> getSubscriptionUpgradeOptions(
    @Path('subscriptionId') String subscriptionId,
  );

  @GET(EndPoints.customerSubscriptionUpgradeSummary)
  Future<SubscriptionUpgradeSummaryResponseDto> getSubscriptionUpgradeSummary(
    @Path('subscriptionId') String subscriptionId,
    @Query('targetTier') String targetTier,
  );

  @POST(EndPoints.customerSubscriptionUpgradeRequests)
  Future<SubscriptionUpgradeRequestResponseDto>
  createSubscriptionUpgradeRequest(
    @Path('subscriptionId') String subscriptionId,
    @Body() SubscriptionUpgradeRequestDto request,
  );

  @GET(EndPoints.customerSubscriptionUpgradeStatus)
  Future<SubscriptionUpgradeStatusResponseDto> getSubscriptionUpgradeStatus(
    @Path('subscriptionId') String subscriptionId,
    @Path('upgradeId') String upgradeId,
  );

  @PUT(EndPoints.customerDeviceTokens)
  Future<DeviceTokenRegisterResponseDto> registerDeviceToken(
    @Body() DeviceTokenRegisterRequestDto request,
  );

  @DELETE(EndPoints.customerDeviceTokens)
  Future<void> unregisterDeviceToken(
    @Body() DeviceTokenUnregisterRequestDto request,
  );

  @GET(EndPoints.customerNotifications)
  Future<NotificationsPageResponseDto> getCustomerNotifications(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );

  @PUT(EndPoints.customerNotificationRead)
  Future<void> markCustomerNotificationRead(@Path('id') String id);

  @PUT(EndPoints.customerNotificationsReadAll)
  Future<void> markAllCustomerNotificationsRead();

  @GET(EndPoints.influencerBanks)
  Future<List<InfluencerBankDto>> getInfluencerBanks();
  @GET(EndPoints.influencerProfile)
  Future<InfluencerSocialProfileResponseDto> getInfluencerProfile();
  @PUT(EndPoints.influencerSocialLinks)
  Future<InfluencerSocialLinksUpdateResponseDto> updateInfluencerSocialLinks(
    @Body() InfluencerSocialLinksDto request,
  );
  @GET(EndPoints.influencerHome)
  Future<InfluencerHomeResponseDto> getInfluencerHome();
  @GET(EndPoints.influencerLinks)
  Future<InfluencerLinksResponseDto> getInfluencerLinks();
  @GET(EndPoints.influencerActivities)
  Future<InfluencerActivitiesPageDto> getInfluencerActivities(
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
  @GET(EndPoints.influencerWallet)
  Future<InfluencerWalletResponseDto> getInfluencerWallet();
  @GET(EndPoints.influencerBankAccount)
  Future<InfluencerBankAccountResponseDto> getInfluencerBankAccount();
  @PUT(EndPoints.influencerBankAccount)
  Future<InfluencerBankAccountResponseDto> saveInfluencerBankAccount(
    @Body() InfluencerBankAccountRequestDto request,
  );
  @DELETE(EndPoints.influencerBankAccount)
  Future<InfluencerBankAccountDeleteResponseDto> deleteInfluencerBankAccount();
  @POST(EndPoints.influencerWithdrawals)
  Future<InfluencerWithdrawalResponseDto> createInfluencerWithdrawal(
    @Body() InfluencerWithdrawalRequestDto request,
  );
  @GET(EndPoints.influencerWithdrawals)
  Future<InfluencerWithdrawalsPageDto> getInfluencerWithdrawals(
    @Query('status') String? status,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
  );
  @GET(EndPoints.influencerWithdrawal)
  Future<InfluencerWithdrawalResponseDto> getInfluencerWithdrawal(
    @Path('id') String id,
  );
  @POST(EndPoints.influencerWithdrawalCancel)
  Future<InfluencerWithdrawalResponseDto> cancelInfluencerWithdrawal(
    @Path('id') String id,
  );
  @GET(EndPoints.influencerAnalytics)
  Future<InfluencerAnalyticsResponseDto> getInfluencerAnalytics(
    @Query('period') String period,
  );

  @POST(EndPoints.customerOffersAvailable)
  Future<List<OfferResponseDto>> getCustomerAvailableOffers(
    @Body() GetCustomerAvailableOffersRequestDto request,
  );

  @GET(EndPoints.customerOfferDetails)
  Future<OfferResponseDto> getCustomerOfferDetails(@Path('id') String id);

  @POST(EndPoints.customerOffersEvaluate)
  Future<EvaluateOfferDiscountResponseDto> evaluateOfferDiscount(
    @Body() EvaluateOfferDiscountRequestDto request,
  );

  @POST(EndPoints.customerCampaignCheckoutSession)
  Future<CampaignCheckoutSessionResponseDto> createCampaignCheckoutSession(
    @Body() CreateCampaignCheckoutSessionRequestDto request,
  );

  // Voice Calls v2
  @POST(EndPoints.voiceDevicesRegister)
  Future<VoiceDeviceRegisterResponseDto> registerVoiceDevice(
    @Body() VoiceDeviceRegisterRequestDto request,
  );

  @POST(EndPoints.voiceDeviceRevoke)
  Future<void> revokeVoiceDevice(
    @Path('deviceSessionId') String deviceSessionId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @GET(EndPoints.voiceActiveCall)
  Future<HttpResponse<VoiceCallSnapshotDto?>> getActiveVoiceCall(
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @GET(EndPoints.voiceCallDetails)
  Future<VoiceCallSnapshotDto> getVoiceCallDetails(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @GET(EndPoints.voiceCallHistory)
  Future<VoiceCallHistoryPageDto> getVoiceCallHistory(
    @Path('tripStopId') String tripStopId,
    @Query('page') int page,
    @Query('pageSize') int pageSize,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @GET(EndPoints.voiceCallEvents)
  Future<List<VoiceCallEventDto>> getVoiceCallEvents(
    @Path('callId') String callId,
    @Query('afterSequence') int afterSequence,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @POST(EndPoints.voiceCallRingingAck)
  Future<void> ackVoiceCallRinging(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @POST(EndPoints.voiceCallAnswer)
  Future<void> answerVoiceCall(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @POST(EndPoints.voiceCallReject)
  Future<void> rejectVoiceCall(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @POST(EndPoints.voiceCallEnd)
  Future<void> endVoiceCall(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @GET(EndPoints.voiceCallIceServers)
  Future<VoiceIceServersResponseDto> getVoiceIceServers(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @POST(EndPoints.voiceCallReportConnecting)
  Future<void> reportVoiceConnecting(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
    @Body() VoiceMediaReportRequestDto? report,
  );

  @POST(EndPoints.voiceCallReportConnected)
  Future<void> reportVoiceConnected(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
    @Body() VoiceMediaReportRequestDto? report,
  );

  @POST(EndPoints.voiceCallHeartbeat)
  Future<void> sendVoiceHeartbeat(
    @Path('callId') String callId,
    @Header(NetworkConstants.voiceDeviceSessionHeader) String session,
    @Header(NetworkConstants.voiceDeviceProofHeader) String proof,
  );

  @GET(EndPoints.voiceCallDisplay)
  Future<VoiceCallDisplayDto> getVoiceCallDisplay(
    @Path('callId') String callId,
    @Header('Accept-Language') String? language,
  );
}

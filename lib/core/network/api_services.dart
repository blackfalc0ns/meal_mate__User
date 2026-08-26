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
import 'package:meal_meat_user/features/addresses/data/models/request/customer_address_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_allergies_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_dietary_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_disliked_ingredients_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/region_catalog_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/meal_details/data/models/response/subscription_meal_details_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/profile_billing_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/core/upload_file/data/models/response/upload_file_response_dto.dart';
import 'package:meal_meat_user/core/subscription_duration/data/models/response/subscription_duration_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_restaurant_details_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_response_dto.dart';
import 'package:meal_meat_user/features/monthly_plans/data/models/response/subscription_tier_restaurant_browse_response_dto.dart';
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
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_summary_response_dto.dart';
import 'package:meal_meat_user/core/subscription_packages/data/models/response/subscription_bundle_response_dto.dart';
import 'package:meal_meat_user/core/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_type_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_convert_from_individual_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_group_write_request_dto.dart';
import 'package:meal_meat_user/features/family_package_days/data/models/request/family_member_plan_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/request/family_member_write_request_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_flow_current_response_dto.dart';
import 'package:meal_meat_user/features/family_subscription_setup/data/models/response/family_relationship_response_dto.dart';
import 'package:meal_meat_user/features/family_packages/data/models/response/family_size_package_response_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_conversion_options_response_dto.dart';

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
  Future<void> addCustomerAddress(@Body() CustomerAddressRequestDto request);

  @PUT(EndPoints.customerAddress)
  Future<void> updateCustomerAddress(
    @Path('addressId') String addressId,
    @Body() CustomerAddressRequestDto request,
  );

  @DELETE(EndPoints.customerAddress)
  Future<void> deleteCustomerAddress(@Path('addressId') String addressId);

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
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms();

  @GET(EndPoints.subscriptionProgramBundles)
  Future<List<SubscriptionBundleResponseDto>> getSubscriptionProgramBundles(
    @Path('programId') String programId,
  );

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
  );

  @GET(EndPoints.subscriptionTierRestaurants)
  Future<List<SubscriptionTierRestaurantBrowseResponseDto>>
  getSubscriptionTierRestaurants(
    @Path('programId') String programId,
    @Path('bundleId') String bundleId,
    @Path('tier') String tier,
    @Query('restaurantIds') List<String>? restaurantIds,
  );

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
    @Query('startDate') String startDate,
  );

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
  );

  @GET(EndPoints.subscriptionCalendarDayRestaurants)
  Future<CalendarRestaurantsResponseDto> getSubscriptionCalendarDayRestaurants(
    @Path('subscriptionId') String subscriptionId,
    @Path('date') String date,
  );

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
    @Path('restaurantId') String restaurantId,
  );

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

  @GET(EndPoints.customerSubscriptionCurrent)
  Future<ProfileBillingCurrentResponseDto> getCurrentCustomerSubscription();

  @GET(EndPoints.customerInvoices)
  Future<List<ProfileBillingInvoiceResponseDto>> getCustomerInvoices();

  @GET(EndPoints.customerDefaultPaymentMethod)
  Future<ProfileBillingPaymentMethodResponseDto>
  getDefaultCustomerPaymentMethod();

  @GET(EndPoints.customerSubscriptionFreezePolicy)
  Future<ProfileBillingFreezePolicyResponseDto>
  getCustomerSubscriptionFreezePolicy();

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
  Future<List<SubscriptionProgramResponseDto>> getFamilyPrograms();

  @GET(EndPoints.familySubscriptionFlowProgramBundles)
  Future<List<SubscriptionBundleResponseDto>> getFamilyProgramBundles(
    @Path('programId') String programId,
  );

  @PUT(EndPoints.familySubscriptionFlowMemberPlan)
  Future<FamilyFlowCurrentResponseDto> saveFamilyMemberPlan(
    @Path('memberId') String memberId,
    @Body() FamilyMemberPlanWriteRequestDto request,
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
}

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
import 'package:meal_meat_user/features/addresses/data/models/response/locations_catalog_response_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/region_catalog_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/request/food_preferences_request_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_catalog_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_image_request_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/request/update_customer_profile_request_dto.dart';
import 'package:meal_meat_user/features/addresses/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/profile/data/models/response/customer_profile_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';
import 'package:meal_meat_user/core/upload_file/data/models/response/upload_file_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_type_response_dto.dart';
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

  @GET(EndPoints.customerFoodPreferences)
  Future<FoodPreferencesResponseDto> getFoodPreferences();

  @GET(EndPoints.customerFoodPreferencesCatalog)
  Future<FoodPreferencesCatalogResponseDto> getFoodPreferencesCatalog();

  @PUT(EndPoints.customerFoodPreferences)
  Future<void> updateFoodPreferences(@Body() FoodPreferencesRequestDto request);

  @PUT(EndPoints.customerFoodPreferencesAllergies)
  Future<FoodPreferencesResponseDto> updateFoodPreferencesAllergies(
    @Body() FoodPreferencesAllergiesRequestDto request,
  );

  @GET(EndPoints.subscriptionTypes)
  Future<List<SubscriptionTypeResponseDto>> getSubscriptionTypes();

  @GET(EndPoints.subscriptionPrograms)
  Future<List<SubscriptionProgramResponseDto>> getSubscriptionPrograms();
}

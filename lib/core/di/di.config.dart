// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:local_auth/local_auth.dart' as _i152;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/addresses/data/data_source/addresses_remote_data_source.dart'
    as _i737;
import '../../features/addresses/data/data_source/addresses_remote_data_source_impl.dart'
    as _i380;
import '../../features/addresses/data/repo/addresses_repository_impl.dart'
    as _i376;
import '../../features/addresses/domain/repo/addresses_repository.dart'
    as _i556;
import '../../features/addresses/domain/usecase/add_customer_address_usecase.dart'
    as _i898;
import '../../features/addresses/domain/usecase/delete_customer_address_usecase.dart'
    as _i624;
import '../../features/addresses/domain/usecase/get_customer_addresses_usecase.dart'
    as _i945;
import '../../features/addresses/domain/usecase/get_locations_catalog_usecase.dart'
    as _i2;
import '../../features/addresses/domain/usecase/update_customer_address_usecase.dart'
    as _i241;
import '../../features/addresses/presentation/manager/addresses_view_model.dart'
    as _i524;
import '../../features/auth/data/data_source/auth_remote_data_source.dart'
    as _i182;
import '../../features/auth/data/data_source/auth_remote_data_source_impl.dart'
    as _i508;
import '../../features/auth/data/repo/auth_repository_impl.dart' as _i607;
import '../../features/auth/domain/repo/auth_repository.dart' as _i2;
import '../../features/auth/domain/usecase/forgot_password_usecase.dart'
    as _i749;
import '../../features/auth/domain/usecase/get_calling_codes_usecase.dart'
    as _i171;
import '../../features/auth/domain/usecase/login_usecase.dart' as _i911;
import '../../features/auth/domain/usecase/logout_usecase.dart' as _i757;
import '../../features/auth/domain/usecase/refresh_token_usecase.dart' as _i501;
import '../../features/auth/domain/usecase/register_usecase.dart' as _i769;
import '../../features/auth/domain/usecase/resend_password_otp_usecase.dart'
    as _i610;
import '../../features/auth/domain/usecase/resend_phone_otp_usecase.dart'
    as _i621;
import '../../features/auth/domain/usecase/reset_password_usecase.dart'
    as _i1029;
import '../../features/auth/domain/usecase/verify_phone_usecase.dart' as _i918;
import '../../features/auth/presentation/manager/auth_view_model.dart' as _i892;
import '../../features/auth/presentation/manager/biometric_cubit.dart' as _i280;
import '../../features/change_password/data/data_source/change_password_remote_data_source.dart'
    as _i263;
import '../../features/change_password/data/data_source/change_password_remote_data_source_impl.dart'
    as _i949;
import '../../features/change_password/data/repo/change_password_repository_impl.dart'
    as _i246;
import '../../features/change_password/domain/repo/change_password_repository.dart'
    as _i229;
import '../../features/change_password/domain/usecase/change_customer_password_usecase.dart'
    as _i845;
import '../../features/family_plans/data/data_source/family_plans_remote_data_source.dart'
    as _i983;
import '../../features/family_plans/data/data_source/family_plans_remote_data_source_impl.dart'
    as _i562;
import '../../features/family_plans/data/repo/family_plans_repository_impl.dart'
    as _i1062;
import '../../features/family_plans/domain/repo/family_plans_repository.dart'
    as _i1069;
import '../../features/family_plans/domain/usecase/add_family_member_usecase.dart'
    as _i191;
import '../../features/family_plans/domain/usecase/checkout_family_subscription_usecase.dart'
    as _i98;
import '../../features/family_plans/domain/usecase/delete_family_member_usecase.dart'
    as _i62;
import '../../features/family_plans/domain/usecase/get_current_family_group_usecase.dart'
    as _i870;
import '../../features/family_plans/domain/usecase/get_family_metadata_usecase.dart'
    as _i920;
import '../../features/family_plans/domain/usecase/get_family_payment_methods_usecase.dart'
    as _i833;
import '../../features/family_plans/domain/usecase/get_family_summary_usecase.dart'
    as _i515;
import '../../features/family_plans/domain/usecase/update_family_group_name_usecase.dart'
    as _i189;
import '../../features/family_plans/domain/usecase/update_family_member_plan_usecase.dart'
    as _i71;
import '../../features/family_plans/domain/usecase/update_family_member_usecase.dart'
    as _i728;
import '../../features/family_plans/presentation/manager/family_plans_view_model.dart'
    as _i551;
import '../../features/food_preferences/data/data_source/food_preferences_remote_data_source.dart'
    as _i961;
import '../../features/food_preferences/data/data_source/food_preferences_remote_data_source_impl.dart'
    as _i194;
import '../../features/food_preferences/data/repo/food_preferences_repository_impl.dart'
    as _i1070;
import '../../features/food_preferences/domain/repo/food_preferences_repository.dart'
    as _i62;
import '../../features/food_preferences/domain/usecase/get_food_preferences_catalog_usecase.dart'
    as _i32;
import '../../features/food_preferences/domain/usecase/get_food_preferences_usecase.dart'
    as _i608;
import '../../features/food_preferences/domain/usecase/update_food_preferences_allergies_usecase.dart'
    as _i400;
import '../../features/food_preferences/domain/usecase/update_food_preferences_usecase.dart'
    as _i635;
import '../../features/food_preferences/presentation/manager/food_preferences_view_model.dart'
    as _i420;
import '../../features/monthly_plans/data/data_source/subscription_plan_remote_data_source.dart'
    as _i755;
import '../../features/monthly_plans/data/data_source/subscription_plan_remote_data_source_impl.dart'
    as _i509;
import '../../features/monthly_plans/data/repo/subscription_plan_repository_impl.dart'
    as _i738;
import '../../features/monthly_plans/domain/repo/subscription_plan_repository.dart'
    as _i986;
import '../../features/monthly_plans/domain/usecase/get_subscription_durations_usecase.dart'
    as _i275;
import '../../features/monthly_plans/domain/usecase/get_subscription_restaurant_details_usecase.dart'
    as _i837;
import '../../features/monthly_plans/domain/usecase/get_subscription_tier_restaurants_usecase.dart'
    as _i903;
import '../../features/monthly_plans/domain/usecase/get_subscription_tiers_usecase.dart'
    as _i101;
import '../../features/monthly_plans/presentation/manager/subscription_plan_view_model.dart'
    as _i527;
import '../../features/monthly_plans/presentation/manager/subscription_restaurant_details_view_model.dart'
    as _i851;
import '../../features/payment/data/data_source/payment_remote_data_source.dart'
    as _i957;
import '../../features/payment/data/data_source/payment_remote_data_source_impl.dart'
    as _i621;
import '../../features/payment/data/repo/payment_repository_impl.dart' as _i914;
import '../../features/payment/domain/repo/payment_repository.dart' as _i996;
import '../../features/payment/domain/usecase/checkout_subscription_usecase.dart'
    as _i895;
import '../../features/payment/domain/usecase/get_payment_methods_usecase.dart'
    as _i365;
import '../../features/payment/domain/usecase/get_subscription_calendar_usecase.dart'
    as _i182;
import '../../features/payment/domain/usecase/get_subscription_payment_status_usecase.dart'
    as _i173;
import '../../features/payment/presentation/manager/payment_view_model.dart'
    as _i502;
import '../../features/profile/data/data_source/profile_remote_data_source.dart'
    as _i998;
import '../../features/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i531;
import '../../features/profile/data/repo/profile_repository_impl.dart'
    as _i1015;
import '../../features/profile/domain/repo/profile_repository.dart' as _i311;
import '../../features/profile/domain/usecase/delete_customer_profile_image_usecase.dart'
    as _i186;
import '../../features/profile/domain/usecase/get_customer_profile_usecase.dart'
    as _i994;
import '../../features/profile/domain/usecase/get_profile_billing_usecase.dart'
    as _i768;
import '../../features/profile/domain/usecase/update_customer_profile_image_usecase.dart'
    as _i399;
import '../../features/profile/domain/usecase/update_customer_profile_usecase.dart'
    as _i857;
import '../../features/profile/presentation/manager/profile_view_model.dart'
    as _i446;
import '../../features/subscription_checkout/data/data_source/subscription_summary_remote_data_source.dart'
    as _i155;
import '../../features/subscription_checkout/data/data_source/subscription_summary_remote_data_source_impl.dart'
    as _i846;
import '../../features/subscription_checkout/data/repo/subscription_summary_repository_impl.dart'
    as _i636;
import '../../features/subscription_checkout/domain/repo/subscription_summary_repository.dart'
    as _i1060;
import '../../features/subscription_checkout/domain/usecase/get_subscription_readiness_usecase.dart'
    as _i462;
import '../../features/subscription_checkout/domain/usecase/get_subscription_summary_usecase.dart'
    as _i926;
import '../../features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart'
    as _i356;
import '../../features/subscription_programs/data/data_source/subscription_programs_remote_data_source.dart'
    as _i96;
import '../../features/subscription_programs/data/data_source/subscription_programs_remote_data_source_impl.dart'
    as _i905;
import '../../features/subscription_programs/data/data_source/subscription_types_remote_data_source.dart'
    as _i1021;
import '../../features/subscription_programs/data/data_source/subscription_types_remote_data_source_impl.dart'
    as _i253;
import '../../features/subscription_programs/data/repo/subscription_programs_repository_impl.dart'
    as _i1010;
import '../../features/subscription_programs/data/repo/subscription_types_repository_impl.dart'
    as _i715;
import '../../features/subscription_programs/domain/repo/subscription_programs_repository.dart'
    as _i650;
import '../../features/subscription_programs/domain/repo/subscription_types_repository.dart'
    as _i866;
import '../../features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart'
    as _i718;
import '../../features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart'
    as _i178;
import '../../features/subscription_programs/domain/usecase/get_subscription_types_usecase.dart'
    as _i247;
import '../../features/subscription_programs/presentation/manager/subscription_programs_view_model.dart'
    as _i420;
import '../../features/subscription_programs/presentation/manager/subscription_types_view_model.dart'
    as _i492;
import '../biometric/biometric_service.dart' as _i43;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../services/app_navigator_service.dart' as _i179;
import '../services/device_id_service.dart' as _i148;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
import '../services/retry_interceptor.dart' as _i844;
import '../services/token_interceptor.dart' as _i1056;
import '../services/token_service.dart' as _i227;
import '../upload_file/data/data_source/upload_file_remote_data_source.dart'
    as _i99;
import '../upload_file/data/data_source/upload_file_remote_data_source_impl.dart'
    as _i963;
import '../upload_file/data/repo/upload_file_repository_impl.dart' as _i818;
import '../upload_file/domain/repo/upload_file_repository.dart' as _i422;
import '../upload_file/domain/usecase/upload_file_usecase.dart' as _i995;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModules = _$ExternalModules();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModules.provideSharedPreferences,
      preResolve: true,
    );
    gh.factory<_i844.RetryInterceptor>(() => _i844.RetryInterceptor());
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.lazySingleton<_i152.LocalAuthentication>(
      () => externalModules.provideLocalAuthentication(),
    );
    gh.lazySingleton<_i179.AppNavigatorService>(
      () => _i179.AppNavigatorService(),
    );
    gh.lazySingleton<_i1056.TokenInterceptor>(() => _i1056.TokenInterceptor());
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i819.LanguageService>(
      () => _i819.LanguageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i148.DeviceIdService>(
      () => _i148.DeviceIdService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i43.BiometricService>(
      () => _i43.BiometricService(
        gh<_i152.LocalAuthentication>(),
        gh<_i460.SharedPreferences>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i280.BiometricCubit>(
      () => _i280.BiometricCubit(gh<_i43.BiometricService>()),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
      ),
    );
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i155.SubscriptionSummaryRemoteDataSource>(
      () => _i846.SubscriptionSummaryRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i961.FoodPreferencesRemoteDataSource>(
      () => _i194.FoodPreferencesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i182.AuthRemoteDataSource>(
      () => _i508.AuthRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i96.SubscriptionProgramsRemoteDataSource>(
      () => _i905.SubscriptionProgramsRemoteDataSourceImpl(
        gh<_i804.ApiServices>(),
      ),
    );
    gh.factory<_i957.PaymentRemoteDataSource>(
      () => _i621.PaymentRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i263.ChangePasswordRemoteDataSource>(
      () => _i949.ChangePasswordRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i229.ChangePasswordRepository>(
      () => _i246.ChangePasswordRepositoryImpl(
        gh<_i263.ChangePasswordRemoteDataSource>(),
      ),
    );
    gh.factory<_i1060.SubscriptionSummaryRepository>(
      () => _i636.SubscriptionSummaryRepositoryImpl(
        gh<_i155.SubscriptionSummaryRemoteDataSource>(),
      ),
    );
    gh.factory<_i996.PaymentRepository>(
      () => _i914.PaymentRepositoryImpl(gh<_i957.PaymentRemoteDataSource>()),
    );
    gh.factory<_i2.AuthRepository>(
      () => _i607.AuthRepositoryImpl(
        gh<_i182.AuthRemoteDataSource>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i650.SubscriptionProgramsRepository>(
      () => _i1010.SubscriptionProgramsRepositoryImpl(
        gh<_i96.SubscriptionProgramsRemoteDataSource>(),
      ),
    );
    gh.factory<_i755.SubscriptionPlanRemoteDataSource>(
      () => _i509.SubscriptionPlanRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i99.UploadFileRemoteDataSource>(
      () => _i963.UploadFileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i983.FamilyPlansRemoteDataSource>(
      () => _i562.FamilyPlansRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i749.ForgotPasswordUseCase>(
      () => _i749.ForgotPasswordUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i171.GetCallingCodesUseCase>(
      () => _i171.GetCallingCodesUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i911.LoginUseCase>(
      () => _i911.LoginUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i757.LogoutUseCase>(
      () => _i757.LogoutUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i501.RefreshTokenUseCase>(
      () => _i501.RefreshTokenUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i769.RegisterUseCase>(
      () => _i769.RegisterUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i610.ResendPasswordOtpUseCase>(
      () => _i610.ResendPasswordOtpUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i621.ResendPhoneOtpUseCase>(
      () => _i621.ResendPhoneOtpUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i1029.ResetPasswordUseCase>(
      () => _i1029.ResetPasswordUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i918.VerifyPhoneUseCase>(
      () => _i918.VerifyPhoneUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i998.ProfileRemoteDataSource>(
      () => _i531.ProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i737.AddressesRemoteDataSource>(
      () => _i380.AddressesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i1021.SubscriptionTypesRemoteDataSource>(
      () =>
          _i253.SubscriptionTypesRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i62.FoodPreferencesRepository>(
      () => _i1070.FoodPreferencesRepositoryImpl(
        gh<_i961.FoodPreferencesRemoteDataSource>(),
      ),
    );
    gh.factory<_i845.ChangeCustomerPasswordUseCase>(
      () => _i845.ChangeCustomerPasswordUseCase(
        gh<_i229.ChangePasswordRepository>(),
      ),
    );
    gh.factory<_i892.AuthViewModel>(
      () => _i892.AuthViewModel(
        gh<_i911.LoginUseCase>(),
        gh<_i769.RegisterUseCase>(),
        gh<_i171.GetCallingCodesUseCase>(),
        gh<_i918.VerifyPhoneUseCase>(),
        gh<_i621.ResendPhoneOtpUseCase>(),
        gh<_i749.ForgotPasswordUseCase>(),
        gh<_i1029.ResetPasswordUseCase>(),
        gh<_i610.ResendPasswordOtpUseCase>(),
        gh<_i501.RefreshTokenUseCase>(),
        gh<_i757.LogoutUseCase>(),
      ),
    );
    gh.factory<_i462.GetSubscriptionReadinessUseCase>(
      () => _i462.GetSubscriptionReadinessUseCase(
        gh<_i1060.SubscriptionSummaryRepository>(),
      ),
    );
    gh.factory<_i926.GetSubscriptionSummaryUseCase>(
      () => _i926.GetSubscriptionSummaryUseCase(
        gh<_i1060.SubscriptionSummaryRepository>(),
      ),
    );
    gh.factory<_i895.CheckoutSubscriptionUseCase>(
      () => _i895.CheckoutSubscriptionUseCase(gh<_i996.PaymentRepository>()),
    );
    gh.factory<_i365.GetPaymentMethodsUseCase>(
      () => _i365.GetPaymentMethodsUseCase(gh<_i996.PaymentRepository>()),
    );
    gh.factory<_i182.GetSubscriptionCalendarUseCase>(
      () => _i182.GetSubscriptionCalendarUseCase(gh<_i996.PaymentRepository>()),
    );
    gh.factory<_i173.GetSubscriptionPaymentStatusUseCase>(
      () => _i173.GetSubscriptionPaymentStatusUseCase(
        gh<_i996.PaymentRepository>(),
      ),
    );
    gh.factory<_i32.GetFoodPreferencesCatalogUseCase>(
      () => _i32.GetFoodPreferencesCatalogUseCase(
        gh<_i62.FoodPreferencesRepository>(),
      ),
    );
    gh.factory<_i608.GetFoodPreferencesUseCase>(
      () =>
          _i608.GetFoodPreferencesUseCase(gh<_i62.FoodPreferencesRepository>()),
    );
    gh.factory<_i400.UpdateFoodPreferencesAllergiesUseCase>(
      () => _i400.UpdateFoodPreferencesAllergiesUseCase(
        gh<_i62.FoodPreferencesRepository>(),
      ),
    );
    gh.factory<_i635.UpdateFoodPreferencesUseCase>(
      () => _i635.UpdateFoodPreferencesUseCase(
        gh<_i62.FoodPreferencesRepository>(),
      ),
    );
    gh.factory<_i311.ProfileRepository>(
      () => _i1015.ProfileRepositoryImpl(gh<_i998.ProfileRemoteDataSource>()),
    );
    gh.factory<_i422.UploadFileRepository>(
      () =>
          _i818.UploadFileRepositoryImpl(gh<_i99.UploadFileRemoteDataSource>()),
    );
    gh.factory<_i420.FoodPreferencesViewModel>(
      () => _i420.FoodPreferencesViewModel(
        gh<_i608.GetFoodPreferencesUseCase>(),
        gh<_i32.GetFoodPreferencesCatalogUseCase>(),
        gh<_i635.UpdateFoodPreferencesUseCase>(),
        gh<_i400.UpdateFoodPreferencesAllergiesUseCase>(),
      ),
    );
    gh.factory<_i718.GetSubscriptionProgramBundlesUseCase>(
      () => _i718.GetSubscriptionProgramBundlesUseCase(
        gh<_i650.SubscriptionProgramsRepository>(),
      ),
    );
    gh.factory<_i178.GetSubscriptionProgramsUseCase>(
      () => _i178.GetSubscriptionProgramsUseCase(
        gh<_i650.SubscriptionProgramsRepository>(),
      ),
    );
    gh.factory<_i995.UploadFileUseCase>(
      () => _i995.UploadFileUseCase(gh<_i422.UploadFileRepository>()),
    );
    gh.factory<_i986.SubscriptionPlanRepository>(
      () => _i738.SubscriptionPlanRepositoryImpl(
        gh<_i755.SubscriptionPlanRemoteDataSource>(),
      ),
    );
    gh.factory<_i356.SubscriptionSummaryViewModel>(
      () => _i356.SubscriptionSummaryViewModel(
        gh<_i926.GetSubscriptionSummaryUseCase>(),
      ),
    );
    gh.factory<_i1069.FamilyPlansRepository>(
      () => _i1062.FamilyPlansRepositoryImpl(
        gh<_i983.FamilyPlansRemoteDataSource>(),
      ),
    );
    gh.factory<_i866.SubscriptionTypesRepository>(
      () => _i715.SubscriptionTypesRepositoryImpl(
        gh<_i1021.SubscriptionTypesRemoteDataSource>(),
      ),
    );
    gh.factory<_i556.AddressesRepository>(
      () =>
          _i376.AddressesRepositoryImpl(gh<_i737.AddressesRemoteDataSource>()),
    );
    gh.factory<_i247.GetSubscriptionTypesUseCase>(
      () => _i247.GetSubscriptionTypesUseCase(
        gh<_i866.SubscriptionTypesRepository>(),
      ),
    );
    gh.factory<_i186.DeleteCustomerProfileImageUseCase>(
      () => _i186.DeleteCustomerProfileImageUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i994.GetCustomerProfileUseCase>(
      () => _i994.GetCustomerProfileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i768.GetProfileBillingUseCase>(
      () => _i768.GetProfileBillingUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i399.UpdateCustomerProfileImageUseCase>(
      () => _i399.UpdateCustomerProfileImageUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i857.UpdateCustomerProfileUseCase>(
      () => _i857.UpdateCustomerProfileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i492.SubscriptionTypesViewModel>(
      () => _i492.SubscriptionTypesViewModel(
        gh<_i247.GetSubscriptionTypesUseCase>(),
      ),
    );
    gh.factory<_i191.AddFamilyMemberUseCase>(
      () => _i191.AddFamilyMemberUseCase(gh<_i1069.FamilyPlansRepository>()),
    );
    gh.factory<_i98.CheckoutFamilySubscriptionUseCase>(
      () => _i98.CheckoutFamilySubscriptionUseCase(
        gh<_i1069.FamilyPlansRepository>(),
      ),
    );
    gh.factory<_i62.DeleteFamilyMemberUseCase>(
      () => _i62.DeleteFamilyMemberUseCase(gh<_i1069.FamilyPlansRepository>()),
    );
    gh.factory<_i870.GetCurrentFamilyGroupUseCase>(
      () => _i870.GetCurrentFamilyGroupUseCase(
        gh<_i1069.FamilyPlansRepository>(),
      ),
    );
    gh.factory<_i920.GetFamilyMetadataUseCase>(
      () => _i920.GetFamilyMetadataUseCase(gh<_i1069.FamilyPlansRepository>()),
    );
    gh.factory<_i833.GetFamilyPaymentMethodsUseCase>(
      () => _i833.GetFamilyPaymentMethodsUseCase(
        gh<_i1069.FamilyPlansRepository>(),
      ),
    );
    gh.factory<_i515.GetFamilySummaryUseCase>(
      () => _i515.GetFamilySummaryUseCase(gh<_i1069.FamilyPlansRepository>()),
    );
    gh.factory<_i189.UpdateFamilyGroupNameUseCase>(
      () => _i189.UpdateFamilyGroupNameUseCase(
        gh<_i1069.FamilyPlansRepository>(),
      ),
    );
    gh.factory<_i71.UpdateFamilyMemberPlanUseCase>(
      () => _i71.UpdateFamilyMemberPlanUseCase(
        gh<_i1069.FamilyPlansRepository>(),
      ),
    );
    gh.factory<_i728.UpdateFamilyMemberUseCase>(
      () => _i728.UpdateFamilyMemberUseCase(gh<_i1069.FamilyPlansRepository>()),
    );
    gh.factory<_i275.GetSubscriptionDurationsUseCase>(
      () => _i275.GetSubscriptionDurationsUseCase(
        gh<_i986.SubscriptionPlanRepository>(),
      ),
    );
    gh.factory<_i837.GetSubscriptionRestaurantDetailsUseCase>(
      () => _i837.GetSubscriptionRestaurantDetailsUseCase(
        gh<_i986.SubscriptionPlanRepository>(),
      ),
    );
    gh.factory<_i903.GetSubscriptionTierRestaurantsUseCase>(
      () => _i903.GetSubscriptionTierRestaurantsUseCase(
        gh<_i986.SubscriptionPlanRepository>(),
      ),
    );
    gh.factory<_i101.GetSubscriptionTiersUseCase>(
      () => _i101.GetSubscriptionTiersUseCase(
        gh<_i986.SubscriptionPlanRepository>(),
      ),
    );
    gh.factory<_i527.SubscriptionPlanViewModel>(
      () => _i527.SubscriptionPlanViewModel(
        gh<_i275.GetSubscriptionDurationsUseCase>(),
        gh<_i101.GetSubscriptionTiersUseCase>(),
        gh<_i903.GetSubscriptionTierRestaurantsUseCase>(),
        gh<_i462.GetSubscriptionReadinessUseCase>(),
      ),
    );
    gh.factory<_i898.AddCustomerAddressUseCase>(
      () => _i898.AddCustomerAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i624.DeleteCustomerAddressUseCase>(
      () => _i624.DeleteCustomerAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i945.GetCustomerAddressesUseCase>(
      () => _i945.GetCustomerAddressesUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i2.GetLocationsCatalogUseCase>(
      () => _i2.GetLocationsCatalogUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i241.UpdateCustomerAddressUseCase>(
      () => _i241.UpdateCustomerAddressUseCase(gh<_i556.AddressesRepository>()),
    );
    gh.factory<_i502.PaymentViewModel>(
      () => _i502.PaymentViewModel(
        gh<_i365.GetPaymentMethodsUseCase>(),
        gh<_i895.CheckoutSubscriptionUseCase>(),
        gh<_i945.GetCustomerAddressesUseCase>(),
        gh<_i173.GetSubscriptionPaymentStatusUseCase>(),
      ),
    );
    gh.factory<_i420.SubscriptionProgramsViewModel>(
      () => _i420.SubscriptionProgramsViewModel(
        gh<_i178.GetSubscriptionProgramsUseCase>(),
        gh<_i718.GetSubscriptionProgramBundlesUseCase>(),
      ),
    );
    gh.factory<_i551.FamilyPlansViewModel>(
      () => _i551.FamilyPlansViewModel(
        gh<_i920.GetFamilyMetadataUseCase>(),
        gh<_i870.GetCurrentFamilyGroupUseCase>(),
        gh<_i189.UpdateFamilyGroupNameUseCase>(),
        gh<_i191.AddFamilyMemberUseCase>(),
        gh<_i728.UpdateFamilyMemberUseCase>(),
        gh<_i62.DeleteFamilyMemberUseCase>(),
        gh<_i71.UpdateFamilyMemberPlanUseCase>(),
        gh<_i515.GetFamilySummaryUseCase>(),
        gh<_i833.GetFamilyPaymentMethodsUseCase>(),
        gh<_i98.CheckoutFamilySubscriptionUseCase>(),
        gh<_i178.GetSubscriptionProgramsUseCase>(),
        gh<_i718.GetSubscriptionProgramBundlesUseCase>(),
        gh<_i275.GetSubscriptionDurationsUseCase>(),
        gh<_i101.GetSubscriptionTiersUseCase>(),
        gh<_i903.GetSubscriptionTierRestaurantsUseCase>(),
      ),
    );
    gh.factory<_i446.ProfileViewModel>(
      () => _i446.ProfileViewModel(
        gh<_i994.GetCustomerProfileUseCase>(),
        gh<_i768.GetProfileBillingUseCase>(),
        gh<_i857.UpdateCustomerProfileUseCase>(),
        gh<_i995.UploadFileUseCase>(),
        gh<_i399.UpdateCustomerProfileImageUseCase>(),
        gh<_i186.DeleteCustomerProfileImageUseCase>(),
      ),
    );
    gh.factory<_i524.AddressesViewModel>(
      () => _i524.AddressesViewModel(
        gh<_i945.GetCustomerAddressesUseCase>(),
        gh<_i2.GetLocationsCatalogUseCase>(),
        gh<_i898.AddCustomerAddressUseCase>(),
        gh<_i241.UpdateCustomerAddressUseCase>(),
        gh<_i624.DeleteCustomerAddressUseCase>(),
      ),
    );
    gh.factory<_i851.SubscriptionRestaurantDetailsViewModel>(
      () => _i851.SubscriptionRestaurantDetailsViewModel(
        gh<_i837.GetSubscriptionRestaurantDetailsUseCase>(),
      ),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
